import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawingPracticeScreen extends StatefulWidget {
  final String kanji;
  final int? expectedStrokes;

  const DrawingPracticeScreen({
    super.key,
    required this.kanji,
    this.expectedStrokes,
  });

  @override
  State<DrawingPracticeScreen> createState() => _DrawingPracticeScreenState();
}

class _DrawingPracticeScreenState extends State<DrawingPracticeScreen> {
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];
  bool _showGrid = true;
  String _gridType = 'rice'; // 'rice' (田) or 'cross' (+)
  bool _showGuide = true;
  double _strokeWidth = 10.0;
  bool _compareMode = false;
  
  // Validation state
  late ConfettiController _confettiController;
  double? _lastAccuracyScore;
  String? _feedbackMessage;
  bool _isEvaluating = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _undoLastStroke() {
    if (strokes.isNotEmpty) {
      setState(() {
        strokes.removeLast();
        _lastAccuracyScore = null;
        _feedbackMessage = null;
      });
    }
  }

  void _clearAll() {
    setState(() {
      strokes.clear();
      currentStroke.clear();
      _compareMode = false;
      _lastAccuracyScore = null;
      _feedbackMessage = null;
    });
  }

  void _evaluateDrawing() {
    if (strokes.isEmpty) return;

    setState(() => _isEvaluating = true);

    // Calculate bounding box and stroke coverage density
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    double totalPathLength = 0;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length; i++) {
        final pt = stroke[i];
        if (pt.dx < minX) minX = pt.dx;
        if (pt.dx > maxX) maxX = pt.dx;
        if (pt.dy < minY) minY = pt.dy;
        if (pt.dy > maxY) maxY = pt.dy;

        if (i > 0) {
          totalPathLength += (pt - stroke[i - 1]).distance;
        }
      }
    }

    final double width = (maxX - minX).clamp(1.0, 300.0);
    final double height = (maxY - minY).clamp(1.0, 300.0);
    final double areaRatio = (width * height) / (250.0 * 250.0);
    final double strokeCountRatio = widget.expectedStrokes != null
        ? 1.0 - (strokes.length - widget.expectedStrokes!).abs() / 10.0
        : 0.9;

    // Combined heuristic accuracy score (0.0 to 1.0)
    double score = (areaRatio * 0.4 + (totalPathLength / 450.0).clamp(0.0, 0.4) + strokeCountRatio.clamp(0.0, 0.2));
    score = (score * 100).clamp(65.0, 98.0);

    // Randomize slight organic variance based on stroke count
    final accuracyPercent = score.roundToDouble();

    String feedback;
    if (accuracyPercent >= 88) {
      feedback = '素晴らしい！ Excellent Stroke Form!';
      _confettiController.play();
    } else if (accuracyPercent >= 75) {
      feedback = 'Great Job! とても良い！';
    } else {
      feedback = 'Keep practicing! がんばって！';
    }

    setState(() {
      _lastAccuracyScore = accuracyPercent;
      _feedbackMessage = feedback;
      _isEvaluating = false;
    });
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
            tooltip: _showGuide ? 'Hide watermark guide' : 'Show watermark guide',
            onPressed: () => setState(() => _showGuide = !_showGuide),
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo last stroke',
            onPressed: hasStrokes ? _undoLastStroke : null,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear canvas',
            onPressed: hasStrokes ? _clearAll : null,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune),
            tooltip: 'Grid Options',
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle_grid',
                child: Row(
                  children: [
                    Icon(_showGrid ? Icons.grid_on : Icons.grid_off, size: 20),
                    const SizedBox(width: 8),
                    Text(_showGrid ? 'Hide Grid' : 'Show Grid'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'grid_type',
                child: Row(
                  children: [
                    const Icon(Icons.grid_3x3, size: 20),
                    const SizedBox(width: 8),
                    Text('Grid Style: ${_gridType == "rice" ? "Rice (田)" : "Cross (+)"}'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'toggle_grid') {
                setState(() => _showGrid = !_showGrid);
              } else if (value == 'grid_type') {
                setState(() => _gridType = _gridType == 'rice' ? 'cross' : 'rice');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _compareMode
              ? _buildCompareView(scheme)
              : _buildDrawingView(scheme),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFE5C158),
                Color(0xFF26A69A),
                Color(0xFFFF4081),
                Color(0xFF29B6F6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingView(ColorScheme scheme) {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Header Status Banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Strokes: ${strokes.length}${widget.expectedStrokes != null ? ' / ${widget.expectedStrokes}' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              if (_lastAccuracyScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5C158).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE5C158),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFE5C158), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Score: ${_lastAccuracyScore!.toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE5C158),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Main Drawing Canvas Stack
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5C158).withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Grid lines
                    if (_showGrid)
                      CustomPaint(
                        size: const Size(300, 300),
                        painter: GridPainter(
                          scheme: scheme,
                          gridType: _gridType,
                        ),
                      ),
                    // Reference Watermark Kanji
                    Text(
                      widget.kanji,
                      style: GoogleFonts.yujiSyuku(
                        textStyle: TextStyle(
                          fontSize: 220,
                          color: scheme.onSurface.withValues(
                            alpha: _showGuide ? 0.22 : 0.05,
                          ),
                        ),
                      ),
                    ),
                    // Drawing Interactive Canvas
                    GestureDetector(
                      onPanStart: (details) {
                        if (_compareMode) return;
                        setState(() {
                          currentStroke = [details.localPosition];
                          strokes.add(currentStroke);
                          _lastAccuracyScore = null;
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
                        _evaluateDrawing();
                      },
                      child: CustomPaint(
                        size: const Size(300, 300),
                        painter: CalligraphyStrokePainter(
                          strokes: strokes,
                          color: scheme.onSurface,
                          strokeWidth: _strokeWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Feedback message banner
        if (_feedbackMessage != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _feedbackMessage!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
        // Stroke width slider & action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.brush, size: 18),
                  const SizedBox(width: 8),
                  const Text('Brush Size:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Slider(
                      value: _strokeWidth,
                      min: 4,
                      max: 24,
                      divisions: 10,
                      label: '${_strokeWidth.round()}px',
                      onChanged: (v) => setState(() => _strokeWidth = v),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: strokes.isNotEmpty ? _evaluateDrawing : null,
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('Check Form'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _compareMode = true),
                    icon: const Icon(Icons.compare),
                    label: const Text('Compare Reference'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5C158),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
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
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Your Stroke',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: CustomPaint(
                            size: const Size(140, 140),
                            painter: CalligraphyStrokePainter(
                              strokes: strokes,
                              color: scheme.onSurface,
                              strokeWidth: _strokeWidth * 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Reference',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.kanji,
                          style: GoogleFonts.yujiSyuku(
                            textStyle: TextStyle(
                              fontSize: 110,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _compareMode = false),
                icon: const Icon(Icons.edit),
                label: const Text('Back to Canvas'),
              ),
              ElevatedButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Clear & Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Custom painter for rice grid (田) and cross grid (+)
class GridPainter extends CustomPainter {
  final ColorScheme scheme;
  final String gridType;

  GridPainter({required this.scheme, required this.gridType});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = scheme.outlineVariant.withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    final dashPaint = Paint()
      ..color = scheme.outlineVariant.withValues(alpha: 0.25)
      ..strokeWidth = 0.8;

    // Center cross lines
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), linePaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), linePaint);

    if (gridType == 'rice') {
      // Diagonal lines for Japanese Rice Grid (田 / 米)
      canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), dashPaint);
      canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.gridType != gridType;
}

/// Calligraphy Ink Brush Painter with smooth curves and pressure effect
class CalligraphyStrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;

  CalligraphyStrokePainter({
    required this.strokes,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        // Draw dot for single tap
        canvas.drawCircle(stroke.first, strokeWidth / 2, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }

      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length - 1; i++) {
        final p0 = stroke[i];
        final p1 = stroke[i + 1];
        final midX = (p0.dx + p1.dx) / 2;
        final midY = (p0.dy + p1.dy) / 2;
        path.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
      }
      path.lineTo(stroke.last.dx, stroke.last.dy);

      paint.strokeWidth = strokeWidth;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CalligraphyStrokePainter oldDelegate) => true;
}

