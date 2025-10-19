import 'package:freezed_annotation/freezed_annotation.dart';

part 'linked_provider.freezed.dart';
part 'linked_provider.g.dart';

/// Authentication provider types
enum AuthProviderType { google, github, email, apple, microsoft, anonymous }

/// Linked authentication provider model
@freezed
class LinkedProvider with _$LinkedProvider {
  const factory LinkedProvider({
    required String providerId,
    required AuthProviderType providerType,
    required String providerUserId,
    required String email,
    String? displayName,
    String? photoUrl,
    required DateTime linkedAt,
    DateTime? lastUsedAt,
    required bool isPrimary,
    Map<String, dynamic>? metadata,
  }) = _LinkedProvider;

  factory LinkedProvider.fromJson(Map<String, dynamic> json) =>
      _$LinkedProviderFromJson(json);
}

extension AuthProviderTypeExtension on AuthProviderType {
  String get displayName {
    switch (this) {
      case AuthProviderType.google:
        return 'Google';
      case AuthProviderType.github:
        return 'GitHub';
      case AuthProviderType.email:
        return 'Email';
      case AuthProviderType.apple:
        return 'Apple';
      case AuthProviderType.microsoft:
        return 'Microsoft';
      case AuthProviderType.anonymous:
        return 'Anonymous';
    }
  }

  String get iconName {
    switch (this) {
      case AuthProviderType.google:
        return 'google';
      case AuthProviderType.github:
        return 'github';
      case AuthProviderType.email:
        return 'email';
      case AuthProviderType.apple:
        return 'apple';
      case AuthProviderType.microsoft:
        return 'microsoft';
      case AuthProviderType.anonymous:
        return 'anonymous';
    }
  }

  bool get canUnlink {
    // Anonymous accounts cannot be unlinked
    return this != AuthProviderType.anonymous;
  }
}
