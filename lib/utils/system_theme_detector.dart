import 'package:flutter/material.dart';
import '../themes/themes.dart';

/// Service that detects and responds to system theme changes
class SystemThemeDetector {
  static SystemThemeDetector? _instance;
  static SystemThemeDetector get instance =>
      _instance ??= SystemThemeDetector._();

  SystemThemeDetector._();

  /// Brightness change notifier
  static final ValueNotifier<Brightness> brightnessNotifier = ValueNotifier(
    WidgetsBinding.instance.platformDispatcher.platformBrightness,
  );

  /// Initialize system theme detection
  static void initialize() {
    // Listen to system brightness changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          final newBrightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          brightnessNotifier.value = newBrightness;

          // Update app theme if using system mode
          if (ThemeConfig.currentThemeMode == AppThemeMode.system) {
            _updateSystemTheme();
          }
        };

    // Set initial brightness
    brightnessNotifier.value =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  /// Get current system brightness
  static Brightness get systemBrightness => brightnessNotifier.value;

  /// Check if system is in dark mode
  static bool get isSystemDark => systemBrightness == Brightness.dark;

  /// Check if system is in light mode
  static bool get isSystemLight => systemBrightness == Brightness.light;

  /// Update theme based on system settings
  static void _updateSystemTheme() {
    // This triggers a rebuild of the app with the new system theme
    // The actual theme switching is handled by ThemeConfig
  }

  /// Enable automatic theme switching based on system
  static void enableSystemTheme() {
    ThemeConfig.setThemeMode(AppThemeMode.system);
  }

  /// Disable automatic theme switching
  static void disableSystemTheme({required bool useDarkMode}) {
    ThemeConfig.setThemeMode(
      useDarkMode ? AppThemeMode.dark : AppThemeMode.light,
    );
  }

  /// Check if device supports dark mode detection
  static bool get supportsSystemTheme {
    // Most modern platforms support this
    return true;
  }

  /// Get appropriate theme mode based on system settings
  static AppThemeMode getRecommendedThemeMode() {
    return isSystemDark ? AppThemeMode.dark : AppThemeMode.light;
  }
}

/// Widget that automatically responds to system theme changes
class SystemThemeResponder extends StatefulWidget {
  final Widget child;
  final bool followSystemTheme;

  const SystemThemeResponder({
    super.key,
    required this.child,
    this.followSystemTheme = true,
  });

  @override
  State<SystemThemeResponder> createState() => _SystemThemeResponderState();
}

class _SystemThemeResponderState extends State<SystemThemeResponder> {
  @override
  void initState() {
    super.initState();
    SystemThemeDetector.initialize();

    // Listen to system brightness changes
    SystemThemeDetector.brightnessNotifier.addListener(_onBrightnessChanged);
  }

  @override
  void dispose() {
    SystemThemeDetector.brightnessNotifier.removeListener(_onBrightnessChanged);
    super.dispose();
  }

  void _onBrightnessChanged() {
    if (widget.followSystemTheme &&
        ThemeConfig.currentThemeMode == AppThemeMode.system) {
      // Trigger a rebuild to apply new system theme
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Mixin for widgets that need to respond to system theme changes
mixin SystemThemeAware<T extends StatefulWidget> on State<T> {
  late VoidCallback _brightnessListener;

  @override
  void initState() {
    super.initState();
    _brightnessListener = () {
      if (mounted) {
        onSystemThemeChanged(SystemThemeDetector.systemBrightness);
      }
    };
    SystemThemeDetector.brightnessNotifier.addListener(_brightnessListener);
  }

  @override
  void dispose() {
    SystemThemeDetector.brightnessNotifier.removeListener(_brightnessListener);
    super.dispose();
  }

  /// Called when system theme changes
  void onSystemThemeChanged(Brightness brightness) {
    setState(() {});
  }
}

/// Widget that shows system theme status
class SystemThemeIndicator extends StatelessWidget {
  const SystemThemeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: SystemThemeDetector.brightnessNotifier,
      builder: (context, brightness, child) {
        final isSystemDark = brightness == Brightness.dark;
        final isFollowingSystem =
            ThemeConfig.currentThemeMode == AppThemeMode.system;

        return Container(
          padding: DesignTokens.paddingSmall,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: DesignTokens.borderRadiusSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSystemDark ? Icons.dark_mode : Icons.light_mode,
                size: DesignTokens.iconSizeSmall,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'System: ${isSystemDark ? 'Dark' : 'Light'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (isFollowingSystem) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.sync,
                  size: DesignTokens.iconSizeSmall,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Settings tile for system theme detection
class SystemThemeSettingsTile extends StatelessWidget {
  const SystemThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeConfig.themeModeNotifier,
      builder: (context, themeMode, child) {
        final isSystemMode = themeMode == AppThemeMode.system;

        return AdaptiveComponents.adaptiveListTile(
          title: 'Follow System Theme',
          subtitle: isSystemMode
              ? 'App theme matches system settings'
              : 'Use custom theme selection',
          leading: Icon(
            Icons.brightness_auto,
            color: isSystemMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          trailing: AdaptiveComponents.adaptiveSwitch(
            value: isSystemMode,
            onChanged: (value) {
              if (value) {
                ThemeConfig.setThemeMode(AppThemeMode.system);
              } else {
                // Switch to current system brightness as manual setting
                final brightness = SystemThemeDetector.systemBrightness;
                ThemeConfig.setThemeMode(
                  brightness == Brightness.dark
                      ? AppThemeMode.dark
                      : AppThemeMode.light,
                );
              }
            },
          ),
          onTap: () {
            // Toggle system theme mode
            if (isSystemMode) {
              final brightness = SystemThemeDetector.systemBrightness;
              ThemeConfig.setThemeMode(
                brightness == Brightness.dark
                    ? AppThemeMode.dark
                    : AppThemeMode.light,
              );
            } else {
              ThemeConfig.setThemeMode(AppThemeMode.system);
            }
          },
        );
      },
    );
  }
}
