import 'dart:ui';

class StrokeEvaluationResult {
  final double score; // 0.0 to 100.0
  final int detectedStrokes;
  final int expectedStrokes;
  final bool isSequenceValid;
  final String feedbackMessage;

  StrokeEvaluationResult({
    required this.score,
    required this.detectedStrokes,
    required this.expectedStrokes,
    required this.isSequenceValid,
    required this.feedbackMessage,
  });
}

class StrokeSequenceEvaluator {
  static StrokeEvaluationResult evaluate({
    required List<List<Offset>> strokes,
    required int? expectedStrokes,
  }) {
    final int detected = strokes.length;
    final int expected = expectedStrokes ?? detected;

    if (detected == 0) {
      return StrokeEvaluationResult(
        score: 0.0,
        detectedStrokes: 0,
        expectedStrokes: expected,
        isSequenceValid: false,
        feedbackMessage: 'Draw Kanji strokes on canvas',
      );
    }

    // 1. Stroke Count Ratio Score (30%)
    final double countDiff = (detected - expected).abs().toDouble();
    final double countScore = (1.0 - (countDiff / 5.0)).clamp(0.0, 1.0) * 30.0;

    // 2. Bounding Box Fill Ratio Score (40%)
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    double totalDistance = 0;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length; i++) {
        final pt = stroke[i];
        if (pt.dx < minX) minX = pt.dx;
        if (pt.dx > maxX) maxX = pt.dx;
        if (pt.dy < minY) minY = pt.dy;
        if (pt.dy > maxY) maxY = pt.dy;

        if (i > 0) {
          totalDistance += (pt - stroke[i - 1]).distance;
        }
      }
    }

    final double width = (maxX - minX).clamp(1.0, 300.0);
    final double height = (maxY - minY).clamp(1.0, 300.0);
    final double coverageArea = (width * height) / (250.0 * 250.0);
    final double coverageScore = coverageArea.clamp(0.0, 1.0) * 40.0;

    // 3. Stroke Flow & Sequence Smoothness Score (30%)
    final double flowScore = (totalDistance / 400.0).clamp(0.0, 1.0) * 30.0;

    final double totalScore = (countScore + coverageScore + flowScore).clamp(0.0, 100.0);
    final bool isSequenceValid = countDiff == 0;

    String feedback;
    if (totalScore >= 85) {
      feedback = '✨ Outstanding Calligraphy Precision!';
    } else if (totalScore >= 65) {
      feedback = '👍 Good Stroke Structure!';
    } else {
      feedback = '✍️ Check stroke order and bounding box alignment';
    }

    return StrokeEvaluationResult(
      score: totalScore,
      detectedStrokes: detected,
      expectedStrokes: expected,
      isSequenceValid: isSequenceValid,
      feedbackMessage: feedback,
    );
  }
}
