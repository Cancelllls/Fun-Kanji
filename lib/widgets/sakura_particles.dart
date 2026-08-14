import 'dart:math' as math;
import 'package:flutter/material.dart';

class SakuraPetal {
  double x;
  double y;
  double size;
  double speed;
  double swing;
  double swingSpeed;
  double opacity;

  SakuraPetal({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.swing,
    required this.swingSpeed,
    required this.opacity,
  });
}

class SakuraParticlesOverlay extends StatefulWidget {
  final Widget child;
  final int numberOfPetals;

  const SakuraParticlesOverlay({
    super.key,
    required this.child,
    this.numberOfPetals = 20,
  });

  @override
  State<SakuraParticlesOverlay> createState() => _SakuraParticlesOverlayState();
}

class _SakuraParticlesOverlayState extends State<SakuraParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<SakuraPetal> _petals;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _petals = List.generate(widget.numberOfPetals, (_) => _createRandomPetal());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (var p in _petals) {
          p.y += p.speed;
          p.x += math.sin(p.y * p.swingSpeed) * p.swing;

          if (p.y > 1.2) {
            p.y = -0.1;
            p.x = _random.nextDouble();
          }
        }
      });
    });
  }

  SakuraPetal _createRandomPetal() {
    return SakuraPetal(
      x: _random.nextDouble(),
      y: _random.nextDouble() * 1.2 - 0.1,
      size: _random.nextDouble() * 8 + 6,
      speed: _random.nextDouble() * 0.002 + 0.001,
      swing: _random.nextDouble() * 0.003 + 0.001,
      swingSpeed: _random.nextDouble() * 2 + 1,
      opacity: _random.nextDouble() * 0.5 + 0.3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: _SakuraPainter(petals: _petals),
          ),
        ),
      ],
    );
  }
}

class _SakuraPainter extends CustomPainter {
  final List<SakuraPetal> petals;

  _SakuraPainter({required this.petals});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (var p in petals) {
      paint.color = const Color(0xFFF472B6).withValues(alpha: p.opacity);
      final dx = p.x * size.width;
      final dy = p.y * size.height;

      final Path path = Path();
      path.moveTo(dx, dy);
      path.quadraticBezierTo(dx + p.size, dy - p.size, dx + p.size * 1.5, dy);
      path.quadraticBezierTo(dx + p.size, dy + p.size, dx, dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SakuraPainter oldDelegate) => true;
}
