// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectedAccountImpl _$$ConnectedAccountImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectedAccountImpl(
  provider: $enumDecode(_$AuthProviderEnumMap, json['provider']),
  providerId: json['providerId'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  connectedAt: DateTime.parse(json['connectedAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$ConnectedAccountImplToJson(
  _$ConnectedAccountImpl instance,
) => <String, dynamic>{
  'provider': _$AuthProviderEnumMap[instance.provider]!,
  'providerId': instance.providerId,
  'email': instance.email,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
  'connectedAt': instance.connectedAt.toIso8601String(),
  'isActive': instance.isActive,
  'metadata': instance.metadata,
};

const _$AuthProviderEnumMap = {
  AuthProvider.email: 'email',
  AuthProvider.google: 'google',
  AuthProvider.github: 'github',
  AuthProvider.phone: 'phone',
};

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$UserPreferencesImpl(
  themeMode: json['themeMode'] as String? ?? 'system',
  enableNotifications: json['enableNotifications'] as bool? ?? true,
  enableLocationReminders: json['enableLocationReminders'] as bool? ?? true,
  enableGitHubSync: json['enableGitHubSync'] as bool? ?? true,
  enableCalendarSync: json['enableCalendarSync'] as bool? ?? true,
  defaultReminderMinutes:
      (json['defaultReminderMinutes'] as num?)?.toInt() ?? 30,
  defaultTags:
      (json['defaultTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['work', 'personal', 'urgent'],
  locale: json['locale'] as String? ?? 'en',
  timezone: json['timezone'] as String? ?? 'America/New_York',
  customSettings: json['customSettings'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$UserPreferencesImplToJson(
  _$UserPreferencesImpl instance,
) => <String, dynamic>{
  'themeMode': instance.themeMode,
  'enableNotifications': instance.enableNotifications,
  'enableLocationReminders': instance.enableLocationReminders,
  'enableGitHubSync': instance.enableGitHubSync,
  'enableCalendarSync': instance.enableCalendarSync,
  'defaultReminderMinutes': instance.defaultReminderMinutes,
  'defaultTags': instance.defaultTags,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'customSettings': instance.customSettings,
};

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  primaryProvider: $enumDecode(_$AuthProviderEnumMap, json['primaryProvider']),
  connectedAccounts:
      (json['connectedAccounts'] as List<dynamic>?)
          ?.map((e) => ConnectedAccount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  preferences: json['preferences'] == null
      ? const UserPreferences()
      : UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'primaryProvider': _$AuthProviderEnumMap[instance.primaryProvider]!,
      'connectedAccounts': instance.connectedAccounts,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'isEmailVerified': instance.isEmailVerified,
      'isPhoneVerified': instance.isPhoneVerified,
      'metadata': instance.metadata,
    };
