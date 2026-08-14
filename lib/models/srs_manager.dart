import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SrsItem {
  final String kanji;
  final int stage; // 0=Apprentice, 1=Guru, 2=Master, 3=Enlightened, 4=Burned
  final DateTime nextReview;
  final int streak;

  SrsItem({
    required this.kanji,
    this.stage = 0,
    required this.nextReview,
    this.streak = 0,
  });

  factory SrsItem.fromJson(Map<String, dynamic> json) {
    return SrsItem(
      kanji: json['kanji'],
      stage: json['stage'] ?? 0,
      nextReview: DateTime.parse(json['nextReview']),
      streak: json['streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kanji': kanji,
      'stage': stage,
      'nextReview': nextReview.toIso8601String(),
      'streak': streak,
    };
  }

  String get stageName {
    switch (stage) {
      case 0:
        return 'Apprentice';
      case 1:
        return 'Guru';
      case 2:
        return 'Master';
      case 3:
        return 'Enlightened';
      case 4:
        return 'Burned';
      default:
        return 'Apprentice';
    }
  }
}

class SrsManager {
  static const String _srsKey = 'srs_items_data';

  static Future<List<SrsItem>> getAllItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_srsKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => SrsItem.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAllItems(List<SrsItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_srsKey, encoded);
  }

  static Future<List<SrsItem>> getDueReviews() async {
    final items = await getAllItems();
    final now = DateTime.now();
    return items.where((item) => item.nextReview.isBefore(now)).toList();
  }

  static Future<void> recordReviewResult(String kanji, bool isCorrect) async {
    final items = await getAllItems();
    final index = items.indexWhere((i) => i.kanji == kanji);
    final now = DateTime.now();

    if (index == -1) {
      // New item added to SRS
      final newStage = isCorrect ? 1 : 0;
      final hoursToAdd = isCorrect ? 8 : 4;
      items.add(SrsItem(
        kanji: kanji,
        stage: newStage,
        nextReview: now.add(Duration(hours: hoursToAdd)),
        streak: isCorrect ? 1 : 0,
      ));
    } else {
      final item = items[index];
      int nextStage = item.stage;
      int nextStreak = item.streak;

      if (isCorrect) {
        nextStreak++;
        if (nextStage < 4) nextStage++;
      } else {
        nextStreak = 0;
        if (nextStage > 0) nextStage--;
      }

      int delayHours;
      switch (nextStage) {
        case 0:
          delayHours = 4;
          break;
        case 1:
          delayHours = 24;
          break;
        case 2:
          delayHours = 72;
          break;
        case 3:
          delayHours = 168;
          break;
        case 4:
          delayHours = 720;
          break;
        default:
          delayHours = 24;
      }

      items[index] = SrsItem(
        kanji: kanji,
        stage: nextStage,
        nextReview: now.add(Duration(hours: delayHours)),
        streak: nextStreak,
      );
    }

    await saveAllItems(items);
  }

  static Future<Map<String, int>> getStageCounts() async {
    final items = await getAllItems();
    final Map<String, int> counts = {
      'Apprentice': 0,
      'Guru': 0,
      'Master': 0,
      'Enlightened': 0,
      'Burned': 0,
    };

    for (var item in items) {
      counts[item.stageName] = (counts[item.stageName] ?? 0) + 1;
    }
    return counts;
  }
}
