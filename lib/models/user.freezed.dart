// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConnectedAccount _$ConnectedAccountFromJson(Map<String, dynamic> json) {
  return _ConnectedAccount.fromJson(json);
}

/// @nodoc
mixin _$ConnectedAccount {
  AuthProvider get provider => throw _privateConstructorUsedError;
  String get providerId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime get connectedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ConnectedAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectedAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectedAccountCopyWith<ConnectedAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectedAccountCopyWith<$Res> {
  factory $ConnectedAccountCopyWith(
    ConnectedAccount value,
    $Res Function(ConnectedAccount) then,
  ) = _$ConnectedAccountCopyWithImpl<$Res, ConnectedAccount>;
  @useResult
  $Res call({
    AuthProvider provider,
    String providerId,
    String email,
    String? username,
    String? avatarUrl,
    DateTime connectedAt,
    bool isActive,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$ConnectedAccountCopyWithImpl<$Res, $Val extends ConnectedAccount>
    implements $ConnectedAccountCopyWith<$Res> {
  _$ConnectedAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectedAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? providerId = null,
    Object? email = null,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? connectedAt = null,
    Object? isActive = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as AuthProvider,
            providerId: null == providerId
                ? _value.providerId
                : providerId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            connectedAt: null == connectedAt
                ? _value.connectedAt
                : connectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectedAccountImplCopyWith<$Res>
    implements $ConnectedAccountCopyWith<$Res> {
  factory _$$ConnectedAccountImplCopyWith(
    _$ConnectedAccountImpl value,
    $Res Function(_$ConnectedAccountImpl) then,
  ) = __$$ConnectedAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AuthProvider provider,
    String providerId,
    String email,
    String? username,
    String? avatarUrl,
    DateTime connectedAt,
    bool isActive,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$ConnectedAccountImplCopyWithImpl<$Res>
    extends _$ConnectedAccountCopyWithImpl<$Res, _$ConnectedAccountImpl>
    implements _$$ConnectedAccountImplCopyWith<$Res> {
  __$$ConnectedAccountImplCopyWithImpl(
    _$ConnectedAccountImpl _value,
    $Res Function(_$ConnectedAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectedAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? providerId = null,
    Object? email = null,
    Object? username = freezed,
    Object? avatarUrl = freezed,
    Object? connectedAt = null,
    Object? isActive = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$ConnectedAccountImpl(
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as AuthProvider,
        providerId: null == providerId
            ? _value.providerId
            : providerId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        connectedAt: null == connectedAt
            ? _value.connectedAt
            : connectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectedAccountImpl implements _ConnectedAccount {
  const _$ConnectedAccountImpl({
    required this.provider,
    required this.providerId,
    required this.email,
    this.username,
    this.avatarUrl,
    required this.connectedAt,
    this.isActive = true,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$ConnectedAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectedAccountImplFromJson(json);

  @override
  final AuthProvider provider;
  @override
  final String providerId;
  @override
  final String email;
  @override
  final String? username;
  @override
  final String? avatarUrl;
  @override
  final DateTime connectedAt;
  @override
  @JsonKey()
  final bool isActive;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ConnectedAccount(provider: $provider, providerId: $providerId, email: $email, username: $username, avatarUrl: $avatarUrl, connectedAt: $connectedAt, isActive: $isActive, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectedAccountImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    provider,
    providerId,
    email,
    username,
    avatarUrl,
    connectedAt,
    isActive,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of ConnectedAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectedAccountImplCopyWith<_$ConnectedAccountImpl> get copyWith =>
      __$$ConnectedAccountImplCopyWithImpl<_$ConnectedAccountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectedAccountImplToJson(this);
  }
}

abstract class _ConnectedAccount implements ConnectedAccount {
  const factory _ConnectedAccount({
    required final AuthProvider provider,
    required final String providerId,
    required final String email,
    final String? username,
    final String? avatarUrl,
    required final DateTime connectedAt,
    final bool isActive,
    final Map<String, dynamic>? metadata,
  }) = _$ConnectedAccountImpl;

  factory _ConnectedAccount.fromJson(Map<String, dynamic> json) =
      _$ConnectedAccountImpl.fromJson;

  @override
  AuthProvider get provider;
  @override
  String get providerId;
  @override
  String get email;
  @override
  String? get username;
  @override
  String? get avatarUrl;
  @override
  DateTime get connectedAt;
  @override
  bool get isActive;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ConnectedAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectedAccountImplCopyWith<_$ConnectedAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  String get themeMode =>
      throw _privateConstructorUsedError; // 'light', 'dark', 'system'
  bool get enableNotifications => throw _privateConstructorUsedError;
  bool get enableLocationReminders => throw _privateConstructorUsedError;
  bool get enableGitHubSync => throw _privateConstructorUsedError;
  bool get enableCalendarSync => throw _privateConstructorUsedError;
  int get defaultReminderMinutes => throw _privateConstructorUsedError;
  List<String> get defaultTags => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  Map<String, dynamic> get customSettings => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
    UserPreferences value,
    $Res Function(UserPreferences) then,
  ) = _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call({
    String themeMode,
    bool enableNotifications,
    bool enableLocationReminders,
    bool enableGitHubSync,
    bool enableCalendarSync,
    int defaultReminderMinutes,
    List<String> defaultTags,
    String locale,
    String timezone,
    Map<String, dynamic> customSettings,
  });
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? enableNotifications = null,
    Object? enableLocationReminders = null,
    Object? enableGitHubSync = null,
    Object? enableCalendarSync = null,
    Object? defaultReminderMinutes = null,
    Object? defaultTags = null,
    Object? locale = null,
    Object? timezone = null,
    Object? customSettings = null,
  }) {
    return _then(
      _value.copyWith(
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as String,
            enableNotifications: null == enableNotifications
                ? _value.enableNotifications
                : enableNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableLocationReminders: null == enableLocationReminders
                ? _value.enableLocationReminders
                : enableLocationReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableGitHubSync: null == enableGitHubSync
                ? _value.enableGitHubSync
                : enableGitHubSync // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableCalendarSync: null == enableCalendarSync
                ? _value.enableCalendarSync
                : enableCalendarSync // ignore: cast_nullable_to_non_nullable
                      as bool,
            defaultReminderMinutes: null == defaultReminderMinutes
                ? _value.defaultReminderMinutes
                : defaultReminderMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            defaultTags: null == defaultTags
                ? _value.defaultTags
                : defaultTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
            customSettings: null == customSettings
                ? _value.customSettings
                : customSettings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(
    _$UserPreferencesImpl value,
    $Res Function(_$UserPreferencesImpl) then,
  ) = __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String themeMode,
    bool enableNotifications,
    bool enableLocationReminders,
    bool enableGitHubSync,
    bool enableCalendarSync,
    int defaultReminderMinutes,
    List<String> defaultTags,
    String locale,
    String timezone,
    Map<String, dynamic> customSettings,
  });
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
    _$UserPreferencesImpl _value,
    $Res Function(_$UserPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? enableNotifications = null,
    Object? enableLocationReminders = null,
    Object? enableGitHubSync = null,
    Object? enableCalendarSync = null,
    Object? defaultReminderMinutes = null,
    Object? defaultTags = null,
    Object? locale = null,
    Object? timezone = null,
    Object? customSettings = null,
  }) {
    return _then(
      _$UserPreferencesImpl(
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as String,
        enableNotifications: null == enableNotifications
            ? _value.enableNotifications
            : enableNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableLocationReminders: null == enableLocationReminders
            ? _value.enableLocationReminders
            : enableLocationReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableGitHubSync: null == enableGitHubSync
            ? _value.enableGitHubSync
            : enableGitHubSync // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableCalendarSync: null == enableCalendarSync
            ? _value.enableCalendarSync
            : enableCalendarSync // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultReminderMinutes: null == defaultReminderMinutes
            ? _value.defaultReminderMinutes
            : defaultReminderMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        defaultTags: null == defaultTags
            ? _value._defaultTags
            : defaultTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        customSettings: null == customSettings
            ? _value._customSettings
            : customSettings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl({
    this.themeMode = 'system',
    this.enableNotifications = true,
    this.enableLocationReminders = true,
    this.enableGitHubSync = true,
    this.enableCalendarSync = true,
    this.defaultReminderMinutes = 30,
    final List<String> defaultTags = const ['work', 'personal', 'urgent'],
    this.locale = 'en',
    this.timezone = 'America/New_York',
    final Map<String, dynamic> customSettings = const {},
  }) : _defaultTags = defaultTags,
       _customSettings = customSettings;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final String themeMode;
  // 'light', 'dark', 'system'
  @override
  @JsonKey()
  final bool enableNotifications;
  @override
  @JsonKey()
  final bool enableLocationReminders;
  @override
  @JsonKey()
  final bool enableGitHubSync;
  @override
  @JsonKey()
  final bool enableCalendarSync;
  @override
  @JsonKey()
  final int defaultReminderMinutes;
  final List<String> _defaultTags;
  @override
  @JsonKey()
  List<String> get defaultTags {
    if (_defaultTags is EqualUnmodifiableListView) return _defaultTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultTags);
  }

  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final String timezone;
  final Map<String, dynamic> _customSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get customSettings {
    if (_customSettings is EqualUnmodifiableMapView) return _customSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customSettings);
  }

  @override
  String toString() {
    return 'UserPreferences(themeMode: $themeMode, enableNotifications: $enableNotifications, enableLocationReminders: $enableLocationReminders, enableGitHubSync: $enableGitHubSync, enableCalendarSync: $enableCalendarSync, defaultReminderMinutes: $defaultReminderMinutes, defaultTags: $defaultTags, locale: $locale, timezone: $timezone, customSettings: $customSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(
                  other.enableLocationReminders,
                  enableLocationReminders,
                ) ||
                other.enableLocationReminders == enableLocationReminders) &&
            (identical(other.enableGitHubSync, enableGitHubSync) ||
                other.enableGitHubSync == enableGitHubSync) &&
            (identical(other.enableCalendarSync, enableCalendarSync) ||
                other.enableCalendarSync == enableCalendarSync) &&
            (identical(other.defaultReminderMinutes, defaultReminderMinutes) ||
                other.defaultReminderMinutes == defaultReminderMinutes) &&
            const DeepCollectionEquality().equals(
              other._defaultTags,
              _defaultTags,
            ) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(
              other._customSettings,
              _customSettings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    enableNotifications,
    enableLocationReminders,
    enableGitHubSync,
    enableCalendarSync,
    defaultReminderMinutes,
    const DeepCollectionEquality().hash(_defaultTags),
    locale,
    timezone,
    const DeepCollectionEquality().hash(_customSettings),
  );

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(this);
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences({
    final String themeMode,
    final bool enableNotifications,
    final bool enableLocationReminders,
    final bool enableGitHubSync,
    final bool enableCalendarSync,
    final int defaultReminderMinutes,
    final List<String> defaultTags,
    final String locale,
    final String timezone,
    final Map<String, dynamic> customSettings,
  }) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String get themeMode; // 'light', 'dark', 'system'
  @override
  bool get enableNotifications;
  @override
  bool get enableLocationReminders;
  @override
  bool get enableGitHubSync;
  @override
  bool get enableCalendarSync;
  @override
  int get defaultReminderMinutes;
  @override
  List<String> get defaultTags;
  @override
  String get locale;
  @override
  String get timezone;
  @override
  Map<String, dynamic> get customSettings;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  AuthProvider get primaryProvider => throw _privateConstructorUsedError;
  List<ConnectedAccount> get connectedAccounts =>
      throw _privateConstructorUsedError;
  UserPreferences get preferences => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isPhoneVerified => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    AuthProvider primaryProvider,
    List<ConnectedAccount> connectedAccounts,
    UserPreferences preferences,
    DateTime createdAt,
    DateTime? lastLoginAt,
    bool isEmailVerified,
    bool isPhoneVerified,
    Map<String, dynamic> metadata,
  });

  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? primaryProvider = null,
    Object? connectedAccounts = null,
    Object? preferences = null,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            primaryProvider: null == primaryProvider
                ? _value.primaryProvider
                : primaryProvider // ignore: cast_nullable_to_non_nullable
                      as AuthProvider,
            connectedAccounts: null == connectedAccounts
                ? _value.connectedAccounts
                : connectedAccounts // ignore: cast_nullable_to_non_nullable
                      as List<ConnectedAccount>,
            preferences: null == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as UserPreferences,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPhoneVerified: null == isPhoneVerified
                ? _value.isPhoneVerified
                : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res> get preferences {
    return $UserPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    AuthProvider primaryProvider,
    List<ConnectedAccount> connectedAccounts,
    UserPreferences preferences,
    DateTime createdAt,
    DateTime? lastLoginAt,
    bool isEmailVerified,
    bool isPhoneVerified,
    Map<String, dynamic> metadata,
  });

  @override
  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? primaryProvider = null,
    Object? connectedAccounts = null,
    Object? preferences = null,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? metadata = null,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        primaryProvider: null == primaryProvider
            ? _value.primaryProvider
            : primaryProvider // ignore: cast_nullable_to_non_nullable
                  as AuthProvider,
        connectedAccounts: null == connectedAccounts
            ? _value._connectedAccounts
            : connectedAccounts // ignore: cast_nullable_to_non_nullable
                  as List<ConnectedAccount>,
        preferences: null == preferences
            ? _value.preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as UserPreferences,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPhoneVerified: null == isPhoneVerified
            ? _value.isPhoneVerified
            : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.primaryProvider,
    final List<ConnectedAccount> connectedAccounts = const [],
    this.preferences = const UserPreferences(),
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    final Map<String, dynamic> metadata = const {},
  }) : _connectedAccounts = connectedAccounts,
       _metadata = metadata;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final String? phoneNumber;
  @override
  final AuthProvider primaryProvider;
  final List<ConnectedAccount> _connectedAccounts;
  @override
  @JsonKey()
  List<ConnectedAccount> get connectedAccounts {
    if (_connectedAccounts is EqualUnmodifiableListView)
      return _connectedAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectedAccounts);
  }

  @override
  @JsonKey()
  final UserPreferences preferences;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  @JsonKey()
  final bool isPhoneVerified;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, primaryProvider: $primaryProvider, connectedAccounts: $connectedAccounts, preferences: $preferences, createdAt: $createdAt, lastLoginAt: $lastLoginAt, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.primaryProvider, primaryProvider) ||
                other.primaryProvider == primaryProvider) &&
            const DeepCollectionEquality().equals(
              other._connectedAccounts,
              _connectedAccounts,
            ) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isPhoneVerified, isPhoneVerified) ||
                other.isPhoneVerified == isPhoneVerified) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    primaryProvider,
    const DeepCollectionEquality().hash(_connectedAccounts),
    preferences,
    createdAt,
    lastLoginAt,
    isEmailVerified,
    isPhoneVerified,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String id,
    required final String email,
    final String? displayName,
    final String? photoUrl,
    final String? phoneNumber,
    required final AuthProvider primaryProvider,
    final List<ConnectedAccount> connectedAccounts,
    final UserPreferences preferences,
    required final DateTime createdAt,
    final DateTime? lastLoginAt,
    final bool isEmailVerified,
    final bool isPhoneVerified,
    final Map<String, dynamic> metadata,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  String? get phoneNumber;
  @override
  AuthProvider get primaryProvider;
  @override
  List<ConnectedAccount> get connectedAccounts;
  @override
  UserPreferences get preferences;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  bool get isEmailVerified;
  @override
  bool get isPhoneVerified;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
