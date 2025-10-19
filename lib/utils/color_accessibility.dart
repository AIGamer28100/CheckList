import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Helper class for ensuring color accessibility compliance
class ColorAccessibility {
  /// WCAG 2.1 contrast ratio thresholds
  static const double _wcagAANormal = 4.5;
  static const double _wcagAALarge = 3.0;
  static const double _wcagAAANormal = 7.0;
  static const double _wcagAAALarge = 4.5;

  /// Calculate relative luminance of a color
  static double _getLuminance(Color color) {
    // Convert to linear RGB
    double r = _toLinearRGB((color.r * 255.0).round() / 255);
    double g = _toLinearRGB((color.g * 255.0).round() / 255);
    double b = _toLinearRGB((color.b * 255.0).round() / 255);

    // Calculate relative luminance
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Convert sRGB to linear RGB
  static double _toLinearRGB(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return math.pow((value + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Calculate contrast ratio between two colors
  static double getContrastRatio(Color color1, Color color2) {
    double lum1 = _getLuminance(color1);
    double lum2 = _getLuminance(color2);

    // Ensure the lighter color is in the numerator
    double lighter = math.max(lum1, lum2);
    double darker = math.min(lum1, lum2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if color combination meets WCAG AA standards
  static bool meetsWCAGAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    double ratio = getContrastRatio(foreground, background);
    return ratio >= (isLargeText ? _wcagAALarge : _wcagAANormal);
  }

  /// Check if color combination meets WCAG AAA standards
  static bool meetsWCAGAAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    double ratio = getContrastRatio(foreground, background);
    return ratio >= (isLargeText ? _wcagAAALarge : _wcagAAANormal);
  }

  /// Get accessibility level for color combination
  static AccessibilityLevel getAccessibilityLevel(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    if (meetsWCAGAAA(foreground, background, isLargeText: isLargeText)) {
      return AccessibilityLevel.aaa;
    } else if (meetsWCAGAA(foreground, background, isLargeText: isLargeText)) {
      return AccessibilityLevel.aa;
    } else {
      return AccessibilityLevel.fail;
    }
  }

  /// Adjust color to meet minimum contrast ratio
  static Color adjustForContrast(
    Color foreground,
    Color background, {
    double minRatio = 4.5,
  }) {
    double currentRatio = getContrastRatio(foreground, background);

    if (currentRatio >= minRatio) {
      return foreground; // Already meets requirements
    }

    // Determine if we need to lighten or darken
    double bgLuminance = _getLuminance(background);
    bool shouldLighten = bgLuminance < 0.5;

    HSVColor hsv = HSVColor.fromColor(foreground);

    // Binary search for the right value
    double minValue = shouldLighten ? hsv.value : 0.0;
    double maxValue = shouldLighten ? 1.0 : hsv.value;

    for (int i = 0; i < 20; i++) {
      // Max 20 iterations
      double midValue = (minValue + maxValue) / 2;
      Color testColor = hsv.withValue(midValue).toColor();
      double testRatio = getContrastRatio(testColor, background);

      if (testRatio >= minRatio) {
        if (shouldLighten) {
          maxValue = midValue;
        } else {
          minValue = midValue;
        }
      } else {
        if (shouldLighten) {
          minValue = midValue;
        } else {
          maxValue = midValue;
        }
      }
    }

    double finalValue = shouldLighten ? maxValue : minValue;
    return hsv.withValue(finalValue).toColor();
  }

  /// Get recommended text color for a background
  static Color getRecommendedTextColor(Color background) {
    double luminance = _getLuminance(background);

    // Use white text for dark backgrounds, black for light backgrounds
    Color textColor = luminance > 0.5 ? Colors.black : Colors.white;

    // Ensure it meets AA standards
    return adjustForContrast(textColor, background, minRatio: _wcagAANormal);
  }

  /// Validate theme colors for accessibility
  static ThemeAccessibilityReport validateTheme(ThemeData theme) {
    List<String> warnings = [];
    List<String> errors = [];

    ColorScheme colorScheme = theme.colorScheme;

    // Check primary text on surface
    if (!meetsWCAGAA(colorScheme.onSurface, colorScheme.surface)) {
      errors.add('Primary text on surface fails WCAG AA contrast requirements');
    }

    // Check primary button contrast
    if (!meetsWCAGAA(colorScheme.onPrimary, colorScheme.primary)) {
      errors.add('Primary button text fails WCAG AA contrast requirements');
    }

    // Check secondary button contrast
    if (!meetsWCAGAA(colorScheme.onSecondary, colorScheme.secondary)) {
      warnings.add('Secondary button text may have poor contrast');
    }

    // Check error color contrast
    if (!meetsWCAGAA(colorScheme.onError, colorScheme.error)) {
      errors.add('Error text fails WCAG AA contrast requirements');
    }

    // Check background text contrast
    if (!meetsWCAGAA(colorScheme.onSurface, colorScheme.surface)) {
      errors.add('Background text fails WCAG AA contrast requirements');
    }

    return ThemeAccessibilityReport(
      warnings: warnings,
      errors: errors,
      hasErrors: errors.isNotEmpty,
      hasWarnings: warnings.isNotEmpty,
    );
  }

  /// Create an accessible color palette from a seed color
  static Map<String, Color> createAccessiblePalette(Color seedColor) {
    HSVColor hsv = HSVColor.fromColor(seedColor);

    return {
      'primary': seedColor,
      'primaryLight': hsv.withValue(math.min(1.0, hsv.value + 0.2)).toColor(),
      'primaryDark': hsv.withValue(math.max(0.0, hsv.value - 0.3)).toColor(),
      'onPrimary': getRecommendedTextColor(seedColor),
      'surface': Colors.white,
      'onSurface': Colors.black87,
      'surfaceDark': const Color(0xFF121212),
      'onSurfaceDark': Colors.white,
      'error': const Color(0xFFB00020),
      'onError': Colors.white,
    };
  }

  /// Get semantic colors with guaranteed accessibility
  static MaterialColor createAccessibleMaterialColor(Color seedColor) {
    HSVColor hsv = HSVColor.fromColor(seedColor);

    Map<int, Color> swatch = {};

    // Generate shades with proper contrast
    for (int i = 1; i <= 9; i++) {
      double value = 1.0 - (i * 0.1);
      swatch[i * 100] = hsv.withValue(math.max(0.1, value)).toColor();
    }

    return MaterialColor(seedColor.toARGB32(), swatch);
  }
}

/// Accessibility compliance levels
enum AccessibilityLevel { fail, aa, aaa }

extension AccessibilityLevelExtension on AccessibilityLevel {
  String get name {
    switch (this) {
      case AccessibilityLevel.fail:
        return 'Fail';
      case AccessibilityLevel.aa:
        return 'WCAG AA';
      case AccessibilityLevel.aaa:
        return 'WCAG AAA';
    }
  }

  Color get indicatorColor {
    switch (this) {
      case AccessibilityLevel.fail:
        return Colors.red;
      case AccessibilityLevel.aa:
        return Colors.orange;
      case AccessibilityLevel.aaa:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case AccessibilityLevel.fail:
        return Icons.error;
      case AccessibilityLevel.aa:
        return Icons.warning;
      case AccessibilityLevel.aaa:
        return Icons.check_circle;
    }
  }
}

/// Report for theme accessibility validation
class ThemeAccessibilityReport {
  final List<String> warnings;
  final List<String> errors;
  final bool hasErrors;
  final bool hasWarnings;

  const ThemeAccessibilityReport({
    required this.warnings,
    required this.errors,
    required this.hasErrors,
    required this.hasWarnings,
  });

  bool get isCompliant => !hasErrors;

  int get totalIssues => warnings.length + errors.length;
}

/// Widget that shows accessibility information for color combinations
class AccessibilityIndicator extends StatelessWidget {
  final Color foreground;
  final Color background;
  final bool isLargeText;
  final bool showDetails;

  const AccessibilityIndicator({
    super.key,
    required this.foreground,
    required this.background,
    this.isLargeText = false,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = ColorAccessibility.getContrastRatio(foreground, background);
    final level = ColorAccessibility.getAccessibilityLevel(
      foreground,
      background,
      isLargeText: isLargeText,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: level.indicatorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: level.indicatorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(level.icon, size: 16, color: level.indicatorColor),
          const SizedBox(width: 4),
          Text(
            showDetails
                ? '${level.name} (${ratio.toStringAsFixed(1)}:1)'
                : level.name,
            style: TextStyle(
              fontSize: 12,
              color: level.indicatorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for testing color accessibility in real-time
class AccessibilityTester extends StatelessWidget {
  final Color foreground;
  final Color background;
  final String sampleText;

  const AccessibilityTester({
    super.key,
    required this.foreground,
    required this.background,
    this.sampleText = 'Sample Text',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sampleText,
            style: TextStyle(
              color: foreground,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sampleText,
            style: TextStyle(
              color: foreground,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AccessibilityIndicator(
                foreground: foreground,
                background: background,
                isLargeText: false,
                showDetails: true,
              ),
              const SizedBox(width: 8),
              AccessibilityIndicator(
                foreground: foreground,
                background: background,
                isLargeText: true,
                showDetails: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
