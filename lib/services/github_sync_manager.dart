import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/github_repository.dart';
import '../repositories/task_repository.dart';
import 'github_service.dart';

/// Manager for bidirectional sync between tasks and GitHub
class GitHubSyncManager {
  final GitHubService _githubService;
  final TaskRepository _taskRepository;
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  final StreamController<SyncStatus> _syncStatusController = 
      StreamController<SyncStatus>.broadcast();
  
  GitHubSyncManager({
    required GitHubService githubService,
    required TaskRepository taskRepository,
  })  : _githubService = githubService,
        _taskRepository = taskRepository;

  /// Get sync status stream
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Start automatic sync with specified interval
  void startAutoSync(
    List<String> repositoryFullNames,
    int intervalMinutes, {
    bool bidirectional = false,
  }) {
    stopAutoSync();
    
    _syncTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) => performSync(
        repositoryFullNames,
        bidirectional: bidirectional,
      ),
    );
    
    // Perform initial sync
    performSync(repositoryFullNames, bidirectional: bidirectional);
  }

  /// Stop automatic sync
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Perform complete sync operation
  Future<SyncResult> performSync(
    List<String> repositoryFullNames, {
    bool bidirectional = false,
    String? userId,
  }) async {
    if (_isSyncing) {
      debugPrint('Sync already in progress, skipping...');
      return SyncResult(
        success: false,
        message: 'Sync already in progress',
      );
    }

    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      final result = SyncResult();
      
      // Step 1: Import from GitHub to Tasks
      final importResult = await _importFromGitHub(
        repositoryFullNames,
        userId ?? 'default_user',
      );
      result.merge(importResult);

      // Step 2: If bidirectional, push local changes to GitHub
      if (bidirectional) {
        final exportResult = await _exportToGitHub(repositoryFullNames);
        result.merge(exportResult);
      }

      _lastSyncTime = DateTime.now();
      _syncStatusController.add(SyncStatus.completed);
      
      debugPrint('Sync completed: ${result.message}');
      return result;
    } catch (e) {
      debugPrint('Sync failed: $e');
      _syncStatusController.add(SyncStatus.failed);
      
      return SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Import issues and PRs from GitHub to local tasks
  Future<SyncResult> _importFromGitHub(
    List<String> repositoryFullNames,
    String userId,
  ) async {
    final result = SyncResult();

    try {
      // Fetch issues
      final issues = await _githubService.getIssuesFromRepositories(
        repositoryFullNames,
      );
      
      // Fetch pull requests
      final prs = await _githubService.getPullRequestsFromRepositories(
        repositoryFullNames,
      );

      // Convert and save issues as tasks
      for (final issue in issues) {
        try {
          final task = _githubService.issueToTask(issue, userId);
          
          // Check if task already exists
          final existingTask = await _findTaskByExternalId(
            'github',
            '${issue.repositoryFullName}#${issue.number}',
          );

          if (existingTask != null) {
            // Update existing task
            final updated = await _updateTaskFromGitHub(existingTask, task);
            if (updated) {
              result.tasksUpdated++;
            }
          } else {
            // Create new task
            await _taskRepository.createTask(task);
            result.tasksCreated++;
          }
        } catch (e) {
          debugPrint('Error importing issue ${issue.number}: $e');
          result.errors.add('Issue ${issue.number}: ${e.toString()}');
        }
      }

      // Convert and save PRs as tasks
      for (final pr in prs) {
        try {
          final task = _githubService.pullRequestToTask(pr, userId);
          
          final existingTask = await _findTaskByExternalId(
            'github',
            '${pr.repositoryFullName}#${pr.number}',
          );

          if (existingTask != null) {
            final updated = await _updateTaskFromGitHub(existingTask, task);
            if (updated) {
              result.tasksUpdated++;
            }
          } else {
            await _taskRepository.createTask(task);
            result.tasksCreated++;
          }
        } catch (e) {
          debugPrint('Error importing PR ${pr.number}: $e');
          result.errors.add('PR ${pr.number}: ${e.toString()}');
        }
      }

      result.success = true;
      return result;
    } catch (e) {
      result.success = false;
      result.errors.add('Import failed: ${e.toString()}');
      return result;
    }
  }

  /// Export local task changes to GitHub
  Future<SyncResult> _exportToGitHub(List<String> repositoryFullNames) async {
    final result = SyncResult();

    try {
      // Get all tasks that are linked to GitHub
      final allTasks = await _taskRepository.getAllTasks();
      final githubTasks = allTasks.where(
        (task) => task.externalSource == 'github' && task.externalId != null,
      ).toList();

      for (final task in githubTasks) {
        try {
          // Parse repository and issue number from externalId
          final parts = task.externalId!.split('#');
          if (parts.length != 2) continue;

          final repoFullName = parts[0];
          final issueNumber = int.tryParse(parts[1]);
          if (issueNumber == null) continue;

          // Check if this repository is in our sync list
          if (!repositoryFullNames.contains(repoFullName)) continue;

          // Parse owner and repo name
          final repoParts = repoFullName.split('/');
          if (repoParts.length != 2) continue;

          final owner = repoParts[0];
          final repoName = repoParts[1];

          // Update the issue on GitHub based on task status
          final updated = await _updateGitHubIssue(
            owner,
            repoName,
            issueNumber,
            task,
          );

          if (updated) {
            result.issuesUpdated++;
          }
        } catch (e) {
          debugPrint('Error exporting task ${task.id}: $e');
          result.errors.add('Task ${task.title}: ${e.toString()}');
        }
      }

      result.success = true;
      return result;
    } catch (e) {
      result.success = false;
      result.errors.add('Export failed: ${e.toString()}');
      return result;
    }
  }

  /// Update GitHub issue based on task changes
  Future<bool> _updateGitHubIssue(
    String owner,
    String repoName,
    int issueNumber,
    Task task,
  ) async {
    try {
      // Map task status to GitHub state
      final state = _mapTaskStatusToGitHubState(task.status);
      
      // Map task priority and tags to labels
      final labels = _mapTaskToGitHubLabels(task);

      // Update the issue
      await _githubService.updateIssue(
        owner,
        repoName,
        issueNumber,
        task.title,
        task.description,
        state: state,
        labels: labels,
      );

      return true;
    } catch (e) {
      debugPrint('Error updating GitHub issue: $e');
      return false;
    }
  }

  /// Map task status to GitHub issue state
  String _mapTaskStatusToGitHubState(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return 'closed';
      case TaskStatus.cancelled:
        return 'closed';
      case TaskStatus.todo:
      case TaskStatus.inProgress:
      default:
        return 'open';
    }
  }

  /// Map task to GitHub labels
  List<String> _mapTaskToGitHubLabels(Task task) {
    final labels = <String>[...task.tags];

    // Add priority label
    switch (task.priority) {
      case TaskPriority.urgent:
        labels.add('priority: urgent');
        break;
      case TaskPriority.high:
        labels.add('priority: high');
        break;
      case TaskPriority.low:
        labels.add('priority: low');
        break;
      case TaskPriority.medium:
      default:
        // Don't add label for medium priority
        break;
    }

    // Add status label
    switch (task.status) {
      case TaskStatus.inProgress:
        labels.add('status: in progress');
        break;
      case TaskStatus.completed:
        labels.add('status: completed');
        break;
      default:
        break;
    }

    return labels;
  }

  /// Update existing task from GitHub data
  Future<bool> _updateTaskFromGitHub(Task existingTask, Task githubTask) async {
    // Only update if GitHub version is newer
    if (githubTask.updatedAt != null && existingTask.updatedAt != null) {
      if (githubTask.updatedAt!.isBefore(existingTask.updatedAt!)) {
        return false; // Local version is newer
      }
    }

    // Merge the tasks, preferring GitHub data but keeping local-only fields
    final updatedTask = existingTask.copyWith(
      title: githubTask.title,
      description: githubTask.description,
      status: githubTask.status,
      priority: githubTask.priority,
      tags: githubTask.tags,
      externalUrl: githubTask.externalUrl,
      updatedAt: githubTask.updatedAt ?? DateTime.now(),
    );

    await _taskRepository.updateTask(updatedTask);
    return true;
  }

  /// Find task by external ID
  Future<Task?> _findTaskByExternalId(
    String source,
    String externalId,
  ) async {
    final allTasks = await _taskRepository.getAllTasks();
    
    try {
      return allTasks.firstWhere(
        (task) => 
            task.externalSource == source && 
            task.externalId == externalId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Sync a single task to GitHub
  Future<bool> syncTaskToGitHub(Task task) async {
    if (task.externalSource != 'github' || task.externalId == null) {
      return false;
    }

    try {
      final parts = task.externalId!.split('#');
      if (parts.length != 2) return false;

      final repoFullName = parts[0];
      final issueNumber = int.tryParse(parts[1]);
      if (issueNumber == null) return false;

      final repoParts = repoFullName.split('/');
      if (repoParts.length != 2) return false;

      return await _updateGitHubIssue(
        repoParts[0],
        repoParts[1],
        issueNumber,
        task,
      );
    } catch (e) {
      debugPrint('Error syncing task to GitHub: $e');
      return false;
    }
  }

  /// Add comment to GitHub issue from task
  Future<bool> addCommentToGitHub(Task task, String comment) async {
    if (task.externalSource != 'github' || task.externalId == null) {
      return false;
    }

    try {
      final parts = task.externalId!.split('#');
      if (parts.length != 2) return false;

      final repoFullName = parts[0];
      final issueNumber = int.tryParse(parts[1]);
      if (issueNumber == null) return false;

      final repoParts = repoFullName.split('/');
      if (repoParts.length != 2) return false;

      return await _githubService.addIssueComment(
        repoParts[0],
        repoParts[1],
        issueNumber,
        comment,
      );
    } catch (e) {
      debugPrint('Error adding comment to GitHub: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}

/// Result of a sync operation
class SyncResult {
  bool success;
  int tasksCreated;
  int tasksUpdated;
  int issuesUpdated;
  List<String> errors;

  SyncResult({
    this.success = false,
    this.tasksCreated = 0,
    this.tasksUpdated = 0,
    this.issuesUpdated = 0,
    List<String>? errors,
  }) : errors = errors ?? [];

  /// Merge another result into this one
  void merge(SyncResult other) {
    tasksCreated += other.tasksCreated;
    tasksUpdated += other.tasksUpdated;
    issuesUpdated += other.issuesUpdated;
    errors.addAll(other.errors);
    success = success && other.success;
  }

  /// Get summary message
  String get message {
    if (!success && errors.isNotEmpty) {
      return 'Failed: ${errors.first}';
    }
    
    final parts = <String>[];
    if (tasksCreated > 0) parts.add('$tasksCreated created');
    if (tasksUpdated > 0) parts.add('$tasksUpdated updated');
    if (issuesUpdated > 0) parts.add('$issuesUpdated issues synced');
    
    if (parts.isEmpty) return 'No changes';
    return parts.join(', ');
  }

  /// Check if there were any changes
  bool get hasChanges => 
      tasksCreated > 0 || tasksUpdated > 0 || issuesUpdated > 0;
}
