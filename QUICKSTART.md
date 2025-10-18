# Quick Setup Guide for CheckList App

This guide will help you get the CheckList app running on your machine in under 5 minutes.

## Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Git
- IDE: Android Studio, VS Code, or IntelliJ IDEA with Flutter plugin

## Quick Start (Development Mode)

### 1. Clone the Repository
```bash
git clone https://github.com/AIGamer28100/CheckList.git
cd CheckList
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App
```bash
# For desktop
flutter run -d linux    # Linux
flutter run -d windows  # Windows
flutter run -d macos    # macOS

# For mobile
flutter run -d android  # Android
flutter run -d ios      # iOS

# For web
flutter run -d chrome   # Web
```

That's it! The app should now be running on your device.

## What Works Out of the Box

### ✅ Fully Functional (No Configuration Needed)
- Material 3 UI with theme switching
- Task creation, editing, deletion
- Priority levels and status tracking
- Tags and due dates
- Search and filtering
- Sorting by multiple criteria
- Progress tracking
- Offline data persistence with SQLite
- Theme persistence (Light/Dark/System)
- Dynamic colors (on supported devices)

### ⚠️ Requires Configuration (Optional)
- Firebase authentication
- Cloud synchronization
- Multi-device sync
- Real-time updates

## File Structure Overview

```
CheckList/
├── lib/
│   ├── models/              # Data models (Task, User, etc.)
│   ├── viewmodels/          # Business logic
│   ├── views/               # UI screens
│   ├── widgets/             # Reusable components
│   ├── repositories/        # Data access layer
│   ├── themes/              # Material 3 theming
│   ├── utils/               # Helper utilities
│   ├── services/            # External services
│   ├── config/              # Configuration
│   └── main.dart            # App entry point
├── config/env/              # Environment variables
├── README.md                # Full documentation
├── TODO.md                  # Development roadmap
└── IMPLEMENTATION_SUMMARY.md # Implementation details
```

## Development Workflow

### 1. Making Changes to Models
If you modify any model files (Task, User, etc.), regenerate the code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use watch mode during development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 2. Adding New Features
1. Create model in `lib/models/` (if needed)
2. Create repository in `lib/repositories/` (if needed)
3. Create/update ViewModel in `lib/viewmodels/`
4. Create view in `lib/views/` or widget in `lib/widgets/`
5. Update navigation in `main.dart` or relevant parent

### 3. Testing
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

### 4. Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## Common Issues & Solutions

### Issue: "flutter: command not found"
**Solution**: Make sure Flutter is in your PATH
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### Issue: Build errors after cloning
**Solution**: Clean and reinstall dependencies
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: "No connected devices"
**Solution**: 
- For desktop: Enable desktop support
  ```bash
  flutter config --enable-linux-desktop
  flutter config --enable-windows-desktop
  flutter config --enable-macos-desktop
  ```
- For mobile: Connect device or start emulator
- For web: Browser should work by default

### Issue: Generated files (.g.dart, .freezed.dart) missing
**Solution**: Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Theme not changing
**Solution**: Hot restart (not hot reload)
```bash
# Press 'R' in terminal or
# Click hot restart button in IDE
```

## Features to Explore

### 1. Material 3 Theming
- Go to Settings (gear icon)
- Switch between Light/Dark/System modes
- Toggle Dynamic Colors (on Android 12+)
- View color palette preview

### 2. Task Management
- Tap FAB (+) to create task
- Set priority (Low/Medium/High/Urgent)
- Add due dates and reminders
- Add tags for organization
- Use quick actions for search/filter/sort

### 3. Material 3 Demo
- Currently accessed via code (Material3DemoView)
- Shows all Material 3 components
- Color palette display
- Navigation examples

### 4. Task Features
- Tap checkbox to complete/uncomplete
- Swipe for more options (coming soon)
- Long press for quick actions (coming soon)
- Pull down to refresh

## Configuration (Optional)

### For Firebase Integration

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project
   - Add your app for each platform

2. **Update Configuration Files**
   
   Edit `lib/firebase_options.dart`:
   ```dart
   // Replace placeholder values with your actual Firebase config
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'your-actual-api-key',
     appId: 'your-actual-app-id',
     // ... other values
   );
   ```

3. **Update Environment File**
   
   Edit `config/env/.env`:
   ```env
   FIREBASE_API_KEY=your_actual_api_key
   FIREBASE_PROJECT_ID=your_actual_project_id
   # ... other values
   ```

4. **Enable Authentication**
   - In Firebase Console → Authentication
   - Enable desired sign-in methods
   - Configure OAuth providers

## Development Tips

### 1. Use Hot Reload
Press `r` in terminal or click hot reload for UI changes

### 2. Use Hot Restart
Press `R` in terminal for logic changes or theme updates

### 3. Debug Mode
Add breakpoints in your IDE and use debug mode

### 4. Performance
Use Flutter DevTools for performance profiling:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 5. Widget Inspector
Use Flutter Inspector in your IDE to examine widget tree

## IDE Setup

### VS Code Extensions
- Flutter
- Dart
- Awesome Flutter Snippets (optional)
- Error Lens (optional)

### Android Studio Plugins
- Flutter
- Dart
- Rainbow Brackets (optional)

### IntelliJ IDEA Plugins
- Flutter
- Dart

## Next Steps

1. **Explore the App**: Run it and try all features
2. **Read Documentation**: Check README.md for detailed info
3. **Review Code**: Understand the architecture
4. **Make Changes**: Try adding a simple feature
5. **Contribute**: Open a PR with improvements

## Resources

- **Full Documentation**: [README.md](README.md)
- **Implementation Details**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
- **Development Roadmap**: [TODO.md](TODO.md)
- **Flutter Docs**: [flutter.dev](https://flutter.dev)
- **Material 3 Guidelines**: [m3.material.io](https://m3.material.io)

## Getting Help

- **Issues**: Open an issue on GitHub
- **Questions**: Check existing issues first
- **Documentation**: Start with README.md
- **Flutter**: [Flutter Discord](https://discord.gg/flutter)

## Quick Commands Reference

```bash
# Development
flutter run -d <device>           # Run app
flutter hot-reload                # Quick reload (r)
flutter hot-restart               # Full restart (R)

# Code Generation
flutter pub run build_runner build   # Generate once
flutter pub run build_runner watch   # Auto-generate

# Testing & Quality
flutter test                      # Run tests
flutter analyze                   # Check code
flutter format lib/               # Format code

# Building
flutter build apk                 # Android APK
flutter build appbundle          # Android App Bundle
flutter build ios                 # iOS
flutter build web                 # Web
flutter build linux              # Linux
flutter build windows            # Windows
flutter build macos              # macOS

# Maintenance
flutter clean                     # Clean build
flutter pub get                   # Get dependencies
flutter pub upgrade              # Upgrade dependencies
flutter doctor                   # Check setup
```

## Success Checklist

- [ ] Flutter installed and in PATH
- [ ] Repository cloned
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Code generated (`build_runner`)
- [ ] App runs successfully
- [ ] Can create tasks
- [ ] Can switch themes
- [ ] Database persists data
- [ ] Search works
- [ ] Filter works

If you've checked all these, you're ready to develop! 🎉

---

**Last Updated**: October 2024
**Difficulty**: ⭐⭐ (Easy to Medium)
**Time to Setup**: 5-10 minutes
