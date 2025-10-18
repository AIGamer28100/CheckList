# Environment Configuration Setup

## Overview

This project uses environment files to manage sensitive information like API keys, Firebase credentials, and other secrets. These files are excluded from version control to keep your secrets secure.

## Quick Setup

### 1. Create Environment Files

Copy the example files and fill in your actual values:

```bash
# Main environment file
cp .env.example .env

# Development environment
cp .env.dev.example .env.dev

# Production environment  
cp .env.prod.example .env.prod
```

### 2. Fill in Your Secrets

Edit each `.env` file with your actual credentials:

**For Firebase:**

- Get your config from Firebase Console → Project Settings → General → Your apps
- Copy the values from your Firebase configuration object

**For other services:**

- Add API keys for Google Maps, Stripe, Analytics, etc.
- Uncomment the relevant lines and add your keys

### 3. Install Dependencies

```bash
flutter pub get
```

## Environment Files

### Available Files

- `.env` - Default environment file
- `.env.dev` - Development environment
- `.env.prod` - Production environment
- `.env.example` - Template file (safe to commit)
- `.env.dev.example` - Development template (safe to commit)
- `.env.prod.example` - Production template (safe to commit)

### Security

- ✅ `.env.example` files are committed to git (no secrets)
- ❌ `.env` files are excluded from git (contain secrets)

## Usage in Code

### Import the configuration service

```dart
import 'package:todo_app/config/environment_config.dart';
```

### Access environment variables

```dart
// Firebase configuration
String apiKey = EnvironmentConfig.firebaseApiKey;
String projectId = EnvironmentConfig.firebaseProjectId;

// Other API keys
String mapsKey = EnvironmentConfig.googleMapsApiKey;

// Custom variables
String customValue = EnvironmentConfig.get('CUSTOM_KEY', defaultValue: 'fallback');

// Check if variable exists
if (EnvironmentConfig.has('SOME_KEY')) {
  // Use the key
}

// Environment detection
if (EnvironmentConfig.isProduction) {
  // Production-specific code
} else if (EnvironmentConfig.isDevelopment) {
  // Development-specific code
}
```

## Loading Different Environment Files

The app loads `.env` by default. To load a specific environment file:

```dart
// Load development environment
await EnvironmentConfig.initialize(envFile: '.env.dev');

// Load production environment
await EnvironmentConfig.initialize(envFile: '.env.prod');
```

## Best Practices

### 1. Never Commit Secret Files

- Always use `.gitignore` to exclude `.env` files
- Only commit `.env.example` template files
- Double-check before committing that no secrets are included

### 2. Use Different Environments

- Development: `.env.dev` - Use test/development Firebase project
- Production: `.env.prod` - Use production Firebase project
- This prevents accidents with production data

### 3. Document Your Variables

- Keep `.env.example` files updated
- Add comments explaining what each variable is for
- Include instructions for getting the values

### 4. Validate Required Variables

- Check for required environment variables at startup
- Provide meaningful error messages if variables are missing

## Common Environment Variables

### Firebase

```bash
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:web:abcdef123456
```

### Other Services

```bash
GOOGLE_MAPS_API_KEY=your_google_maps_key
STRIPE_PUBLISHABLE_KEY=pk_test_...
ANALYTICS_KEY=your_analytics_key
```

### App Configuration

```bash
APP_ENV=development
DEBUG_MODE=true
```

## Troubleshooting

### Environment file not loading

1. Check that the file exists in the project root
2. Verify the file is included in `pubspec.yaml` assets
3. Check for syntax errors in the `.env` file
4. Make sure you're calling `EnvironmentConfig.initialize()` before using variables

### Missing variables

1. Check the `.env.example` file for the correct variable names
2. Verify the variable is defined in your `.env` file
3. Use `EnvironmentConfig.has('VARIABLE_NAME')` to check if it exists

### Flutter build issues

1. Run `flutter clean` and `flutter pub get`
2. Check that all required `.env` files exist
3. Verify the `pubspec.yaml` assets section includes your `.env` files
