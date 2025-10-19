import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

/// Responsive layout system that adapts to different screen sizes
class ResponsiveLayout {
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Determines if current screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Determines if current screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Determines if current screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Gets the appropriate column count for a grid layout
  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 4; // Desktop can show more items
    } else if (isTablet(context)) {
      return 3; // Tablet moderate density
    } else {
      return 2; // Mobile minimal columns
    }
  }

  /// Gets responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32.0); // Desktop generous spacing
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0); // Tablet moderate spacing
    } else {
      return const EdgeInsets.all(16.0); // Mobile compact spacing
    }
  }

  /// Gets responsive margin for content containers
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    }
  }

  /// Gets the maximum content width for centered layouts
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200.0; // Desktop max width for readability
    } else if (isTablet(context)) {
      return 800.0; // Tablet comfortable reading width
    } else {
      return double.infinity; // Mobile uses full width
    }
  }

  /// Creates a responsive container with appropriate constraints
  static Widget responsiveContainer({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: getMaxContentWidth(context)),
      padding: padding ?? getResponsivePadding(context),
      margin: margin ?? getResponsiveMargin(context),
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor)
          : null,
      child: child,
    );
  }

  /// Creates responsive columns layout
  static Widget responsiveColumns({
    required BuildContext context,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double spacing = 16.0,
  }) {
    if (isMobile(context)) {
      // Mobile: Stack vertically
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [child, SizedBox(height: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    } else {
      // Tablet/Desktop: Side by side
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand(
              (child) => [
                Expanded(child: child),
                if (child != children.last) SizedBox(width: spacing),
              ],
            )
            .take(children.length * 2 - 1)
            .toList(),
      );
    }
  }

  /// Creates responsive grid with appropriate column count
  static Widget responsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0,
    double aspectRatio = 1.0,
  }) {
    final columns = getGridColumns(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  /// Creates responsive sidebar layout for larger screens
  static Widget responsiveSidebar({
    required BuildContext context,
    required Widget sidebar,
    required Widget content,
    double sidebarWidth = 280.0,
    double spacing = 16.0,
  }) {
    if (isMobile(context)) {
      // Mobile: No sidebar, content only
      return content;
    } else if (isTablet(context) && PlatformUtils.isLandscape(context)) {
      // Tablet landscape: Show sidebar
      return Row(
        children: [
          SizedBox(
            width: sidebarWidth * 0.8, // Slightly narrower on tablet
            child: sidebar,
          ),
          SizedBox(width: spacing),
          Expanded(child: content),
        ],
      );
    } else if (isDesktop(context)) {
      // Desktop: Full sidebar
      return Row(
        children: [
          SizedBox(width: sidebarWidth, child: sidebar),
          SizedBox(width: spacing),
          Expanded(child: content),
        ],
      );
    } else {
      // Tablet portrait: Content only
      return content;
    }
  }

  /// Creates responsive navigation layout
  static Widget responsiveNavigation({
    required BuildContext context,
    required Widget body,
    required List<NavigationItem> navigationItems,
    int currentIndex = 0,
    ValueChanged<int>? onDestinationSelected,
  }) {
    if (isMobile(context)) {
      // Mobile: Bottom navigation
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: navigationItems
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon ?? item.icon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      );
    } else {
      // Tablet/Desktop: Side navigation rail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              extended: isDesktop(context), // Extend labels on desktop
              destinations: navigationItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
  }

  /// Gets responsive font size based on screen size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Creates responsive dialog/modal layout
  static Future<T?> showResponsiveDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    if (isMobile(context)) {
      // Mobile: Full screen modal
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        ),
      );
    } else {
      // Tablet/Desktop: Traditional dialog
      return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet(context) ? 600 : 800,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: child,
          ),
        ),
      );
    }
  }
}

/// Navigation item data class
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}
