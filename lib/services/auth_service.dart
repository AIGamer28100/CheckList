import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Authentication Service
/// Handles user authentication operations for multiple providers
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize GoogleSignIn without web client ID for now
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  /// Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete account error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Delete account error: $e');
      rethrow;
    }
  }

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get user email
  String? get userEmail => currentUser?.email;

  /// Get user ID
  String? get userId => currentUser?.uid;

  // ===============================
  // GOOGLE SIGN-IN
  // ===============================

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // For web, use the Google provider directly to avoid client ID issues
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        return await _auth.signInWithPopup(googleProvider);
      } else {
        // For mobile platforms, use GoogleSignIn
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // User canceled the sign-in
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      if (!kIsWeb) {
        // Only call GoogleSignIn.signOut on mobile platforms
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      debugPrint('Google sign out error: $e');
      rethrow;
    }
  }

  // ===============================
  // GITHUB SIGN-IN
  // ===============================

  /// Sign in with GitHub
  Future<UserCredential?> signInWithGitHub() async {
    try {
      // Create a GitHub provider
      GithubAuthProvider githubProvider = GithubAuthProvider();

      // Add scopes if needed
      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      // Sign in with popup for web, redirect for mobile
      if (kIsWeb) {
        return await _auth.signInWithPopup(githubProvider);
      } else {
        return await _auth.signInWithProvider(githubProvider);
      }
    } catch (e) {
      debugPrint('GitHub sign in error: $e');
      rethrow;
    }
  }

  // ===============================
  // PHONE NUMBER AUTHENTICATION
  // ===============================

  /// Send OTP to phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
    int? timeout = 60,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: Duration(seconds: timeout ?? 60),
      );
    } catch (e) {
      debugPrint('Phone verification error: $e');
      rethrow;
    }
  }

  /// Sign in with phone credential (after OTP verification)
  Future<UserCredential?> signInWithPhoneCredential({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Phone sign in error: $e');
      rethrow;
    }
  }

  /// Link phone number to existing account
  Future<UserCredential?> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await currentUser!.linkWithCredential(credential);
    } catch (e) {
      debugPrint('Phone link error: $e');
      rethrow;
    }
  }

  // ===============================
  // MULTI-FACTOR AUTHENTICATION
  // ===============================

  /// Check if user has multi-factor authentication enabled
  bool get hasMultiFactorAuth => currentUser?.multiFactor != null;

  /// Get enrolled multi-factor info
  // Note: MultiFactor API may vary based on Firebase version
  // List<MultiFactorInfo> get enrolledFactors => currentUser?.multiFactor.enrolledFactors ?? [];

  // ===============================
  // ACCOUNT LINKING & UNLINKING
  // ===============================

  /// Link Google account to current user
  Future<UserCredential?> linkGoogleAccount() async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await currentUser!.linkWithCredential(credential);
    } catch (e) {
      debugPrint('Link Google account error: $e');
      rethrow;
    }
  }

  /// Link GitHub account to current user
  Future<UserCredential?> linkGitHubAccount() async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      GithubAuthProvider githubProvider = GithubAuthProvider();
      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      if (kIsWeb) {
        final result = await _auth.signInWithPopup(githubProvider);
        return await currentUser!.linkWithCredential(result.credential!);
      } else {
        return await currentUser!.linkWithProvider(githubProvider);
      }
    } catch (e) {
      debugPrint('Link GitHub account error: $e');
      rethrow;
    }
  }

  /// Unlink provider from current user
  Future<User?> unlinkProvider(String providerId) async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      return await currentUser!.unlink(providerId);
    } catch (e) {
      debugPrint('Unlink provider error: $e');
      rethrow;
    }
  }

  // ===============================
  // USER PROFILE MANAGEMENT
  // ===============================

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      await currentUser!.updateDisplayName(displayName);
      if (photoURL != null) {
        await currentUser!.updatePhotoURL(photoURL);
      }
      await currentUser!.reload();
    } catch (e) {
      debugPrint('Update profile error: $e');
      rethrow;
    }
  }

  /// Get user's linked providers
  List<String> get linkedProviders {
    if (currentUser == null) return [];
    return currentUser!.providerData.map((info) => info.providerId).toList();
  }

  /// Check if user is anonymous
  bool get isAnonymous => currentUser?.isAnonymous ?? false;

  /// Get user display name
  String? get displayName => currentUser?.displayName;

  /// Get user photo URL
  String? get photoURL => currentUser?.photoURL;

  /// Get user phone number
  String? get phoneNumber => currentUser?.phoneNumber;

  /// Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      debugPrint('Send email verification error: $e');
      rethrow;
    }
  }

  /// Reauthenticate user with email/password
  Future<UserCredential> reauthenticateWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      return await currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      debugPrint('Reauthenticate error: $e');
      rethrow;
    }
  }
}
