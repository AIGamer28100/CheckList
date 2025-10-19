import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User authentication provider
enum AuthProvider {
  @JsonValue('email')
  email,
  @JsonValue('google')
  google,
  @JsonValue('github')
  github,
  @JsonValue('phone')
  phone,
}

/// Connected account information
@freezed
class ConnectedAccount with _$ConnectedAccount {
  const factory ConnectedAccount({
    required AuthProvider provider,
    required String providerId,
    required String email,
    String? username,
    String? avatarUrl,
    required DateTime connectedAt,
    @Default(true) bool isActive,
    Map<String, dynamic>? metadata,
  }) = _ConnectedAccount;

  factory ConnectedAccount.fromJson(Map<String, dynamic> json) =>
      _$ConnectedAccountFromJson(json);
}

/// User preferences for the application
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('system') String themeMode, // 'light', 'dark', 'system'
    @Default(true) bool enableNotifications,
    @Default(true) bool enableLocationReminders,
    @Default(true) bool enableGitHubSync,
    @Default(true) bool enableCalendarSync,
    @Default(30) int defaultReminderMinutes,
    @Default(['work', 'personal', 'urgent']) List<String> defaultTags,
    @Default('en') String locale,
    @Default('America/New_York') String timezone,
    @Default({}) Map<String, dynamic> customSettings,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

/// Complete user model
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    required AuthProvider primaryProvider,
    @Default([]) List<ConnectedAccount> connectedAccounts,
    @Default(UserPreferences()) UserPreferences preferences,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    @Default({}) Map<String, dynamic> metadata,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Extension methods for User
extension UserExtensions on User {
  /// Check if user has connected a specific provider
  bool hasConnectedProvider(AuthProvider provider) {
    return connectedAccounts.any(
      (account) => account.provider == provider && account.isActive,
    );
  }

  /// Get connected account for a specific provider
  ConnectedAccount? getConnectedAccount(AuthProvider provider) {
    try {
      return connectedAccounts.firstWhere(
        (account) => account.provider == provider && account.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if GitHub is connected and active
  bool get hasGitHubConnected => hasConnectedProvider(AuthProvider.github);

  /// Check if Google is connected and active
  bool get hasGoogleConnected => hasConnectedProvider(AuthProvider.google);

  /// Get display name or fallback to email
  String get displayNameOrEmail => displayName ?? email;

  /// Get avatar URL or return null for default
  String? get avatarUrlOrDefault => photoUrl;

  /// Check if user can unlink a provider (must keep at least one)
  bool canUnlinkProvider(AuthProvider provider) {
    if (provider == primaryProvider) return false;
    final activeAccounts = connectedAccounts
        .where((acc) => acc.isActive)
        .length;
    return activeAccounts > 1;
  }

  /// Add a new connected account
  User addConnectedAccount(ConnectedAccount account) {
    final updatedAccounts = [...connectedAccounts];

    // Remove existing account for this provider if it exists
    updatedAccounts.removeWhere((acc) => acc.provider == account.provider);

    // Add the new account
    updatedAccounts.add(account);

    return copyWith(connectedAccounts: updatedAccounts);
  }

  /// Remove a connected account
  User removeConnectedAccount(AuthProvider provider) {
    if (!canUnlinkProvider(provider)) {
      throw Exception(
        'Cannot unlink primary provider or last remaining provider',
      );
    }

    final updatedAccounts = connectedAccounts
        .where((acc) => acc.provider != provider)
        .toList();

    return copyWith(connectedAccounts: updatedAccounts);
  }

  /// Update user preferences
  User updatePreferences(UserPreferences newPreferences) {
    return copyWith(preferences: newPreferences);
  }

  /// Update last login time
  User updateLastLogin() {
    return copyWith(lastLoginAt: DateTime.now());
  }
}
