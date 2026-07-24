import 'package:flutter/material.dart';

class DynamicGradientBackground extends StatefulWidget {
  final Widget child;
  const DynamicGradientBackground({super.key, required this.child});

  @override
  State<DynamicGradientBackground> createState() => _DynamicGradientBackgroundState();
}

class _DynamicGradientBackgroundState extends State<DynamicGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1Dark;
  late Animation<Color?> _color2Dark;
  late Animation<Color?> _color1Light;
  late Animation<Color?> _color2Light;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    
    _color1Dark = ColorTween(begin: Colors.purple.shade900, end: Colors.deepPurple.shade900).animate(_controller);
    _color2Dark = ColorTween(begin: Colors.indigo.shade900, end: Colors.blue.shade900).animate(_controller);
    
    _color1Light = ColorTween(begin: Colors.purple.shade50, end: Colors.deepPurple.shade100).animate(_controller);
    _color2Light = ColorTween(begin: Colors.indigo.shade50, end: Colors.blue.shade100).animate(_controller);
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
              colors: [
                isDark ? (_color1Dark.value ?? Colors.purple) : (_color1Light.value ?? Colors.purple.shade50),
                isDark ? (_color2Dark.value ?? Colors.blue) : (_color2Light.value ?? Colors.indigo.shade50),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
