import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/linked_provider.dart';

/// Service for managing multi-provider account linking
class AccountLinkingService {
  static final AccountLinkingService _instance =
      AccountLinkingService._internal();
  factory AccountLinkingService() => _instance;
  AccountLinkingService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get list of linked providers for current user
  Future<List<LinkedProvider>> getLinkedProviders() async {
    final user = currentUser;
    if (user == null) return [];

    final providers = <LinkedProvider>[];

    for (final providerData in user.providerData) {
      final providerType = _getProviderType(providerData.providerId);

      providers.add(
        LinkedProvider(
          providerId: providerData.providerId,
          providerType: providerType,
          providerUserId: providerData.uid ?? '',
          email: providerData.email ?? user.email ?? '',
          displayName: providerData.displayName,
          photoUrl: providerData.photoURL,
          linkedAt: user.metadata.creationTime ?? DateTime.now(),
          lastUsedAt: user.metadata.lastSignInTime,
          isPrimary:
              providerData.providerId ==
              (user.providerData.firstOrNull?.providerId ?? ''),
        ),
      );
    }

    return providers;
  }

  /// Link Google account to current user
  Future<UserCredential> linkGoogleAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      // Obtain auth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link the credential to current user
      final userCredential = await user.linkWithCredential(credential);

      debugPrint('Google account linked successfully');
      return userCredential;
    } catch (e) {
      debugPrint('Error linking Google account: $e');
      rethrow;
    }
  }

  /// Link email/password to current user
  Future<UserCredential> linkEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      final userCredential = await user.linkWithCredential(credential);

      debugPrint('Email/password account linked successfully');
      return userCredential;
    } catch (e) {
      debugPrint('Error linking email/password account: $e');
      rethrow;
    }
  }

  /// Unlink a provider from current user
  Future<void> unlinkProvider(String providerId) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Check if user has at least 2 providers
      if (user.providerData.length <= 1) {
        throw Exception(
          'Cannot unlink the only authentication method. Please add another provider first.',
        );
      }

      // Check if trying to unlink the primary provider
      final isPrimary = providerId == user.providerData.first.providerId;
      if (isPrimary && user.providerData.length > 1) {
        throw Exception(
          'Cannot unlink the primary provider. Please set another provider as primary first.',
        );
      }

      await user.unlink(providerId);

      debugPrint('Provider $providerId unlinked successfully');
    } catch (e) {
      debugPrint('Error unlinking provider: $e');
      rethrow;
    }
  }

  /// Set a provider as primary
  Future<void> setPrimaryProvider(String providerId) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Check if provider exists
      final hasProvider = user.providerData.any(
        (p) => p.providerId == providerId,
      );
      if (!hasProvider) {
        throw Exception('Provider not linked to this account');
      }

      // Re-authenticate with the provider to make it primary
      // This would require provider-specific re-authentication
      // For now, we'll just log the intent
      debugPrint('Setting $providerId as primary provider');

      // Note: Firebase doesn't have a direct way to set primary provider
      // This would need to be tracked in Firestore or another database
    } catch (e) {
      debugPrint('Error setting primary provider: $e');
      rethrow;
    }
  }

  /// Check if a specific provider is linked
  bool isProviderLinked(AuthProviderType providerType) {
    final user = currentUser;
    if (user == null) return false;

    final providerId = _getProviderId(providerType);
    return user.providerData.any((p) => p.providerId == providerId);
  }

  /// Get provider count
  int getProviderCount() {
    return currentUser?.providerData.length ?? 0;
  }

  /// Check if account can be merged
  Future<bool> canMergeAccounts(String email) async {
    try {
      // Check if email is already in use
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking merge capability: $e');
      return false;
    }
  }

  /// Merge accounts by linking providers
  Future<void> mergeAccounts({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Get sign-in methods for the email
      final methods = await _auth.fetchSignInMethodsForEmail(email);

      if (methods.isEmpty) {
        throw Exception('No account found with this email');
      }

      // Sign in with the email to get credentials
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Link the credential
      await user.linkWithCredential(credential);

      debugPrint('Accounts merged successfully');
    } catch (e) {
      debugPrint('Error merging accounts: $e');
      rethrow;
    }
  }

  /// Re-authenticate user with a specific provider
  Future<UserCredential> reauthenticateWithProvider(
    AuthProviderType providerType,
  ) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      AuthCredential? credential;

      switch (providerType) {
        case AuthProviderType.google:
          final googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            throw Exception('Google sign-in cancelled');
          }
          final googleAuth = await googleUser.authentication;
          credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          break;

        case AuthProviderType.email:
          throw Exception('Email re-authentication requires email/password');

        default:
          throw Exception('Provider not supported for re-authentication');
      }

      final userCredential = await user.reauthenticateWithCredential(
        credential,
      );
      debugPrint('Re-authenticated successfully');
      return userCredential;
    } catch (e) {
      debugPrint('Error re-authenticating: $e');
      rethrow;
    }
  }

  /// Helper method to get provider type from provider ID
  AuthProviderType _getProviderType(String providerId) {
    if (providerId.contains('google')) return AuthProviderType.google;
    if (providerId.contains('github')) return AuthProviderType.github;
    if (providerId.contains('password')) return AuthProviderType.email;
    if (providerId.contains('apple')) return AuthProviderType.apple;
    if (providerId.contains('microsoft')) return AuthProviderType.microsoft;
    return AuthProviderType.anonymous;
  }

  /// Helper method to get provider ID from type
  String _getProviderId(AuthProviderType providerType) {
    switch (providerType) {
      case AuthProviderType.google:
        return 'google.com';
      case AuthProviderType.github:
        return 'github.com';
      case AuthProviderType.email:
        return 'password';
      case AuthProviderType.apple:
        return 'apple.com';
      case AuthProviderType.microsoft:
        return 'microsoft.com';
      case AuthProviderType.anonymous:
        return 'anonymous';
    }
  }

  /// Get user's email from any linked provider
  String? getUserEmail() {
    final user = currentUser;
    if (user == null) return null;

    // Try to get email from user object first
    if (user.email != null && user.email!.isNotEmpty) {
      return user.email;
    }

    // Try to get email from provider data
    for (final provider in user.providerData) {
      if (provider.email != null && provider.email!.isNotEmpty) {
        return provider.email;
      }
    }

    return null;
  }
}
