import 'package:flutter/services.dart';

class HapticEngine {
  static void light() {
    HapticFeedback.selectionClick();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void success() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.heavyImpact();
  }

  static void error() {
    HapticFeedback.vibrate();
  }
}
