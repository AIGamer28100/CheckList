/// Model representing a GitHub repository
class GitHubRepository {
  final String id;
  final String name;
  final String fullName;
  final String owner;
  final String? description;
  final bool isPrivate;
  final String htmlUrl;
  final String? defaultBranch;
  final int? openIssuesCount;
  final int? stargazersCount;
  final int? forksCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? pushedAt;
  final bool isSelected;

  GitHubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    this.description,
    required this.isPrivate,
    required this.htmlUrl,
    this.defaultBranch,
    this.openIssuesCount,
    this.stargazersCount,
    this.forksCount,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.isSelected = false,
  });

  GitHubRepository copyWith({
    String? id,
    String? name,
    String? fullName,
    String? owner,
    String? description,
    bool? isPrivate,
    String? htmlUrl,
    String? defaultBranch,
    int? openIssuesCount,
    int? stargazersCount,
    int? forksCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? pushedAt,
    bool? isSelected,
  }) {
    return GitHubRepository(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      isPrivate: isPrivate ?? this.isPrivate,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      openIssuesCount: openIssuesCount ?? this.openIssuesCount,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      forksCount: forksCount ?? this.forksCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pushedAt: pushedAt ?? this.pushedAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'owner': owner,
      'description': description,
      'isPrivate': isPrivate,
      'htmlUrl': htmlUrl,
      'defaultBranch': defaultBranch,
      'openIssuesCount': openIssuesCount,
      'stargazersCount': stargazersCount,
      'forksCount': forksCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'pushedAt': pushedAt?.toIso8601String(),
      'isSelected': isSelected,
    };
  }

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      owner: json['owner'] as String,
      description: json['description'] as String?,
      isPrivate: json['isPrivate'] as bool,
      htmlUrl: json['htmlUrl'] as String,
      defaultBranch: json['defaultBranch'] as String?,
      openIssuesCount: json['openIssuesCount'] as int?,
      stargazersCount: json['stargazersCount'] as int?,
      forksCount: json['forksCount'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      pushedAt: json['pushedAt'] != null
          ? DateTime.parse(json['pushedAt'] as String)
          : null,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }
}

/// Model representing a GitHub Issue
class GitHubIssue {
  final int number;
  final String title;
  final String? body;
  final String state;
  final String? htmlUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<String>? labels;
  final String? assignee;
  final int? commentsCount;
  final String? repositoryFullName;
  final bool? isPullRequest;

  GitHubIssue({
    required this.number,
    required this.title,
    this.body,
    required this.state,
    this.htmlUrl,
    this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.labels,
    this.assignee,
    this.commentsCount,
    this.repositoryFullName,
    this.isPullRequest,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'body': body,
      'state': state,
      'htmlUrl': htmlUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'labels': labels,
      'assignee': assignee,
      'commentsCount': commentsCount,
      'repositoryFullName': repositoryFullName,
      'isPullRequest': isPullRequest,
    };
  }

  factory GitHubIssue.fromJson(Map<String, dynamic> json) {
    return GitHubIssue(
      number: json['number'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      state: json['state'] as String,
      htmlUrl: json['htmlUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'] as String)
          : null,
      labels: json['labels'] != null
          ? List<String>.from(json['labels'] as List)
          : null,
      assignee: json['assignee'] as String?,
      commentsCount: json['commentsCount'] as int?,
      repositoryFullName: json['repositoryFullName'] as String?,
      isPullRequest: json['isPullRequest'] as bool?,
    );
  }
}

/// Model representing a GitHub Pull Request
class GitHubPullRequest {
  final int number;
  final String title;
  final String? body;
  final String state;
  final String? htmlUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? mergedAt;
  final DateTime? closedAt;
  final List<String>? labels;
  final String? assignee;
  final String? headBranch;
  final String? baseBranch;
  final bool? isDraft;
  final bool? isMerged;
  final int? commentsCount;
  final int? reviewCommentsCount;
  final int? commitsCount;
  final String? repositoryFullName;

  GitHubPullRequest({
    required this.number,
    required this.title,
    this.body,
    required this.state,
    this.htmlUrl,
    this.createdAt,
    this.updatedAt,
    this.mergedAt,
    this.closedAt,
    this.labels,
    this.assignee,
    this.headBranch,
    this.baseBranch,
    this.isDraft,
    this.isMerged,
    this.commentsCount,
    this.reviewCommentsCount,
    this.commitsCount,
    this.repositoryFullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'body': body,
      'state': state,
      'htmlUrl': htmlUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'mergedAt': mergedAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'labels': labels,
      'assignee': assignee,
      'headBranch': headBranch,
      'baseBranch': baseBranch,
      'isDraft': isDraft,
      'isMerged': isMerged,
      'commentsCount': commentsCount,
      'reviewCommentsCount': reviewCommentsCount,
      'commitsCount': commitsCount,
      'repositoryFullName': repositoryFullName,
    };
  }

