import 'package:flutter/material.dart';

class M3TiltCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const M3TiltCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  State<M3TiltCard> createState() => _M3TiltCardState();
}

class _M3TiltCardState extends State<M3TiltCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  void _onPointerMove(PointerEvent event, Size cardSize) {
    if (cardSize.width == 0 || cardSize.height == 0) return;
    final px = event.localPosition.dx / cardSize.width - 0.5;
    final py = event.localPosition.dy / cardSize.height - 0.5;

    setState(() {
      _rotateX = -py * 0.25; // max 15 deg tilt
      _rotateY = px * 0.25;
    });
  }

  void _onPointerUp(PointerEvent event) {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return Listener(
            onPointerMove: (e) => _onPointerMove(e, size),
            onPointerUp: _onPointerUp,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(_rotateX)
                  ..rotateY(_rotateY),
                transformAlignment: FractionalOffset.center,
                padding: widget.padding ?? const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: Offset(_rotateY * 20, _rotateX * 20 + 4),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
