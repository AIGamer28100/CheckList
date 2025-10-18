# 📝 CheckList - Flutter Todo App

A modern, cross-platform todo/checklist application built with Flutter and Firebase. Features multi-provider authentication and real-time synchronization across all your devices.

## ✨ Features

### 🔐 **Multi-Provider Authentication**
- 📧 **Email/Password** - Traditional registration and login
- 🔍 **Google Sign-In** - Quick sign-in with Google account
- 📱 **Phone Authentication** - SMS-based OTP verification
- 🐙 **GitHub Sign-In** - Developer-friendly GitHub OAuth

### ✅ **Todo Management**
- ➕ Create, edit, and delete todos
- ✅ Mark todos as complete/incomplete
- 🔄 Real-time synchronization with Firebase Firestore
- 📱 Works across Web, iOS, Android, macOS, Windows, and Linux

### 🛡️ **Security & Privacy**
- 🔒 Secure authentication with Firebase Auth
- 🌐 Environment-based configuration
- 🔐 No sensitive data committed to Git
- 🛠️ Comprehensive setup documentation

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0+)
- Firebase account
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/AIGamer28100/CheckList.git
   cd CheckList
   ```

2. **Copy configuration files**
   ```bash
   cp config/env/.env.sample config/env/.env
   cp lib/firebase_options.dart.sample lib/firebase_options.dart
   cp android/app/google-services.json.sample android/app/google-services.json
   cp ios/Runner/GoogleService-Info.plist.sample ios/Runner/GoogleService-Info.plist
   ```

3. **Configure Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add your app for each platform (Web, Android, iOS)
   - Fill in the configuration files with your Firebase credentials
   - Enable Authentication providers in Firebase Console

4. **Install dependencies and run**
   ```bash
   flutter pub get
   flutter run
   ```

📚 **For detailed setup instructions, see the Setup section below**

## 🔧 Setup Guide

### Prerequisites
- Flutter SDK (3.0+)
- Firebase account
- Git

### Step 1: Copy Configuration Files

Copy these sample files and rename them:

```bash
# Environment files
cp config/env/.env.sample config/env/.env
cp config/env/.env.dev.sample config/env/.env.dev  
cp config/env/.env.prod.sample config/env/.env.prod

# Firebase configuration
cp lib/firebase_options.dart.sample lib/firebase_options.dart
cp android/app/google-services.json.sample android/app/google-services.json
cp ios/Runner/GoogleService-Info.plist.sample ios/Runner/GoogleService-Info.plist
```

### Step 2: Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add your app for each platform:
   - **Web**: Register with app nickname
   - **Android**: Package name `com.example.todo_app` 
   - **iOS**: Bundle ID `com.example.todoApp`

### Step 3: Configure Environment Files

#### Main Environment File (`config/env/.env`)
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

### Step 4: Enable Authentication Providers

1. Go to Firebase Console → Authentication
2. Click "Get started"  
3. Go to "Sign-in method" tab
4. Enable these providers:
   - ✅ **Email/Password**
   - ✅ **Google** 
   - ✅ **Phone**
   - ✅ **GitHub** (requires OAuth app setup)

#### GitHub Setup (Optional)
1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create "New OAuth App"
3. Set callback URL: `https://your-project.firebaseapp.com/__/auth/handler`
4. Copy Client ID and Secret to `config/env/.env`

### Step 5: Run the Application

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Troubleshooting

**Missing Files Error**
- Make sure you copied all sample files
- Check that files exist: `config/env/.env`, `lib/firebase_options.dart`, etc.

**Authentication Errors**
- Verify Firebase project has auth providers enabled
- Check that credentials in `config/env/.env` match Firebase Console
- For Google Sign-In: Basic functionality works without client IDs

**Build Errors**
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are configured
- Run `flutter clean` and `flutter pub get`

## 🏗️ Project Structure

```
lib/
├── config/
│   └── environment_config.dart    # Environment configuration service
├── screens/
│   ├── auth_wrapper.dart          # Authentication state management
│   ├── login_screen.dart          # Multi-provider login interface
│   └── home_screen.dart           # Todo management interface
├── services/
│   ├── auth_service.dart          # Authentication service
│   └── firestore_service.dart     # Database operations
└── main.dart                      # App entry point
```

## 🔧 Configuration Files

### Sample Files (Safe for Git)
- ✅ `config/env/.env.sample` - Environment template
- ✅ `lib/firebase_options.dart.sample` - Firebase options template
- ✅ `android/app/google-services.json.sample` - Android config template
- ✅ `ios/Runner/GoogleService-Info.plist.sample` - iOS config template

### Secret Files (Git Ignored)
- ❌ `config/env/.env` - Your actual environment variables
- ❌ `lib/firebase_options.dart` - Your Firebase configuration
- ❌ `android/app/google-services.json` - Android Firebase config
- ❌ `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

## 🌐 Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| 🌐 Web | ✅ Supported | Runs in any modern browser |
| 🤖 Android | ✅ Supported | API 21+ (Android 5.0+) |
| 🍎 iOS | ✅ Supported | iOS 11.0+ |
| 💻 macOS | ✅ Supported | macOS 10.14+ |
| 🪟 Windows | ✅ Supported | Windows 10+ |
| 🐧 Linux | ✅ Supported | Any modern Linux distribution |

## 🔑 Authentication Providers

| Provider | Status | Setup Required |
|----------|--------|----------------|
| Email/Password | ✅ Enabled | Firebase Console only |
| Google Sign-In | ✅ Enabled | Basic (no client ID needed) |
| Phone Auth | ✅ Enabled | Firebase Console + reCAPTCHA |
| GitHub OAuth | ⚙️ Optional | GitHub OAuth app setup |

## 🛠️ Development

### Branch Protection
- 🔒 **Master branch** is protected
- 🔄 All changes must go through Pull Requests
- 👥 At least 1 approval required
- 💬 Conversations must be resolved

### Development Workflow
1. Create feature branch from `development`
2. Make your changes
3. Create Pull Request to `development`
4. Get approval and merge
5. Create PR from `development` to `master` for releases

### Available Scripts
```bash
# Run the app
flutter run

# Run tests
flutter test

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release

# Build for web
flutter build web
```

## 📚 Additional Resources

- 🔥 **Firebase**: [Firebase Console](https://console.firebase.google.com/)
- � **Flutter**: [Flutter Documentation](https://docs.flutter.dev/)
- 🔐 **FlutterFire**: [Firebase for Flutter](https://firebase.flutter.dev/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch from `development`
3. Make your changes
4. Ensure tests pass
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- 📱 **Repository**: [GitHub.com/AIGamer28100/CheckList](https://github.com/AIGamer28100/CheckList)
- 🔥 **Firebase**: [Firebase Console](https://console.firebase.google.com/)
- 📘 **Flutter**: [Flutter Documentation](https://docs.flutter.dev/)
- 🔐 **FlutterFire**: [Firebase for Flutter](https://firebase.flutter.dev/)

## 📧 Support

If you encounter any issues or have questions:

1. Check the Setup Guide section above
2. Search existing GitHub issues
3. Create a new issue with detailed information

---

**Built with ❤️ using Flutter & Firebase**
