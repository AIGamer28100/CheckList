import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// Theme mode enumeration
enum AppThemeMode { light, dark, system }

/// Theme state class
class ThemeState {
  final AppThemeMode themeMode;
  final bool useDynamicColors;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const ThemeState({
    required this.themeMode,
    required this.useDynamicColors,
    required this.lightTheme,
    required this.darkTheme,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? useDynamicColors,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}

/// Theme provider for managing app theme state
class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeModeKey = 'theme_mode';
  static const String _useDynamicColorsKey = 'use_dynamic_colors';

  ThemeNotifier()
    : super(
        ThemeState(
          themeMode: AppThemeMode.system,
          useDynamicColors: true,
          lightTheme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
        ),
      ) {
    _loadSettings();
    _initializeThemes();
  }

  /// Load theme settings from shared preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final themeModeIndex =
          prefs.getInt(_themeModeKey) ?? AppThemeMode.system.index;
      final useDynamicColors = prefs.getBool(_useDynamicColorsKey) ?? true;

      state = state.copyWith(
        themeMode: AppThemeMode.values[themeModeIndex],
        useDynamicColors: useDynamicColors,
      );

      _initializeThemes();
    } catch (e) {
      debugPrint('Failed to load theme settings: $e');
    }
  }

  /// Initialize themes with current settings
  Future<void> _initializeThemes() async {
    try {
      final dynamicColors = state.useDynamicColors
          ? await AppTheme.getDynamicColorSchemes()
          : (light: null, dark: null);

      final lightTheme = await AppTheme.getTheme(
        brightness: Brightness.light,
        dynamicColorScheme: dynamicColors.light,
      );

      final darkTheme = await AppTheme.getTheme(
        brightness: Brightness.dark,
        dynamicColorScheme: dynamicColors.dark,
      );

      state = state.copyWith(lightTheme: lightTheme, darkTheme: darkTheme);
    } catch (e) {
      debugPrint('Failed to initialize themes: $e');
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);

      state = state.copyWith(themeMode: themeMode);
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }

  /// Toggle dynamic colors usage
  Future<void> toggleDynamicColors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newValue = !state.useDynamicColors;
      await prefs.setBool(_useDynamicColorsKey, newValue);

      state = state.copyWith(useDynamicColors: newValue);
      _initializeThemes();
    } catch (e) {
      debugPrint('Failed to toggle dynamic colors: $e');
    }
  }

  /// Get the appropriate theme mode for the app
  ThemeMode get effectiveThemeMode {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if dynamic colors are available
  Future<bool> isDynamicColorAvailable() async {
    return await AppTheme.isDynamicColorAvailable();
  }
}

/// Provider for theme notifier
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

/// Provider for effective theme mode
final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeNotifier = ref.read(themeProvider.notifier);
  return themeNotifier.effectiveThemeMode;
});

/// Provider for dynamic color availability
final dynamicColorAvailabilityProvider = FutureProvider<bool>((ref) async {
  final themeNotifier = ref.read(themeProvider.notifier);
  return await themeNotifier.isDynamicColorAvailable();
});

/// Extensions for theme mode
extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
