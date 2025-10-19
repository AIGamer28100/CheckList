import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';
import 'design_tokens.dart';

/// Adaptive components that render appropriate widgets per platform
class AdaptiveComponents {
  /// Adaptive button that uses platform-specific styling
  static Widget adaptiveButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isDestructive = false,
    IconData? icon,
    Color? customColor,
  }) {
    if (PlatformUtils.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: isDestructive
            ? CupertinoColors.destructiveRed
            : isPrimary
            ? customColor ?? CupertinoColors.activeBlue
            : null,
        borderRadius: DesignTokens.borderRadius,
        padding: DesignTokens.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: DesignTokens.iconSizeSmall),
              const SizedBox(width: 8),
            ],
            Text(text),
          ],
        ),
      );
    } else {
      // Material Design for Android, Desktop, and Web
      if (isPrimary) {
        return FilledButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, size: DesignTokens.iconSizeSmall)
              : const SizedBox.shrink(),
          label: Text(text),
          style: FilledButton.styleFrom(
            backgroundColor: isDestructive ? Colors.red : customColor,
            minimumSize: Size.fromHeight(DesignTokens.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: DesignTokens.borderRadius,
            ),
          ),
        );
      } else {
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, size: DesignTokens.iconSizeSmall)
              : const SizedBox.shrink(),
          label: Text(text),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDestructive ? Colors.red : null,
            side: BorderSide(
              color: isDestructive ? Colors.red : customColor ?? Colors.grey,
            ),
            minimumSize: Size.fromHeight(DesignTokens.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: DesignTokens.borderRadius,
            ),
          ),
        );
      }
    }
  }

  /// Adaptive card that follows platform design guidelines
  static Widget adaptiveCard({
    required Widget child,
    EdgeInsets? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final cardPadding = padding ?? DesignTokens.padding;
    final cardElevation = elevation ?? DesignTokens.elevationLow;

    if (PlatformUtils.isIOS) {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: DesignTokens.borderRadiusLarge,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.separator.withValues(alpha: 0.3),
              blurRadius: cardElevation,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: DesignTokens.borderRadiusLarge,
            child: Padding(padding: cardPadding, child: child),
          ),
        ),
      );
    } else {
      return Card(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: DesignTokens.borderRadiusLarge,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.borderRadiusLarge,
          child: Padding(padding: cardPadding, child: child),
        ),
      );
    }
  }

  /// Adaptive text field that feels native on each platform
  static Widget adaptiveTextField({
    required String placeholder,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? errorText,
    Widget? suffix,
    int maxLines = 1,
  }) {
    if (PlatformUtils.isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            controller: controller,
            onChanged: onChanged,
            placeholder: placeholder,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            suffix: suffix,
            padding: DesignTokens.padding,
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill,
              borderRadius: DesignTokens.borderRadius,
              border: errorText != null
                  ? Border.all(color: CupertinoColors.destructiveRed)
                  : null,
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText,
              style: TextStyle(
                color: CupertinoColors.destructiveRed,
                fontSize: DesignTokens.fontSizeSmall,
              ),
            ),
          ],
        ],
      );
    } else {
      return TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: placeholder,
          errorText: errorText,
          suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: DesignTokens.borderRadius),
          contentPadding: DesignTokens.padding,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
      );
    }
  }

  /// Adaptive list tile that follows platform conventions
  static Widget adaptiveListTile({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool showChevron = false,
  }) {
    if (PlatformUtils.isIOS) {
      return Container(
        height: DesignTokens.listItemHeight,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: const Border(
            bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: DesignTokens.padding,
              child: Row(
                children: [
                  if (leading != null) ...[leading, const SizedBox(width: 12)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeBody,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSmall,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing,
                  ] else if (showChevron) ...[
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: DesignTokens.iconSizeSmall,
                      color: CupertinoColors.tertiaryLabel,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        leading: leading,
        trailing:
            trailing ?? (showChevron ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
        contentPadding: DesignTokens.padding,
        minVerticalPadding: 0,
      );
    }
  }

  /// Adaptive switch that uses platform-specific styling
  static Widget adaptiveSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
  }) {
    if (PlatformUtils.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor ?? CupertinoColors.activeBlue,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor,
      );
    }
  }

  /// Adaptive checkbox for selection states
  static Widget adaptiveCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    Color? activeColor,
  }) {
    if (PlatformUtils.isIOS) {
      return GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value
                ? (activeColor ?? CupertinoColors.activeBlue)
                : CupertinoColors.tertiarySystemFill,
            border: !value
                ? Border.all(color: CupertinoColors.separator)
                : null,
          ),
          child: value
              ? const Icon(
                  CupertinoIcons.check_mark,
                  size: 14,
                  color: CupertinoColors.white,
                )
              : null,
        ),
      );
    } else {
      return Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );
    }
  }

  /// Adaptive progress indicator
  static Widget adaptiveProgressIndicator({double? value, Color? color}) {
    if (PlatformUtils.isIOS) {
      return CupertinoActivityIndicator(
        color: color ?? CupertinoColors.activeBlue,
      );
    } else {
      return CircularProgressIndicator(value: value, color: color);
    }
  }

  /// Adaptive app bar that follows platform conventions
  static PreferredSizeWidget adaptiveAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
  }) {
    if (PlatformUtils.isIOS) {
      return CupertinoNavigationBar(
        middle: Text(title),
        trailing: actions != null && actions.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: actions)
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
      );
    } else {
      return AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
        elevation: DesignTokens.elevationLow,
      );
    }
  }
}