  factory GitHubPullRequest.fromJson(Map<String, dynamic> json) {
    return GitHubPullRequest(
      number: json['number'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      state: json['state'] as String,
      htmlUrl: json['htmlUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      mergedAt: json['mergedAt'] != null
          ? DateTime.parse(json['mergedAt'] as String)
          : null,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'] as String)
          : null,
      labels: json['labels'] != null
          ? List<String>.from(json['labels'] as List)
          : null,
      assignee: json['assignee'] as String?,
      headBranch: json['headBranch'] as String?,
      baseBranch: json['baseBranch'] as String?,
      isDraft: json['isDraft'] as bool?,
      isMerged: json['isMerged'] as bool?,
      commentsCount: json['commentsCount'] as int?,
      reviewCommentsCount: json['reviewCommentsCount'] as int?,
      commitsCount: json['commitsCount'] as int?,
      repositoryFullName: json['repositoryFullName'] as String?,
    );
  }
}

/// Model representing GitHub integration settings
class GitHubIntegrationSettings {
  final String? accessToken;
  final List<String>? selectedRepositories;
  final bool syncIssues;
  final bool syncPullRequests;
  final bool syncProjectBoards;
  final int syncIntervalMinutes;
  final bool createTasksForIssues;
  final bool createTasksForPRs;
  final bool bidirectionalSync;
  final DateTime? lastSyncTime;

  GitHubIntegrationSettings({
    this.accessToken,
    this.selectedRepositories,
    this.syncIssues = true,
    this.syncPullRequests = true,
    this.syncProjectBoards = false,
    this.syncIntervalMinutes = 30,
    this.createTasksForIssues = true,
    this.createTasksForPRs = true,
    this.bidirectionalSync = false,
    this.lastSyncTime,
  });

  GitHubIntegrationSettings copyWith({
    String? accessToken,
    List<String>? selectedRepositories,
    bool? syncIssues,
    bool? syncPullRequests,
    bool? syncProjectBoards,
    int? syncIntervalMinutes,
    bool? createTasksForIssues,
    bool? createTasksForPRs,
    bool? bidirectionalSync,
    DateTime? lastSyncTime,
  }) {
    return GitHubIntegrationSettings(
      accessToken: accessToken ?? this.accessToken,
      selectedRepositories: selectedRepositories ?? this.selectedRepositories,
      syncIssues: syncIssues ?? this.syncIssues,
      syncPullRequests: syncPullRequests ?? this.syncPullRequests,
      syncProjectBoards: syncProjectBoards ?? this.syncProjectBoards,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      createTasksForIssues: createTasksForIssues ?? this.createTasksForIssues,
      createTasksForPRs: createTasksForPRs ?? this.createTasksForPRs,
      bidirectionalSync: bidirectionalSync ?? this.bidirectionalSync,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'selectedRepositories': selectedRepositories,
      'syncIssues': syncIssues,
      'syncPullRequests': syncPullRequests,
      'syncProjectBoards': syncProjectBoards,
      'syncIntervalMinutes': syncIntervalMinutes,
      'createTasksForIssues': createTasksForIssues,
      'createTasksForPRs': createTasksForPRs,
      'bidirectionalSync': bidirectionalSync,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
    };
  }

  factory GitHubIntegrationSettings.fromJson(Map<String, dynamic> json) {
    return GitHubIntegrationSettings(
      accessToken: json['accessToken'] as String?,
      selectedRepositories: json['selectedRepositories'] != null
          ? List<String>.from(json['selectedRepositories'] as List)
          : null,
      syncIssues: json['syncIssues'] as bool? ?? true,
      syncPullRequests: json['syncPullRequests'] as bool? ?? true,
      syncProjectBoards: json['syncProjectBoards'] as bool? ?? false,
      syncIntervalMinutes: json['syncIntervalMinutes'] as int? ?? 30,
      createTasksForIssues: json['createTasksForIssues'] as bool? ?? true,
      createTasksForPRs: json['createTasksForPRs'] as bool? ?? true,
      bidirectionalSync: json['bidirectionalSync'] as bool? ?? false,
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.parse(json['lastSyncTime'] as String)
          : null,
    );
  }
}
