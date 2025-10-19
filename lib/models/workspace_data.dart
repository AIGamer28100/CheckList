import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_data.freezed.dart';
part 'workspace_data.g.dart';

/// Workspace theme settings
@freezed
class WorkspaceTheme with _$WorkspaceTheme {
  const factory WorkspaceTheme({
    @Default('blue') String primaryColor,
    @Default('system') String themeMode, // 'light', 'dark', 'system'
    @Default(true) bool useMaterial3,
    @Default(true) bool useDynamicColor,
    String? customFontFamily,
    @Default(1.0) double textScaleFactor,
    @Default({}) Map<String, dynamic> customColors,
  }) = _WorkspaceTheme;

  factory WorkspaceTheme.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceThemeFromJson(json);
}

/// Workspace integration settings
@freezed
class WorkspaceIntegrations with _$WorkspaceIntegrations {
  const factory WorkspaceIntegrations({
    @Default(false) bool gitHubEnabled,
    String? gitHubRepoUrl,
    String? gitHubToken,
    @Default(false) bool calendarEnabled,
    String? calendarId,
    @Default(false) bool slackEnabled,
    String? slackWebhookUrl,
    @Default(false) bool notionEnabled,
    String? notionToken,
    String? notionDatabaseId,
    @Default({}) Map<String, dynamic> customIntegrations,
  }) = _WorkspaceIntegrations;

  factory WorkspaceIntegrations.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceIntegrationsFromJson(json);
}

