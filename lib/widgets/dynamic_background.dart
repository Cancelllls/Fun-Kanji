import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';

class DynamicGradientBackground extends StatefulWidget {
  final Widget child;
  const DynamicGradientBackground({super.key, required this.child});

  @override
  State<DynamicGradientBackground> createState() =>
      _DynamicGradientBackgroundState();
}

class _DynamicGradientBackgroundState extends State<DynamicGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1Dark;
  late Animation<Color?> _color2Dark;
  late Animation<Color?> _color3Dark;
  late Animation<Color?> _color1Light;
  late Animation<Color?> _color2Light;
  late Animation<Color?> _color3Light;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _color1Dark = ColorTween(
      begin: AppColors.gradientDarkStart,
      end: AppColors.gradientDarkMid,
    ).animate(_controller);
    _color2Dark = ColorTween(
      begin: AppColors.gradientDarkMid,
      end: AppColors.gradientDarkEnd,
    ).animate(_controller);
    _color3Dark = ColorTween(
      begin: AppColors.gradientDarkEnd,
      end: AppColors.gradientDarkStart,
    ).animate(_controller);

    _color1Light = ColorTween(
      begin: AppColors.gradientLightStart,
      end: AppColors.gradientLightMid,
    ).animate(_controller);
    _color2Light = ColorTween(
      begin: AppColors.gradientLightMid,
      end: AppColors.gradientLightEnd,
    ).animate(_controller);
    _color3Light = ColorTween(
      begin: AppColors.gradientLightEnd,
      end: AppColors.gradientLightStart,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      _color1Dark.value ?? AppColors.gradientDarkStart,
                      _color2Dark.value ?? AppColors.gradientDarkMid,
                      _color3Dark.value ?? AppColors.gradientDarkEnd,
                    ]
                  : [
                      _color1Light.value ?? AppColors.gradientLightStart,
                      _color2Light.value ?? AppColors.gradientLightMid,
                      _color3Light.value ?? AppColors.gradientLightEnd,
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
