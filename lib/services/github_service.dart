import 'dart:async';
import 'package:github/github.dart';
import 'package:flutter/foundation.dart';
import '../models/github_repository.dart' as models;
import '../models/task.dart' as task_models;

/// Service for GitHub integration
class GitHubService {
  GitHub? _github;
  StreamController<List<models.GitHubIssue>>? _issuesController;
  StreamController<List<models.GitHubPullRequest>>? _pullRequestsController;
  Timer? _syncTimer;

  /// Initialize GitHub client with access token
  Future<void> initialize(String accessToken) async {
    _github = GitHub(auth: Authentication.withToken(accessToken));
    debugPrint('GitHub service initialized');
  }

  /// Check if GitHub client is initialized
  bool get isInitialized => _github != null;

  /// Get authenticated user
  Future<CurrentUser?> getCurrentUser() async {
    if (_github == null) return null;
    try {
      return await _github!.users.getCurrentUser();
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Get user repositories
  Future<List<models.GitHubRepository>> getUserRepositories() async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final user = await getCurrentUser();
      if (user == null) throw Exception('User not authenticated');

      final repos = await _github!.repositories
          .listUserRepositories(user.login!)
          .toList();
      return repos.map((repo) => _convertToRepositoryModel(repo)).toList();
    } catch (e) {
      debugPrint('Error fetching repositories: $e');
      rethrow;
    }
  }

  /// Get issues from a repository
  Future<List<models.GitHubIssue>> getRepositoryIssues(
    String owner,
    String repoName, {
    String state = 'open',
  }) async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      final issues = await _github!.issues
          .listByRepo(slug, state: state)
          .where((issue) => issue.pullRequest == null) // Filter out PRs
          .toList();

