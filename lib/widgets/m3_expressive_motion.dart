import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Android 17 Expressive Spring Pressable Widget.
/// Applies fluid physics-based spring scaling (scale 0.96 -> 1.0) on tap.
class M3SpringPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;

  const M3SpringPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.96,
  });

  @override
  State<M3SpringPressable> createState() => _M3SpringPressableState();
}

class _M3SpringPressableState extends State<M3SpringPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Android 17 Floating Glass Card with ambient color glow.
class M3FloatingCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glowColor;
  final double borderRadius;

  const M3FloatingCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.glowColor,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveGlow = glowColor ?? scheme.primary;

    final cardChild = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(
          alpha: isDark ? 0.85 : 0.75,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: isDark ? 0.4 : 0.6),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveGlow.withValues(alpha: isDark ? 0.12 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return M3SpringPressable(
        onTap: onTap,
        child: cardChild,
      );
    }
    return cardChild;
  }
}
