// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceThemeImpl _$$WorkspaceThemeImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceThemeImpl(
      primaryColor: json['primaryColor'] as String? ?? 'blue',
      themeMode: json['themeMode'] as String? ?? 'system',
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      useDynamicColor: json['useDynamicColor'] as bool? ?? true,
      customFontFamily: json['customFontFamily'] as String?,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      customColors: json['customColors'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WorkspaceThemeImplToJson(
  _$WorkspaceThemeImpl instance,
) => <String, dynamic>{
  'primaryColor': instance.primaryColor,
  'themeMode': instance.themeMode,
  'useMaterial3': instance.useMaterial3,
  'useDynamicColor': instance.useDynamicColor,
  'customFontFamily': instance.customFontFamily,
  'textScaleFactor': instance.textScaleFactor,
  'customColors': instance.customColors,
};

_$WorkspaceIntegrationsImpl _$$WorkspaceIntegrationsImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceIntegrationsImpl(
  gitHubEnabled: json['gitHubEnabled'] as bool? ?? false,
  gitHubRepoUrl: json['gitHubRepoUrl'] as String?,
  gitHubToken: json['gitHubToken'] as String?,
  calendarEnabled: json['calendarEnabled'] as bool? ?? false,
  calendarId: json['calendarId'] as String?,
  slackEnabled: json['slackEnabled'] as bool? ?? false,
  slackWebhookUrl: json['slackWebhookUrl'] as String?,
  notionEnabled: json['notionEnabled'] as bool? ?? false,
  notionToken: json['notionToken'] as String?,
  notionDatabaseId: json['notionDatabaseId'] as String?,
  customIntegrations:
      json['customIntegrations'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$WorkspaceIntegrationsImplToJson(
  _$WorkspaceIntegrationsImpl instance,
) => <String, dynamic>{
  'gitHubEnabled': instance.gitHubEnabled,
  'gitHubRepoUrl': instance.gitHubRepoUrl,
  'gitHubToken': instance.gitHubToken,
  'calendarEnabled': instance.calendarEnabled,
  'calendarId': instance.calendarId,
  'slackEnabled': instance.slackEnabled,
  'slackWebhookUrl': instance.slackWebhookUrl,
  'notionEnabled': instance.notionEnabled,
  'notionToken': instance.notionToken,
  'notionDatabaseId': instance.notionDatabaseId,
  'customIntegrations': instance.customIntegrations,
};

_$WorkspaceMemberImpl _$$WorkspaceMemberImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceMemberImpl(
  userId: json['userId'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  role: json['role'] as String? ?? 'member',
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  joinedAt: DateTime.parse(json['joinedAt'] as String),
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$WorkspaceMemberImplToJson(
  _$WorkspaceMemberImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'role': instance.role,
  'permissions': instance.permissions,
  'joinedAt': instance.joinedAt.toIso8601String(),
  'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
  'isActive': instance.isActive,
  'metadata': instance.metadata,
};

_$WorkspaceDataImpl _$$WorkspaceDataImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceDataImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  iconUrl: json['iconUrl'] as String?,
  coverImageUrl: json['coverImageUrl'] as String?,
  theme: json['theme'] == null
      ? const WorkspaceTheme()
      : WorkspaceTheme.fromJson(json['theme'] as Map<String, dynamic>),
  integrations: json['integrations'] == null
      ? const WorkspaceIntegrations()
      : WorkspaceIntegrations.fromJson(
          json['integrations'] as Map<String, dynamic>,
        ),
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => WorkspaceMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  ownerId: json['ownerId'] as String,
  isPersonal: json['isPersonal'] as bool? ?? false,
  isArchived: json['isArchived'] as bool? ?? false,
  taskIds:
      (json['taskIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  noteIds:
      (json['noteIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  categoryIds:
      (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastAccessedAt: json['lastAccessedAt'] == null
      ? null
      : DateTime.parse(json['lastAccessedAt'] as String),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$WorkspaceDataImplToJson(_$WorkspaceDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'coverImageUrl': instance.coverImageUrl,
      'theme': instance.theme,
      'integrations': instance.integrations,
      'members': instance.members,
      'ownerId': instance.ownerId,
      'isPersonal': instance.isPersonal,
      'isArchived': instance.isArchived,
      'taskIds': instance.taskIds,
      'noteIds': instance.noteIds,
      'categoryIds': instance.categoryIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
      'sortOrder': instance.sortOrder,
      'metadata': instance.metadata,
    };