      return issues
          .map((issue) => _convertToIssueModel(issue, '$owner/$repoName'))
          .toList();
    } catch (e) {
      debugPrint('Error fetching issues: $e');
      rethrow;
    }
  }

  /// Get pull requests from a repository
  Future<List<models.GitHubPullRequest>> getRepositoryPullRequests(
    String owner,
    String repoName, {
    String state = 'open',
  }) async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      final prs = await _github!.pullRequests.list(slug, state: state).toList();

      return prs
          .map((pr) => _convertToPullRequestModel(pr, '$owner/$repoName'))
          .toList();
    } catch (e) {
      debugPrint('Error fetching pull requests: $e');
      rethrow;
    }
  }

  /// Get issues from multiple repositories
  Future<List<models.GitHubIssue>> getIssuesFromRepositories(
    List<String> repositoryFullNames,
  ) async {
    final allIssues = <models.GitHubIssue>[];

    for (final fullName in repositoryFullNames) {
      final parts = fullName.split('/');
      if (parts.length != 2) continue;

      try {
        final issues = await getRepositoryIssues(parts[0], parts[1]);
        allIssues.addAll(issues);
      } catch (e) {
        debugPrint('Error fetching issues from $fullName: $e');
      }
    }

    return allIssues;
  }

  /// Get pull requests from multiple repositories
  Future<List<models.GitHubPullRequest>> getPullRequestsFromRepositories(
    List<String> repositoryFullNames,
  ) async {
    final allPRs = <models.GitHubPullRequest>[];

    for (final fullName in repositoryFullNames) {
      final parts = fullName.split('/');
      if (parts.length != 2) continue;

      try {
        final prs = await getRepositoryPullRequests(parts[0], parts[1]);
        allPRs.addAll(prs);
      } catch (e) {
        debugPrint('Error fetching pull requests from $fullName: $e');
      }
    }

    return allPRs;
  }

  /// Create a GitHub issue
  Future<models.GitHubIssue?> createIssue(
    String owner,
    String repoName,
    String title,
    String? body, {
    List<String>? labels,
    String? assignee,
  }) async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      final issueRequest = IssueRequest(
        title: title,
        body: body,
        labels: labels,
        assignee: assignee,
      );

      final issue = await _github!.issues.create(slug, issueRequest);
      return _convertToIssueModel(issue, '$owner/$repoName');
    } catch (e) {
      debugPrint('Error creating issue: $e');
      return null;
    }
  }

  /// Update a GitHub issue
  Future<models.GitHubIssue?> updateIssue(
    String owner,
    String repoName,
    int issueNumber,
    String title,
    String? body, {
    String? state,
    List<String>? labels,
  }) async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      final issueRequest = IssueRequest(
        title: title,
        body: body,
        state: state,
        labels: labels,
      );

      final issue = await _github!.issues.edit(slug, issueNumber, issueRequest);
      return _convertToIssueModel(issue, '$owner/$repoName');
    } catch (e) {
      debugPrint('Error updating issue: $e');
      return null;
    }
  }

  /// Add comment to an issue
  Future<bool> addIssueComment(
    String owner,
    String repoName,
    int issueNumber,
    String comment,
  ) async {
    if (_github == null) {
      throw Exception('GitHub client not initialized');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      await _github!.issues.createComment(slug, issueNumber, comment);
      return true;
    } catch (e) {
      debugPrint('Error adding comment: $e');
      return false;
    }
  }

  /// Start periodic sync
  void startPeriodicSync(
    List<String> repositoryFullNames,
    int intervalMinutes,
  ) {
    _syncTimer?.cancel();
    _issuesController ??=
        StreamController<List<models.GitHubIssue>>.broadcast();
    _pullRequestsController ??=
        StreamController<List<models.GitHubPullRequest>>.broadcast();

    _syncTimer = Timer.periodic(Duration(minutes: intervalMinutes), (_) async {
      await _performSync(repositoryFullNames);
    });

    // Perform initial sync
    _performSync(repositoryFullNames);
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Get issues stream
  Stream<List<models.GitHubIssue>>? get issuesStream =>
      _issuesController?.stream;

  /// Get pull requests stream
  Stream<List<models.GitHubPullRequest>>? get pullRequestsStream =>
      _pullRequestsController?.stream;

  /// Perform sync
  Future<void> _performSync(List<String> repositoryFullNames) async {
    try {
      final issues = await getIssuesFromRepositories(repositoryFullNames);
      final prs = await getPullRequestsFromRepositories(repositoryFullNames);

      _issuesController?.add(issues);
      _pullRequestsController?.add(prs);
    } catch (e) {
      debugPrint('Error during sync: $e');
    }
  }

  /// Convert GitHub issue to Task model
  task_models.Task issueToTask(models.GitHubIssue issue, String userId) {
    return task_models.Task(
      id: 'github_issue_${issue.number}_${issue.repositoryFullName}',
      title: issue.title,
      description: issue.body ?? '',
      userId: userId,
      status: issue.state == 'closed'
          ? task_models.TaskStatus.completed
          : task_models.TaskStatus.todo,
      priority: _determinePriorityFromLabels(issue.labels),
      tags: issue.labels ?? [],
      externalSource: 'github',
      externalId: '${issue.repositoryFullName}#${issue.number}',
      externalUrl: issue.htmlUrl,
      createdAt: issue.createdAt ?? DateTime.now(),
      updatedAt: issue.updatedAt ?? DateTime.now(),
    );
  }

  /// Convert pull request to Task model
  task_models.Task pullRequestToTask(
    models.GitHubPullRequest pr,
    String userId,
  ) {
    return task_models.Task(
      id: 'github_pr_${pr.number}_${pr.repositoryFullName}',
      title: '${pr.isDraft == true ? '[DRAFT] ' : ''}PR: ${pr.title}',
      description: pr.body ?? '',
      userId: userId,
      status: pr.isMerged == true
          ? task_models.TaskStatus.completed
          : pr.state == 'closed'
          ? task_models.TaskStatus.cancelled
          : task_models.TaskStatus.inProgress,
      priority: pr.isDraft == true
          ? task_models.TaskPriority.low
          : _determinePriorityFromLabels(pr.labels),
      tags: pr.labels ?? [],
      externalSource: 'github',
      externalId: '${pr.repositoryFullName}#${pr.number}',
      externalUrl: pr.htmlUrl,
      createdAt: pr.createdAt ?? DateTime.now(),
      updatedAt: pr.updatedAt ?? DateTime.now(),
    );
  }

  /// Determine task priority from GitHub labels
  task_models.TaskPriority _determinePriorityFromLabels(List<String>? labels) {
    if (labels == null || labels.isEmpty) {
      return task_models.TaskPriority.medium;
    }

    final labelSet = labels.map((l) => l.toLowerCase()).toSet();

    if (labelSet.any((l) => l.contains('urgent') || l.contains('critical'))) {
      return task_models.TaskPriority.urgent;
    } else if (labelSet.any(
      (l) => l.contains('high') || l.contains('important'),
    )) {
      return task_models.TaskPriority.high;
    } else if (labelSet.any((l) => l.contains('low') || l.contains('minor'))) {
      return task_models.TaskPriority.low;
    }

    return task_models.TaskPriority.medium;
  }

  /// Convert GitHub repository to model
  models.GitHubRepository _convertToRepositoryModel(Repository repo) {
    return models.GitHubRepository(
      id: repo.id.toString(),
      name: repo.name,
      fullName: repo.fullName,
      owner: repo.owner?.login ?? '',
      description: repo.description,
      isPrivate: repo.isPrivate,
      htmlUrl: repo.htmlUrl,
      defaultBranch: repo.defaultBranch,
      openIssuesCount: repo.openIssuesCount,
      stargazersCount: repo.stargazersCount,
      forksCount: repo.forksCount,
      createdAt: repo.createdAt,
      updatedAt: repo.updatedAt,
      pushedAt: repo.pushedAt,
    );
  }

  /// Convert GitHub issue to model
  models.GitHubIssue _convertToIssueModel(Issue issue, String repoFullName) {
    return models.GitHubIssue(
      number: issue.number,
      title: issue.title,
      body: issue.body,
      state: issue.state,
      htmlUrl: issue.htmlUrl,
      createdAt: issue.createdAt,
      updatedAt: issue.updatedAt,
      closedAt: issue.closedAt,
      labels: issue.labels.map((l) => l.name).toList(),
      assignee: issue.assignee?.login,
      commentsCount: issue.commentsCount,
      repositoryFullName: repoFullName,
      isPullRequest: issue.pullRequest != null,
    );
  }

  /// Convert GitHub pull request to model
  models.GitHubPullRequest _convertToPullRequestModel(
    PullRequest pr,
    String repoFullName,
  ) {
    return models.GitHubPullRequest(
      number: pr.number!,
      title: pr.title!,
      body: pr.body,
      state: pr.state!,
      htmlUrl: pr.htmlUrl!,
      createdAt: pr.createdAt,
      updatedAt: pr.updatedAt,
      mergedAt: pr.mergedAt,
      closedAt: pr.closedAt,
      labels: pr.labels?.map((l) => l.name).toList(),
      assignee: null, // PR assignee not directly available in this API
      headBranch: pr.head?.ref,
      baseBranch: pr.base?.ref,
      isDraft: pr.draft,
      isMerged: pr.merged,
      commentsCount: pr.commentsCount,
      reviewCommentsCount: null, // Not directly available in list API
      commitsCount: null, // Not directly available in list API
      repositoryFullName: repoFullName,
    );
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _issuesController?.close();
    _pullRequestsController?.close();
  }
}
