import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Environment configuration service
/// Handles loading and accessing environment variables
class EnvironmentConfig {
  static const String _defaultEnvFile = 'config/env/.env';

  /// Initialize the environment configuration
  /// Load the appropriate .env file based on the environment
  static Future<void> initialize({String? envFile}) async {
    String environmentFile = envFile ?? _defaultEnvFile;

    // Try to load environment-specific file first
    try {
      await dotenv.load(fileName: environmentFile);
      debugPrint('Loaded environment from: $environmentFile');
    } catch (e) {
      // Fallback to default .env file
      try {
        await dotenv.load(fileName: _defaultEnvFile);
        debugPrint('Loaded environment from: $_defaultEnvFile');
      } catch (e) {
        debugPrint(
          'Warning: Could not load environment file. Using default values.',
        );
      }
    }
  }

  /// Get environment variable with optional default value
  static String get(String key, {String defaultValue = ''}) {
    return dotenv.get(key, fallback: defaultValue);
  }

  /// Get environment variable or null if not found
  static String? maybeGet(String key) {
    return dotenv.maybeGet(key);
  }

  /// Check if environment variable exists
  static bool has(String key) {
    return dotenv.isEveryDefined([key]);
  }

  // Firebase Configuration Getters
  static String get firebaseApiKey => get('FIREBASE_API_KEY');
  static String get firebaseAuthDomain => get('FIREBASE_AUTH_DOMAIN');
  static String get firebaseProjectId => get('FIREBASE_PROJECT_ID');
  static String get firebaseStorageBucket => get('FIREBASE_STORAGE_BUCKET');
  static String get firebaseMessagingSenderId =>
      get('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseAppId => get('FIREBASE_APP_ID');

  // Authentication Provider Configuration
  static String get googleClientIdWeb => get('GOOGLE_CLIENT_ID_WEB');
  static String get googleClientIdIos => get('GOOGLE_CLIENT_ID_IOS');
  static String get googleClientIdAndroid => get('GOOGLE_CLIENT_ID_ANDROID');
  static String get githubClientId => get('GITHUB_CLIENT_ID');
  static String get githubClientSecret => get('GITHUB_CLIENT_SECRET');
  static String? get githubToken => maybeGet('GITHUB_TOKEN');

  // Other API Keys
  static String get googleMapsApiKey => get('GOOGLE_MAPS_API_KEY');
  static String get stripePublishableKey => get('STRIPE_PUBLISHABLE_KEY');
  static String get analyticsKey => get('ANALYTICS_KEY');

  // App Configuration
  static String get appEnv => get('APP_ENV', defaultValue: 'development');
  static bool get isDebugMode =>
      get('DEBUG_MODE', defaultValue: 'false').toLowerCase() == 'true';
  static bool get isProduction => appEnv == 'production';
  static bool get isDevelopment => appEnv == 'development';

  /// Get all environment variables (for debugging - be careful in production)
  static Map<String, String> getAllVariables() {
    return dotenv.env;
  }

  /// Print current environment info (for debugging)
  static void debugPrintEnvironment() {
    if (isDebugMode) {
      debugPrint('=== Environment Configuration ===');
      debugPrint('Environment: $appEnv');
      debugPrint('Debug Mode: $isDebugMode');
      debugPrint('Firebase Project ID: $firebaseProjectId');
      debugPrint('=================================');
    }
  }
}
