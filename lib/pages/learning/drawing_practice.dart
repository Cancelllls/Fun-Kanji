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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice: ${widget.kanji}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear drawing',
            onPressed: () => setState(() {
              strokes.clear();
              currentStroke.clear();
            }),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trace or draw the Kanji below:',
                style: TextStyle(
                  fontSize: 20,
                  color: scheme.onSurface,
                )),
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
                    painter: StrokePainter(strokes, scheme),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final ColorScheme scheme;

  StrokePainter(this.strokes, this.scheme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = scheme.onSurface
      ..strokeWidth = 8.0
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
