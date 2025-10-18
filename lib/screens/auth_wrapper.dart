import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

/// Authentication wrapper that determines which screen to show
/// based on the user's authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading spinner while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show appropriate screen based on auth state
        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in
          return const HomeScreen();
        } else {
          // User is not signed in
          return const LoginScreen();
        }
      },
    );
  }
}
