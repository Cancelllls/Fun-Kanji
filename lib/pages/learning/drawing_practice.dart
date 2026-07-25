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
  bool _showGuide = false;
  double _strokeWidth = 8.0;
  bool _compareMode = false;

  void _undoLastStroke() {
    if (strokes.isNotEmpty) {
      setState(() => strokes.removeLast());
    }
  }

  void _clearAll() {
    setState(() {
      strokes.clear();
      currentStroke.clear();
      _compareMode = false;
    });
  }

  void _toggleCompare() {
    setState(() => _compareMode = !_compareMode);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasStrokes = strokes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice: ${widget.kanji}'),
        actions: [
          IconButton(
            icon: Icon(_showGuide ? Icons.visibility : Icons.visibility_off),
            tooltip: _showGuide ? 'Hide guide strokes' : 'Show guide strokes',
            onPressed: () => setState(() => _showGuide = !_showGuide),
          ),
          IconButton(
            icon: const Icon(Icons.compare),
            tooltip: 'Compare with reference',
            onPressed: hasStrokes ? _toggleCompare : null,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo last stroke',
            onPressed: hasStrokes ? _undoLastStroke : null,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear drawing',
            onPressed: hasStrokes ? _clearAll : null,
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
      body: _compareMode
          ? _buildCompareView(scheme)
          : _buildDrawingView(scheme),
    );
  }

  Widget _buildDrawingView(ColorScheme scheme) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trace or draw the Kanji below:',
                    style: TextStyle(fontSize: 20, color: scheme.onSurface)),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      widget.kanji,
                      style: GoogleFonts.yujiSyuku(
                        textStyle: TextStyle(
                          fontSize: 250,
                          color: scheme.outlineVariant.withValues(
                            alpha: _showGuide ? 0.65 : 0.2,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onPanStart: (details) {
                        if (_compareMode) return;
                        setState(() {
                          currentStroke = [details.localPosition];
                          strokes.add(currentStroke);
                        });
                      },
                      onPanUpdate: (details) {
                        if (_compareMode) return;
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
    );
  }

  Widget _buildCompareView(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Your Drawing',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: StrokePainter(
                        strokes,
                        scheme,
                        strokeWidth: _strokeWidth,
                        showGrid: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Reference',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 16),
                  Text(
                    widget.kanji,
                    style: GoogleFonts.yujiSyuku(
                      textStyle: TextStyle(
                        fontSize: 180,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleCompare,
                icon: const Icon(Icons.edit),
                label: const Text('Keep Drawing'),
              ),
              ElevatedButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Redraw'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                ),
              ),
            ],
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
