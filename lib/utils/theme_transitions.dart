import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

/// Manages smooth transitions between theme changes
class ThemeTransitionManager {
  static const Duration _defaultDuration = Duration(milliseconds: 300);
  static const Curve _defaultCurve = Curves.easeInOut;

  /// Create an animated theme transition widget
  static Widget createTransition({
    required Widget child,
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    return _ThemeTransitionWidget(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animate a specific widget during theme transition
  static Widget animateWidget({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedTheme(
      duration: duration ?? _defaultDuration,
      curve: curve ?? _defaultCurve,
      data: Theme.of(child as BuildContext),
      child: child,
    );
  }
}

class _ThemeTransitionWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _ThemeTransitionWidget({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_ThemeTransitionWidget> createState() => _ThemeTransitionWidgetState();
}

class _ThemeTransitionWidgetState extends State<_ThemeTransitionWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ThemeData? _previousTheme;
  ThemeData? _currentTheme;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newTheme = Theme.of(context);

    if (_currentTheme != null && _currentTheme != newTheme) {
      _previousTheme = _currentTheme;
      _currentTheme = newTheme;
      _controller.forward(from: 0);
    } else {
      _currentTheme = newTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_previousTheme == null) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Theme(
          data: ThemeData.lerp(
            _previousTheme!,
            _currentTheme!,
            _animation.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Custom page transition that respects theme changes
class ThemeAwarePageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (PlatformUtils.isIOS) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    } else {
      return FadeUpwardsPageTransitionsBuilder().buildTransitions(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
  }
}

/// Widget that provides smooth color transitions during theme changes
class AnimatedThemeColor extends StatelessWidget {
  final Color Function(ThemeData theme) colorSelector;
  final Widget Function(BuildContext context, Color color) builder;
  final Duration duration;
  final Curve curve;

  const AnimatedThemeColor({
    super.key,
    required this.colorSelector,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorSelector(Theme.of(context));

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: duration,
      curve: curve,
      builder: (context, animatedColor, child) {
        return builder(context, animatedColor ?? color);
      },
    );
  }
}

/// Extension to add theme-aware animations to any widget
extension ThemeAwareAnimations on Widget {
  /// Wrap widget with theme transition animation
  Widget withThemeTransition({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return ThemeTransitionManager.createTransition(
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  /// Animate background color changes with theme
  Widget animateBackgroundColor({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedThemeColor(
      duration: duration,
      curve: curve,
      colorSelector: (theme) => theme.scaffoldBackgroundColor,
      builder: (context, color) {
        return AnimatedContainer(
          duration: duration,
          curve: curve,
          color: color,
          child: this,
        );
      },
    );
  }

  /// Animate text color changes with theme
  Widget animateTextColor({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedThemeColor(
      duration: duration,
      curve: curve,
      colorSelector: (theme) => theme.colorScheme.onSurface,
      builder: (context, color) {
        return AnimatedDefaultTextStyle(
          duration: duration,
          curve: curve,
          style: DefaultTextStyle.of(context).style.copyWith(color: color),
          child: this,
        );
      },
    );
  }
}

/// Staggered animation for multiple elements during theme transition
class StaggeredThemeTransition extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;

  const StaggeredThemeTransition({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 600),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  @override
  State<StaggeredThemeTransition> createState() =>
      _StaggeredThemeTransitionState();
}

class _StaggeredThemeTransitionState extends State<StaggeredThemeTransition>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(duration: widget.duration, vsync: this),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: widget.curve);
    }).toList();

    // Start staggered animations
    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(StaggeredThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      // Reset and reinitialize if children count changed
      for (final controller in _controllers) {
        controller.dispose();
      }
      _initializeAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _animations[index].value)),
              child: Opacity(
                opacity: _animations[index].value,
                child: widget.children[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Hero-style transition for theme elements
class ThemeHeroTransition extends StatelessWidget {
  final String tag;
  final Widget child;
  final Duration duration;

  const ThemeHeroTransition({
    super.key,
    required this.tag,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$tag-${Theme.of(context).brightness}',
      transitionOnUserGestures: true,
      child: Material(color: Colors.transparent, child: child),
    );
  }
}

/// Ripple effect transition for theme changes
class ThemeRippleTransition extends StatefulWidget {
  final Widget child;
  final Offset? center;
  final Duration duration;

  const ThemeRippleTransition({
    super.key,
    required this.child,
    this.center,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ThemeRippleTransition> createState() => _ThemeRippleTransitionState();
}

class _ThemeRippleTransitionState extends State<ThemeRippleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ThemeData? _previousTheme;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentTheme = Theme.of(context);

    if (_previousTheme != null && _previousTheme != currentTheme) {
      _controller.forward(from: 0);
    }
    _previousTheme = currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _RipplePainter(
            progress: _animation.value,
            center: widget.center ?? const Offset(0.5, 0.5),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  _RipplePainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.3 * (1 - progress))
      ..style = PaintingStyle.fill;

    final centerPoint = Offset(size.width * center.dx, size.height * center.dy);

    final maxRadius =
        (size.width > size.height ? size.width : size.height) * 1.5;
    final currentRadius = maxRadius * progress;

    canvas.drawCircle(centerPoint, currentRadius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.color != color;
  }
}
