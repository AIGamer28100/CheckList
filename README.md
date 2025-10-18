# 📝 CheckList - Material 3 Task Management App

A modern, cross-platform task management application built with Flutter, featuring Material 3 design system, MVVM architecture, Firebase integration, and comprehensive offline capabilities.

## ✨ Key Features

### 🎨 **Material 3 Design System** (New!)
- 🌈 **Dynamic Colors** - Automatically adapts to system wallpaper colors (Android 12+)
- 🎭 **Adaptive Themes** - Seamlessly switch between Light, Dark, and System modes
- 🎨 **Modern Components** - Latest Material 3 widgets (FAB, Cards, Buttons, AppBars)
- 💎 **Professional UI** - Clean, modern interface inspired by leading task management apps
- 🎯 **Component Showcase** - Dedicated view to explore Material 3 components

### 🚀 **Modern Task Management** (New!)
- ✨ **Smart Organization** - Create tasks with priorities, tags, due dates, and reminders
- 📊 **Visual Progress** - Track productivity with completion statistics and progress bars
- ⚡ **Quick Actions** - One-tap access to create, search, filter, and sort tasks
- 👋 **Time-Based Greetings** - Personalized welcome messages (morning/afternoon/evening)
- 🔄 **Pull-to-Refresh** - Intuitive gesture-based data updates
- 🎯 **Priority Levels** - Low, Medium, High, and Urgent
- 📝 **Rich Metadata** - Descriptions, tags, locations, estimated time
- 🔍 **Powerful Search** - Find tasks quickly across all fields

### 🏗️ **Robust Architecture** (New!)
- 📐 **MVVM Pattern** - Clean separation with ViewModel layer
- 🔄 **Riverpod** - Efficient and scalable state management
- 🗄️ **Repository Pattern** - Abstracted data access layer
- ❄️ **Freezed Models** - Immutable data classes with JSON serialization
- 💾 **SQLite Database** - Reliable offline-first data persistence
- 🖥️ **Desktop Support** - Optimized for Linux, Windows, and macOS

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

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (Freezed models)**
   ```bash
   # One-time generation
   flutter pub run build_runner build --delete-conflicting-outputs
   
   # Or watch mode for development
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

4. **Copy configuration files**
   ```bash
   # Environment files (already created)
   ls config/env/.env
   
   # Firebase options (already configured for development)
   ls lib/firebase_options.dart
   ```

5. **Run the app**
   ```bash
   # For desktop (Linux/Windows/macOS)
   flutter run -d linux
   flutter run -d windows
   flutter run -d macos

   # For mobile
   flutter run -d android
   flutter run -d ios

   # For web
   flutter run -d chrome
   ```

### Optional: Firebase Configuration

The app works without Firebase for local-only features. To enable Firebase:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your app for each platform (Web, Android, iOS)
3. Update `lib/firebase_options.dart` with your Firebase credentials
4. Enable Authentication providers in Firebase Console
5. Download and add platform-specific files:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`

📚 **For detailed Firebase setup, see the Firebase Setup section below**

## 🎨 Material 3 Features

### Dynamic Color System
The app automatically adapts to your device's wallpaper colors on Android 12+ devices:

1. **Automatic Theme Generation**: Colors are extracted from your wallpaper
2. **Adaptive Palettes**: Light and dark themes are generated automatically
3. **Fallback Colors**: Uses elegant default Material 3 purple theme on unsupported devices

### Theme Modes
Switch between three theme modes in Settings:
- 🌞 **Light Mode**: Clean, bright interface
- 🌙 **Dark Mode**: Easy on the eyes for low-light environments
- 🔄 **System Mode**: Automatically follows system theme (default)

### Material 3 Components Showcase
Visit the Material 3 Demo view to explore:
- Buttons (Filled, Tonal, Elevated, Outlined, Text)
- Cards (Elevated, Filled, Outlined)
- Text Fields (Filled, Outlined)
- Chips (Input, Filter, Action, Choice)
- Navigation components
- Complete color palette

### TaskListView Features
The modern task list includes:
- **Gradient SliverAppBar**: Expands and collapses smoothly
- **Time-Based Greetings**: "Good morning/afternoon/evening"
- **Progress Tracking**: Visual progress bar and completion stats
- **Quick Actions**: Create, Search, Filter, Sort buttons
- **Smart Empty State**: Encouraging message when no tasks exist
- **Pull to Refresh**: Gesture-based refresh
- **Material 3 Cards**: Beautiful task cards with priority indicators

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
├── models/                         # Data models with Freezed
│   ├── task.dart                  # Task model with rich metadata
│   ├── user.dart                  # User model
│   ├── category.dart              # Category model
│   ├── note.dart                  # Note model
│   └── workspace_data.dart        # Workspace model
├── viewmodels/                     # Business logic layer (MVVM)
│   └── task_viewmodel.dart        # Task state management
├── views/                          # UI screens
│   ├── task_list_view.dart        # Modern task list with Material 3
│   ├── settings_view.dart         # Theme and settings management
│   └── material3_demo_view.dart   # Material 3 component showcase
├── widgets/                        # Reusable components
│   ├── task_card.dart             # Material 3 task card widget
│   └── create_task_dialog.dart    # Task creation dialog
├── repositories/                   # Data access layer
│   ├── base_repository.dart       # Base repository interface
│   ├── task_repository.dart       # Task data operations
│   └── user_repository.dart       # User data operations
├── themes/                         # Material 3 theming
│   ├── app_theme.dart             # Theme configuration
│   └── theme_provider.dart        # Theme state management
├── utils/                          # Helper utilities
│   └── database_helper.dart       # SQLite database management
├── services/                       # External services
│   ├── auth_service.dart          # Authentication service
│   └── firestore_service.dart     # Firestore operations
├── screens/                        # Legacy screens (being migrated)
│   ├── auth_wrapper.dart          # Authentication state wrapper
│   ├── login_screen.dart          # Multi-provider login interface
│   └── home_screen.dart           # Legacy home interface
├── config/
│   └── environment_config.dart    # Environment configuration service
└── main.dart                       # App entry point with Material 3
```

### Technologies & Packages

**Core:**
- **Flutter 3.9+** - Cross-platform UI framework
- **Dart 3.9+** - Programming language

**State Management & Architecture:**
- **Riverpod 2.5+** - Modern state management
- **Provider 6.1+** - Widget state management

**Data & Persistence:**
- **SQLite (sqflite 2.3+)** - Local database
- **sqflite_common_ffi** - Desktop SQLite support
- **sqlite3_flutter_libs** - Desktop platform compatibility
- **Freezed 2.5+** - Immutable models and unions
- **json_annotation/serializable** - JSON serialization
- **shared_preferences** - Settings persistence
- **path_provider** - File system access

**UI & Design:**
- **Material 3** - Latest design system
- **dynamic_color 1.7+** - Wallpaper-based theming
- **material_color_utilities** - Color manipulation

**Backend & Services:**
- **Firebase Core** - Backend platform
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Cloud database (optional)
- **Firebase Storage** - File storage (optional)
- **Google Sign-In** - Google OAuth

**Utilities:**
- **http/dio** - Networking
- **intl** - Internationalization
- **url_launcher** - External links
- **crypto** - Encryption utilities

**Development:**
- **build_runner** - Code generation
- **flutter_lints** - Code quality
- **mockito** - Testing mocks

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
