# 🔐 Secret Configuration Setup Guide

This guide explains how to set up the secret files required to run the CheckList application.

## 📋 Quick Setup Steps

1. **Copy sample files** to create your configuration files
2. **Configure Firebase project** and get credentials  
3. **Fill in your actual values** in the copied files
4. **Run the application**

---

## 🗂️ Files to Copy and Configure

### Step 1: Copy Sample Files

Copy these sample files and rename them:

```bash
# Environment files
cp .env.sample .env
cp .env.dev.sample .env.dev  
cp .env.prod.sample .env.prod

# Firebase configuration
cp lib/firebase_options.dart.sample lib/firebase_options.dart
cp android/app/google-services.json.sample android/app/google-services.json
cp ios/Runner/GoogleService-Info.plist.sample ios/Runner/GoogleService-Info.plist
```

### Step 2: Get Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add your app for each platform:
   - **Web**: Register with app nickname
   - **Android**: Package name `com.example.todo_app` 
   - **iOS**: Bundle ID `com.example.todoApp`

### Step 3: Fill in Configuration Files

#### Main Environment File (`.env`)
```env
# Required Firebase values
FIREBASE_API_KEY=AIzaSy...your_actual_key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:web:abc123...

# Optional authentication providers
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
```

#### Firebase Options File (`lib/firebase_options.dart`)
- Replace placeholder values with your actual Firebase configuration
- Get values from Firebase Console → Project Settings → General

#### Platform Files
- **Android**: `android/app/google-services.json` - Download from Firebase Console
- **iOS**: `ios/Runner/GoogleService-Info.plist` - Download from Firebase Console

---

## 🔑 Enable Authentication Providers

1. Go to Firebase Console → Authentication
2. Click "Get started"  
3. Go to "Sign-in method" tab
4. Enable these providers:
   - ✅ **Email/Password**
   - ✅ **Google** 
   - ✅ **Phone**
   - ✅ **GitHub** (requires OAuth app setup)

### GitHub Setup (Optional)
1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create "New OAuth App"
3. Set callback URL: `https://your-project.firebaseapp.com/__/auth/handler`
4. Copy Client ID and Secret to `.env`

---

## 🏃‍♂️ Run the Application

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🔍 Troubleshooting

### Missing Files Error
- Make sure you copied all sample files
- Check that files exist: `.env`, `lib/firebase_options.dart`, etc.

### Authentication Errors
- Verify Firebase project has auth providers enabled
- Check that credentials in `.env` match Firebase Console
- For Google Sign-In: Basic functionality works without client IDs

### Build Errors
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are configured
- Run `flutter clean` and `flutter pub get`

---

## � Sample Files Created

These sample files are safe to commit to Git:

- ✅ `.env.sample` - Environment template
- ✅ `.env.dev.sample` - Development template  
- ✅ `.env.prod.sample` - Production template
- ✅ `lib/firebase_options.dart.sample` - Firebase options template
- ✅ `android/app/google-services.json.sample` - Android config template
- ✅ `ios/Runner/GoogleService-Info.plist.sample` - iOS config template

These files contain your secrets and are ignored by Git:

- ❌ `.env` - Your actual environment variables
- ❌ `.env.dev` - Development environment  
- ❌ `.env.prod` - Production environment
- ❌ `lib/firebase_options.dart` - Your Firebase configuration
- ❌ `android/app/google-services.json` - Android Firebase config
- ❌ `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

---

## ✅ Ready to Use

Once setup is complete, you can:

- ✅ Run the app without errors
- ✅ Sign in with Email/Password  
- ✅ Sign in with Google
- ✅ Sign in with Phone number
- ✅ Sign in with GitHub (if configured)
- ✅ Create and manage your checklist todos

**Need help?** Check the [Firebase Documentation](https://firebase.google.com/docs) or [Flutter Documentation](https://docs.flutter.dev)