/// Workspace member with role and permissions
@freezed
class WorkspaceMember with _$WorkspaceMember {
  const factory WorkspaceMember({
    required String userId,
    required String email,
    String? displayName,
    String? avatarUrl,
    @Default('member') String role, // 'owner', 'admin', 'member', 'viewer'
    @Default([]) List<String> permissions,
    required DateTime joinedAt,
    DateTime? lastActiveAt,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkspaceMember;

  factory WorkspaceMember.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceMemberFromJson(json);
}

/// Workspace data model for managing projects and teams
@freezed
class WorkspaceData with _$WorkspaceData {
  const factory WorkspaceData({
    required String id,
    required String name,
    String? description,
    String? iconUrl,
    String? coverImageUrl,
    @Default(WorkspaceTheme()) WorkspaceTheme theme,
    @Default(WorkspaceIntegrations()) WorkspaceIntegrations integrations,
    @Default([]) List<WorkspaceMember> members,
    required String ownerId,
    @Default(false) bool isPersonal,
    @Default(false) bool isArchived,
    @Default([]) List<String> taskIds,
    @Default([]) List<String> noteIds,
    @Default([]) List<String> categoryIds,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastAccessedAt,
    @Default(0) int sortOrder,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkspaceData;

  factory WorkspaceData.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceDataFromJson(json);
}

/// Extension methods for WorkspaceData
extension WorkspaceDataExtensions on WorkspaceData {
  /// Check if user is the owner of the workspace
  bool isOwner(String userId) => ownerId == userId;

  /// Check if user is a member of the workspace
  bool isMember(String userId) {
    return ownerId == userId ||
        members.any((member) => member.userId == userId && member.isActive);
  }

  /// Get member by user ID
  WorkspaceMember? getMember(String userId) {
    try {
      return members.firstWhere(
        (member) => member.userId == userId && member.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get user role in workspace
  String getUserRole(String userId) {
    if (isOwner(userId)) return 'owner';
    final member = getMember(userId);
    return member?.role ?? 'none';
  }

  /// Check if user has specific permission
  bool hasPermission(String userId, String permission) {
    if (isOwner(userId)) return true;
    final member = getMember(userId);
    if (member == null) return false;

    // Admin role has all permissions
    if (member.role == 'admin') return true;

    return member.permissions.contains(permission);
  }

  /// Get active members count
  int get activeMembersCount {
    return members.where((member) => member.isActive).length +
        1; // +1 for owner
  }

  /// Get total tasks count
  int get tasksCount => taskIds.length;

  /// Get total notes count
  int get notesCount => noteIds.length;

  /// Get total categories count
  int get categoriesCount => categoryIds.length;

  /// Check if workspace has been accessed recently (within last 7 days)
  bool get isRecentlyAccessed {
    if (lastAccessedAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastAccessedAt!);
    return difference.inDays <= 7;
  }

  /// Check if any integrations are enabled
  bool get hasIntegrations {
    return integrations.gitHubEnabled ||
        integrations.calendarEnabled ||
        integrations.slackEnabled ||
        integrations.notionEnabled ||
        integrations.customIntegrations.isNotEmpty;
  }

  /// Archive the workspace
  WorkspaceData archive() {
    return copyWith(isArchived: true, updatedAt: DateTime.now());
  }

  /// Unarchive the workspace
  WorkspaceData unarchive() {
    return copyWith(isArchived: false, updatedAt: DateTime.now());
  }

  /// Update last accessed timestamp
  WorkspaceData updateLastAccessed() {
    return copyWith(lastAccessedAt: DateTime.now());
  }

  /// Add a new member to the workspace
  WorkspaceData addMember(WorkspaceMember member) {
    // Check if user is already a member
    final existingMemberIndex = members.indexWhere(
      (m) => m.userId == member.userId,
    );

    final updatedMembers = [...members];

    if (existingMemberIndex >= 0) {
      // Update existing member
      updatedMembers[existingMemberIndex] = member;
    } else {
      // Add new member
      updatedMembers.add(member);
    }

    return copyWith(members: updatedMembers, updatedAt: DateTime.now());
  }

  /// Remove a member from the workspace
  WorkspaceData removeMember(String userId) {
    if (isOwner(userId)) {
      throw Exception('Cannot remove workspace owner');
    }

    final updatedMembers = members
        .where((member) => member.userId != userId)
        .toList();

    return copyWith(members: updatedMembers, updatedAt: DateTime.now());
  }

  /// Update member role
  WorkspaceData updateMemberRole(String userId, String newRole) {
    if (isOwner(userId)) {
      throw Exception('Cannot change owner role');
    }

    final memberIndex = members.indexWhere((member) => member.userId == userId);

    if (memberIndex == -1) {
      throw Exception('Member not found');
    }

    final updatedMembers = [...members];
    updatedMembers[memberIndex] = members[memberIndex].copyWith(role: newRole);

    return copyWith(members: updatedMembers, updatedAt: DateTime.now());
  }

  /// Update workspace details
  WorkspaceData updateDetails({
    String? newName,
    String? newDescription,
    String? newIconUrl,
    String? newCoverImageUrl,
  }) {
    return copyWith(
      name: newName ?? name,
      description: newDescription ?? description,
      iconUrl: newIconUrl ?? iconUrl,
      coverImageUrl: newCoverImageUrl ?? coverImageUrl,
      updatedAt: DateTime.now(),
    );
  }

  /// Update workspace theme
  WorkspaceData updateTheme(WorkspaceTheme newTheme) {
    return copyWith(theme: newTheme, updatedAt: DateTime.now());
  }

  /// Update workspace integrations
  WorkspaceData updateIntegrations(WorkspaceIntegrations newIntegrations) {
    return copyWith(integrations: newIntegrations, updatedAt: DateTime.now());
  }

  /// Add task to workspace
  WorkspaceData addTask(String taskId) {
    if (taskIds.contains(taskId)) return this;
    final updatedTaskIds = [...taskIds, taskId];
    return copyWith(taskIds: updatedTaskIds, updatedAt: DateTime.now());
  }

  /// Remove task from workspace
  WorkspaceData removeTask(String taskId) {
    final updatedTaskIds = taskIds.where((id) => id != taskId).toList();
    return copyWith(taskIds: updatedTaskIds, updatedAt: DateTime.now());
  }

  /// Add note to workspace
  WorkspaceData addNote(String noteId) {
    if (noteIds.contains(noteId)) return this;
    final updatedNoteIds = [...noteIds, noteId];
    return copyWith(noteIds: updatedNoteIds, updatedAt: DateTime.now());
  }

  /// Remove note from workspace
  WorkspaceData removeNote(String noteId) {
    final updatedNoteIds = noteIds.where((id) => id != noteId).toList();
    return copyWith(noteIds: updatedNoteIds, updatedAt: DateTime.now());
  }

  /// Add category to workspace
  WorkspaceData addCategory(String categoryId) {
    if (categoryIds.contains(categoryId)) return this;
    final updatedCategoryIds = [...categoryIds, categoryId];
    return copyWith(categoryIds: updatedCategoryIds, updatedAt: DateTime.now());
  }

  /// Remove category from workspace
  WorkspaceData removeCategory(String categoryId) {
    final updatedCategoryIds = categoryIds
        .where((id) => id != categoryId)
        .toList();
    return copyWith(categoryIds: updatedCategoryIds, updatedAt: DateTime.now());
  }
}
