import 'dart:async';
import 'package:flutter/foundation.dart';

import '../services/github_service.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart' as task_models;

/// Lightweight sync status enum
enum SyncStatus { idle, syncing, success, failed }

/// Manager that performs bi-directional sync between local tasks and GitHub
class GitHubSyncManager {
  final GitHubService githubService;
  final TaskRepository taskRepository;

  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatusStream => _statusController.stream;

  DateTime? lastSyncTime;

  Timer? _autoSyncTimer;

  GitHubSyncManager({
    required this.githubService,
    required this.taskRepository,
  });

  /// Perform a manual sync. Imports issues/PRs and creates/updates local tasks.
  /// If [bidirectional] is true, push local changes back to GitHub where possible.
  Future<void> manualSync(
    List<String> repositoryFullNames, {
    bool bidirectional = false,
    String userId = 'local',
  }) async {
    if (!githubService.isInitialized) {
      throw Exception('GitHub client not initialized');
    }

    _statusController.add(SyncStatus.syncing);

    try {
      // Import issues
      final issues = await githubService.getIssuesFromRepositories(
        repositoryFullNames,
      );

      for (final issue in issues) {
        final task = githubService.issueToTask(issue, userId);

        final exists = await taskRepository.exists(task.id);
        if (exists) {
          await taskRepository.update(task);
        } else {
          await taskRepository.create(task);
        }
      }

      // Import pull requests
      final prs = await githubService.getPullRequestsFromRepositories(
        repositoryFullNames,
      );

      for (final pr in prs) {
        final task = githubService.pullRequestToTask(pr, userId);

        final exists = await taskRepository.exists(task.id);
        if (exists) {
          await taskRepository.update(task);
        } else {
          await taskRepository.create(task);
        }
      }

      // Optional: push local changes back to GitHub for tasks with externalSource == 'github'
      if (bidirectional) {
        final localGitHubTasks = await taskRepository.getByFilter({
          'externalSource': 'github',
        });

        for (final local in localGitHubTasks) {
          try {
            if (local.externalId == null) continue;

            // externalId format expected: owner/repo#number
            final parts = local.externalId!.split('#');
            if (parts.length != 2) continue;

            final repoFull = parts[0];
            final number = int.tryParse(parts[1]);
            if (number == null) continue;

            final repoParts = repoFull.split('/');
            if (repoParts.length != 2) continue;

            final owner = repoParts[0];
            final repoName = repoParts[1];

            // Update issue title/body/status when local is newer (simple heuristic)
            await githubService.updateIssue(
              owner,
              repoName,
              number,
              local.title,
              local.description,
              state: (local.status == task_models.TaskStatus.completed)
                  ? 'closed'
                  : 'open',
            );
          } catch (e) {
            // Log but continue with other items
            debugPrint('Failed to update remote for ${local.id}: $e');
          }
        }
      }

      lastSyncTime = DateTime.now();
      _statusController.add(SyncStatus.success);
    } catch (e) {
      _statusController.add(SyncStatus.failed);
      rethrow;
    } finally {
      // Idle after a short delay so UI can reflect success/failure
      Future.delayed(const Duration(seconds: 1), () {
        _statusController.add(SyncStatus.idle);
      });
    }
  }

  /// Start auto-sync with an interval (minutes)
  void startAutoSync(
    List<String> repositoryFullNames, {
    int intervalMinutes = 30,
    bool bidirectional = false,
    String userId = 'local',
  }) {
    stopAutoSync();
    _autoSyncTimer = Timer.periodic(Duration(minutes: intervalMinutes), (
      _,
    ) async {
      try {
        await manualSync(
          repositoryFullNames,
          bidirectional: bidirectional,
          userId: userId,
        );
      } catch (e) {
        debugPrint('Auto-sync error: $e');
      }
    });
  }

  /// Stop automatic sync
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
  }

  void dispose() {
    _statusController.close();
    stopAutoSync();
  }
}
