import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Login Screen with multiple authentication options
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isSignUp = false;
  bool _showPhoneAuth = false;
  bool _showOtpField = false;
  String? _verificationId;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      _errorMessage = null;
    });
  }

  void _setError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  // Email/Password Authentication
  Future<void> _signInWithEmailPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _setError('Please enter both email and password');
      return;
    }

    _setLoading(true);
    try {
      if (_isSignUp) {
        await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Authentication failed');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Google sign-in failed');
    } catch (e) {
      _setError('Google sign-in error: $e');
    }
  }

  // GitHub Sign-In
  Future<void> _signInWithGitHub() async {
    _setLoading(true);
    try {
      await _authService.signInWithGitHub();
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'GitHub sign-in failed');
    } catch (e) {
      _setError('GitHub sign-in error: $e');
    }
  }

  // Phone Number Authentication
  Future<void> _signInWithPhone() async {
    if (_phoneController.text.isEmpty) {
      _setError('Please enter phone number');
      return;
    }

    _setLoading(true);
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed
          try {
            // Auto-verification will be handled by Firebase Auth automatically
          } catch (e) {
            _setError('Auto-verification failed: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _showOtpField = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      _setError('Phone verification error: $e');
    }
  }

  // Verify OTP
  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty || _verificationId == null) {
      _setError('Please enter the OTP');
      return;
    }

    _setLoading(true);
    try {
      await _authService.signInWithPhoneCredential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'OTP verification failed');
    } catch (e) {
      _setError('OTP verification error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo/Title
            Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.checklist_rtl,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CheckList',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),

            // Authentication Method Tabs
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showPhoneAuth = false),
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    style: TextButton.styleFrom(
                      backgroundColor: !_showPhoneAuth
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() {
                      _showPhoneAuth = true;
                      _showOtpField = false;
                    }),
                    icon: const Icon(Icons.phone),
                    label: const Text('Phone'),
                    style: TextButton.styleFrom(
                      backgroundColor: _showPhoneAuth
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Email/Password Form
            if (!_showPhoneAuth) ...[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Sign In/Up Button
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmailPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
              ),

              // Toggle Sign In/Up
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp
                      ? 'Already have an account? Sign In'
                      : 'Don\'t have an account? Sign Up',
                ),
              ),
            ],

            // Phone Number Form
            if (_showPhoneAuth) ...[
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (with country code)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+1234567890',
                ),
                keyboardType: TextInputType.phone,
                enabled: !_isLoading && !_showOtpField,
              ),
              const SizedBox(height: 16),

              if (!_showOtpField)
                ElevatedButton(
                  onPressed: _isLoading ? null : _signInWithPhone,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                ),

              if (_showOtpField) ...[
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sms),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Verify OTP'),
                ),
              ],
            ],

            const SizedBox(height: 32),

            // Divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 32),

            // Social Sign-In Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Google Sign-In
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.login, color: Colors.red),
                  ),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 12),

                // GitHub Sign-In
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGitHub,
                  icon: const Icon(Icons.code, color: Colors.black),
                  label: const Text('Continue with GitHub'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Forgot Password
            if (!_showPhoneAuth)
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => _showForgotPasswordDialog(),
                child: const Text('Forgot Password?'),
              ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                try {
                  await _authService.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
