import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

/// Platform-specific design tokens for cross-platform consistency
class DesignTokens {
  /// Spacing tokens that adapt to platform conventions
  static EdgeInsets get padding {
    if (PlatformUtils.isIOS) {
      return const EdgeInsets.all(16.0); // iOS prefers 16pt spacing
    } else if (PlatformUtils.isAndroid) {
      return const EdgeInsets.all(16.0); // Material Design 16dp
    } else if (PlatformUtils.isDesktop) {
      return const EdgeInsets.all(20.0); // Desktop needs more breathing room
    } else {
      return const EdgeInsets.all(16.0); // Web responsive default
    }
  }

  /// Small padding for tight spaces
  static EdgeInsets get paddingSmall {
    if (PlatformUtils.isIOS) {
      return const EdgeInsets.all(8.0);
    } else if (PlatformUtils.isAndroid) {
      return const EdgeInsets.all(8.0);
    } else if (PlatformUtils.isDesktop) {
      return const EdgeInsets.all(12.0);
    } else {
      return const EdgeInsets.all(8.0);
    }
  }

  /// Large padding for major sections
  static EdgeInsets get paddingLarge {
    if (PlatformUtils.isIOS) {
      return const EdgeInsets.all(24.0);
    } else if (PlatformUtils.isAndroid) {
      return const EdgeInsets.all(24.0);
    } else if (PlatformUtils.isDesktop) {
      return const EdgeInsets.all(32.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  /// Border radius that follows platform conventions
  static BorderRadius get borderRadius {
    if (PlatformUtils.isIOS) {
      return BorderRadius.circular(10.0); // iOS rounded corners
    } else if (PlatformUtils.isAndroid) {
      return BorderRadius.circular(12.0); // Material 3 standard
    } else if (PlatformUtils.isDesktop) {
      return BorderRadius.circular(8.0); // Desktop subtle rounding
    } else {
      return BorderRadius.circular(12.0); // Web Material default
    }
  }

  /// Small border radius for buttons and chips
  static BorderRadius get borderRadiusSmall {
    if (PlatformUtils.isIOS) {
      return BorderRadius.circular(8.0);
    } else if (PlatformUtils.isAndroid) {
      return BorderRadius.circular(8.0);
    } else if (PlatformUtils.isDesktop) {
      return BorderRadius.circular(6.0);
    } else {
      return BorderRadius.circular(8.0);
    }
  }

  /// Large border radius for cards and containers
  static BorderRadius get borderRadiusLarge {
    if (PlatformUtils.isIOS) {
      return BorderRadius.circular(16.0);
    } else if (PlatformUtils.isAndroid) {
      return BorderRadius.circular(16.0);
    } else if (PlatformUtils.isDesktop) {
      return BorderRadius.circular(12.0);
    } else {
      return BorderRadius.circular(16.0);
    }
  }

  /// Elevation values that follow platform guidelines
  static double get elevationLow {
    if (PlatformUtils.isIOS) {
      return 1.0; // iOS subtle shadows
    } else if (PlatformUtils.isAndroid) {
      return 2.0; // Material Design elevation
    } else if (PlatformUtils.isDesktop) {
      return 3.0; // Desktop pronounced shadows
    } else {
      return 2.0; // Web standard
    }
  }

  static double get elevationMedium {
    if (PlatformUtils.isIOS) {
      return 4.0;
    } else if (PlatformUtils.isAndroid) {
      return 6.0;
    } else if (PlatformUtils.isDesktop) {
      return 8.0;
    } else {
      return 6.0;
    }
  }

  static double get elevationHigh {
    if (PlatformUtils.isIOS) {
      return 8.0;
    } else if (PlatformUtils.isAndroid) {
      return 12.0;
    } else if (PlatformUtils.isDesktop) {
      return 16.0;
    } else {
      return 12.0;
    }
  }

  /// Animation durations following platform conventions
  static Duration get animationFast {
    if (PlatformUtils.isIOS) {
      return const Duration(milliseconds: 200); // iOS quick animations
    } else if (PlatformUtils.isAndroid) {
      return const Duration(milliseconds: 150); // Material motion
    } else if (PlatformUtils.isDesktop) {
      return const Duration(milliseconds: 100); // Desktop responsive
    } else {
      return const Duration(milliseconds: 150); // Web standard
    }
  }

  static Duration get animationMedium {
    if (PlatformUtils.isIOS) {
      return const Duration(milliseconds: 300);
    } else if (PlatformUtils.isAndroid) {
      return const Duration(milliseconds: 250);
    } else if (PlatformUtils.isDesktop) {
      return const Duration(milliseconds: 200);
    } else {
      return const Duration(milliseconds: 250);
    }
  }

  static Duration get animationSlow {
    if (PlatformUtils.isIOS) {
      return const Duration(milliseconds: 500);
    } else if (PlatformUtils.isAndroid) {
      return const Duration(milliseconds: 400);
    } else if (PlatformUtils.isDesktop) {
      return const Duration(milliseconds: 300);
    } else {
      return const Duration(milliseconds: 400);
    }
  }

  /// Font size scale that adapts to platform
  static double get fontSizeSmall {
    if (PlatformUtils.isIOS) {
      return 12.0; // iOS text sizes
    } else if (PlatformUtils.isAndroid) {
      return 12.0; // Material Design scale
    } else if (PlatformUtils.isDesktop) {
      return 13.0; // Desktop readable sizes
    } else {
      return 12.0; // Web standard
    }
  }

  static double get fontSizeBody {
    if (PlatformUtils.isIOS) {
      return 16.0;
    } else if (PlatformUtils.isAndroid) {
      return 16.0;
    } else if (PlatformUtils.isDesktop) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  static double get fontSizeHeading {
    if (PlatformUtils.isIOS) {
      return 22.0;
    } else if (PlatformUtils.isAndroid) {
      return 22.0;
    } else if (PlatformUtils.isDesktop) {
      return 20.0;
    } else {
      return 22.0;
    }
  }

  /// Icon sizes that follow platform conventions
  static double get iconSizeSmall {
    if (PlatformUtils.isIOS) {
      return 16.0;
    } else if (PlatformUtils.isAndroid) {
      return 18.0;
    } else if (PlatformUtils.isDesktop) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  static double get iconSizeRegular {
    if (PlatformUtils.isIOS) {
      return 24.0;
    } else if (PlatformUtils.isAndroid) {
      return 24.0;
    } else if (PlatformUtils.isDesktop) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  static double get iconSizeLarge {
    if (PlatformUtils.isIOS) {
      return 32.0;
    } else if (PlatformUtils.isAndroid) {
      return 32.0;
    } else if (PlatformUtils.isDesktop) {
      return 28.0;
    } else {
      return 32.0;
    }
  }

  /// Input field heights that feel natural on each platform
  static double get inputHeight {
    if (PlatformUtils.isIOS) {
      return 44.0; // iOS touch target minimum
    } else if (PlatformUtils.isAndroid) {
      return 56.0; // Material Design minimum
    } else if (PlatformUtils.isDesktop) {
      return 40.0; // Desktop compact form
    } else {
      return 48.0; // Web accessible target
    }
  }

  /// Button heights that follow platform guidelines
  static double get buttonHeight {
    if (PlatformUtils.isIOS) {
      return 44.0; // iOS touch target
    } else if (PlatformUtils.isAndroid) {
      return 48.0; // Material touch target
    } else if (PlatformUtils.isDesktop) {
      return 36.0; // Desktop comfortable click
    } else {
      return 48.0; // Web accessible
    }
  }

  /// List item heights optimized per platform
  static double get listItemHeight {
    if (PlatformUtils.isIOS) {
      return 44.0; // iOS standard cell height
    } else if (PlatformUtils.isAndroid) {
      return 56.0; // Material list item height
    } else if (PlatformUtils.isDesktop) {
      return 40.0; // Desktop compact list
    } else {
      return 56.0; // Web Material standard
    }
  }

  /// App bar heights following platform conventions
  static double get appBarHeight {
    if (PlatformUtils.isIOS) {
      return 44.0; // iOS navigation bar height
    } else if (PlatformUtils.isAndroid) {
      return 56.0; // Material app bar height
    } else if (PlatformUtils.isDesktop) {
      return 48.0; // Desktop title bar height
    } else {
      return 56.0; // Web Material standard
    }
  }
}
