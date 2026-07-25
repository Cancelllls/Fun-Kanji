import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawingPracticeScreen extends StatefulWidget {
  final String kanji;
  const DrawingPracticeScreen({super.key, required this.kanji});

  @override
  State<DrawingPracticeScreen> createState() => _DrawingPracticeScreenState();
}

class _DrawingPracticeScreenState extends State<DrawingPracticeScreen> {
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];
  bool _showGrid = false;
  double _strokeWidth = 8.0;

  void _undoLastStroke() {
    if (strokes.isNotEmpty) {
      setState(() => strokes.removeLast());
    }
  }

  void _clearAll() {
    setState(() {
      strokes.clear();
      currentStroke.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice: ${widget.kanji}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Undo',
            onPressed: strokes.isNotEmpty ? _undoLastStroke : null,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear drawing',
            onPressed: strokes.isNotEmpty ? _clearAll : null,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune),
            tooltip: 'Options',
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'grid',
                child: Row(
                  children: [
                    Icon(_showGrid ? Icons.grid_on : Icons.grid_off, size: 20),
                    const SizedBox(width: 8),
                    Text(_showGrid ? 'Hide grid' : 'Show grid'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'grid') setState(() => _showGrid = !_showGrid);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Trace or draw the Kanji below:',
                      style: TextStyle(
                          fontSize: 20, color: scheme.onSurface)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        widget.kanji,
                        style: GoogleFonts.yujiSyuku(
                          textStyle: TextStyle(
                            fontSize: 250,
                            color: scheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            currentStroke = [details.localPosition];
                            strokes.add(currentStroke);
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            currentStroke.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          currentStroke = [];
                        },
                        child: CustomPaint(
                          size: const Size(300, 300),
                          painter: StrokePainter(
                            strokes,
                            scheme,
                            strokeWidth: _strokeWidth,
                            showGrid: _showGrid,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
            child: Row(
              children: [
                const Text('Thin', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _strokeWidth,
                    min: 2,
                    max: 20,
                    divisions: 9,
                    label: '${_strokeWidth.round()}px',
                    onChanged: (v) => setState(() => _strokeWidth = v),
                  ),
                ),
                const Text('Thick', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final ColorScheme scheme;
  final double strokeWidth;
  final bool showGrid;

  StrokePainter(this.strokes, this.scheme,
      {this.strokeWidth = 8.0, this.showGrid = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final gridPaint = Paint()
        ..color = scheme.outlineVariant.withValues(alpha: 0.2)
        ..strokeWidth = 0.5;
      const step = 25.0;
      for (double x = 0; x <= size.width; x += step) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y <= size.height; y += step) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    final paint = Paint()
      ..color = scheme.onSurface
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
