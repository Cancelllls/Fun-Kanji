
import 'package:isar/isar.dart';

import 'package:fun_with_kanji/utils/writing_system.dart';

part 'learning_progress.g.dart';

@Collection()
class LearningProgress {
  Id id = Isar.autoIncrement;

  String writingSystem = WritingSystem.hiragana.name;
  int characterId = 0;
  int stars = 0;
  DateTime? lastCheckedAt;

  // SM-2 fields
  int repetition = 0;
  int interval = 0;
  double easeFactor = 2.5;
  DateTime? nextReview;

  static const int maxStarsWithoutCooldown = 3;

  @ignore
  Duration get waitingTime {
    if (nextReview == null) return Duration.zero;
    final diff = nextReview!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get canLevelUp {
    if (stars < maxStarsWithoutCooldown) return true;
    if (nextReview == null) return true;
    return DateTime.now().isAfter(nextReview!);
  }

  void processSm2Review(int quality) {
    // quality: 0-5 (5 = perfect, 0 = complete blackout)
    if (quality >= 3) {
      if (repetition == 0) {
        interval = 1;
      } else if (repetition == 1) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }
      repetition++;
    } else {
      repetition = 0;
      interval = 1;
    }
    
    easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (easeFactor < 1.3) easeFactor = 1.3;
    
    lastCheckedAt = DateTime.now();
    nextReview = lastCheckedAt!.add(Duration(days: interval));
  }
}
