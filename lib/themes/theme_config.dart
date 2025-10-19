import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';
import 'app_theme.dart';
import 'design_tokens.dart';

/// Available theme modes
enum AppThemeMode { light, dark, system }

/// Cross-platform theme configuration that manages theme switching
/// and platform-specific adaptations
class ThemeConfig {
  /// Current theme mode notifier
  static ValueNotifier<AppThemeMode> themeModeNotifier = ValueNotifier(
    AppThemeMode.system,
  );

  /// Get light theme data with platform adaptations
  static Future<ThemeData> getLightTheme(BuildContext context) async {
    final baseTheme = await AppTheme.getTheme(brightness: Brightness.light);

    // Apply platform-specific modifications
    if (PlatformUtils.isIOS) {
      return baseTheme.copyWith(
        // iOS-specific light theme adjustments
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          elevation: DesignTokens.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadiusLarge,
          ),
        ),
      );
    } else if (PlatformUtils.isDesktop) {
      return baseTheme.copyWith(
        // Desktop-specific light theme adjustments
        appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: DesignTokens.elevationLow,
          toolbarHeight: DesignTokens.appBarHeight,
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          elevation: DesignTokens.elevationMedium,
          shape: RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadius,
          ),
        ),
        inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
          contentPadding: DesignTokens.paddingSmall,
        ),
      );
    }

    // Android and Web use base Material 3 theme
    return baseTheme;
  }

  /// Get dark theme data with platform adaptations
  static Future<ThemeData> getDarkTheme(BuildContext context) async {
    final baseTheme = await AppTheme.getTheme(brightness: Brightness.dark);

    // Apply platform-specific modifications
    if (PlatformUtils.isIOS) {
      return baseTheme.copyWith(
        // iOS-specific dark theme adjustments
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          elevation: DesignTokens.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadiusLarge,
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
      );
    } else if (PlatformUtils.isDesktop) {
      return baseTheme.copyWith(
        // Desktop-specific dark theme adjustments
        appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: DesignTokens.elevationLow,
          toolbarHeight: DesignTokens.appBarHeight,
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          elevation: DesignTokens.elevationMedium,
          shape: RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadius,
          ),
        ),
        inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
          contentPadding: DesignTokens.paddingSmall,
        ),
      );
    }

    // Android and Web use base Material 3 dark theme
    return baseTheme;
  }

  /// Get current theme mode
  static AppThemeMode get currentThemeMode => themeModeNotifier.value;

  /// Set theme mode and persist preference
  static void setThemeMode(AppThemeMode mode) {
    themeModeNotifier.value = mode;
    _saveThemePreference(mode);
  }

  /// Toggle between light and dark themes
  static void toggleTheme() {
    switch (currentThemeMode) {
      case AppThemeMode.light:
        setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        setThemeMode(AppThemeMode.light);
        break;
      case AppThemeMode.system:
        // When system theme, toggle to opposite of current system setting
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        setThemeMode(
          brightness == Brightness.dark
              ? AppThemeMode.light
              : AppThemeMode.dark,
        );
        break;
    }
  }

  /// Get ThemeMode enum value for MaterialApp
  static ThemeMode getThemeMode() {
    switch (currentThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark;
  }

  /// Get appropriate text color for current theme
  static Color getTextColor(BuildContext context) {
    return isDarkMode(context) ? Colors.white : Colors.black;
  }

  /// Get appropriate background color for current theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get appropriate surface color for current theme
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Get appropriate primary color for current theme
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Get platform-specific icon theme
  static IconThemeData getIconTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (PlatformUtils.isIOS) {
      return IconThemeData(
        size: DesignTokens.iconSizeRegular,
        color: colorScheme.onSurface,
      );
    } else if (PlatformUtils.isDesktop) {
      return IconThemeData(
        size:
            DesignTokens.iconSizeRegular * 0.9, // Slightly smaller for desktop
        color: colorScheme.onSurface,
      );
    }

    // Material default
    return IconThemeData(
      size: DesignTokens.iconSizeRegular,
      color: colorScheme.onSurface,
    );
  }

  /// Get platform-specific text theme
  static TextTheme getTextTheme(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    if (PlatformUtils.isIOS) {
      // iOS San Francisco font styling
      return baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: DesignTokens.fontSizeBody,
          height: 1.4,
          letterSpacing: -0.2,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: DesignTokens.fontSizeBody * 0.9,
          height: 1.3,
          letterSpacing: -0.1,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: DesignTokens.fontSizeHeading,
          height: 1.2,
          letterSpacing: -0.3,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (PlatformUtils.isDesktop) {
      // Desktop optimized text
      return baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: DesignTokens.fontSizeBody * 0.9,
          height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: DesignTokens.fontSizeBody * 0.8,
          height: 1.4,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: DesignTokens.fontSizeHeading * 0.9,
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // Material default text theme
    return baseTextTheme;
  }

  /// Initialize theme from stored preferences
  static Future<void> initializeTheme() async {
    // In a real app, you would load from SharedPreferences or similar
    // For now, we'll use system theme as default
    themeModeNotifier.value = AppThemeMode.system;
  }

  /// Save theme preference (placeholder for actual persistence)
  static Future<void> _saveThemePreference(AppThemeMode mode) async {
    // In a real app, you would save to SharedPreferences or similar
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_themePrefsKey, mode.toString());
  }
}
