import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_with_kanji/config/app_colors.dart';

enum Achievement {
  firstKanji,
  tenKanji,
  fiftyKanji,
  hundredKanji,
  firstRadical,
  firstKana,
  fiveDayStreak,
  sevenDayStreak,
  tenStarsOnOne,
  allKanaMastered,
}

class AchievementData {
  final Achievement id;
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const AchievementData({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class AchievementManager {
  static const _key = 'achievements';

  static const List<AchievementData> all = [
    AchievementData(
      id: Achievement.firstKanji,
      label: 'First Steps',
      description: 'Master your first kanji',
      icon: Icons.star,
      color: AppColors.primary,
    ),
    AchievementData(
      id: Achievement.tenKanji,
      label: 'Kanji Apprentice',
      description: 'Master 10 kanji',
      icon: Icons.auto_awesome,
      color: AppColors.tertiary,
    ),
    AchievementData(
      id: Achievement.fiftyKanji,
      label: 'Kanji Scholar',
      description: 'Master 50 kanji',
      icon: Icons.school,
      color: AppColors.starColor,
    ),
    AchievementData(
      id: Achievement.hundredKanji,
      label: 'Kanji Master',
      description: 'Master 100 kanji',
      icon: Icons.emoji_events,
      color: AppColors.confettiPink,
    ),
    AchievementData(
      id: Achievement.firstRadical,
      label: 'Radical Explorer',
      description: 'Master your first radical',
      icon: Icons.category,
      color: AppColors.secondary,
    ),
    AchievementData(
      id: Achievement.firstKana,
      label: 'Kana Beginner',
      description: 'Master your first kana character',
      icon: Icons.text_fields,
      color: AppColors.tertiary,
    ),
    AchievementData(
      id: Achievement.fiveDayStreak,
      label: 'Dedicated Learner',
      description: '5-day study streak',
      icon: Icons.local_fire_department,
      color: AppColors.starColor,
    ),
    AchievementData(
      id: Achievement.sevenDayStreak,
      label: 'Weekly Warrior',
      description: '7-day study streak',
      icon: Icons.whatshot,
      color: AppColors.confettiPink,
    ),
    AchievementData(
      id: Achievement.tenStarsOnOne,
      label: 'Perfect Score',
      description: 'Get 10 stars on any character',
      icon: Icons.stars,
      color: AppColors.starColor,
    ),
    AchievementData(
      id: Achievement.allKanaMastered,
      label: 'Kana Master',
      description: 'Master all Hiragana and Katakana',
      icon: Icons.translate,
      color: AppColors.primary,
    ),
  ];

  static Future<Set<String>> _loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    return Set<String>.from(jsonDecode(raw) as List);
  }

  static Future<void> unlock(Achievement id) async {
    final unlocked = await _loadUnlocked();
    if (unlocked.contains(id.name)) return;
    unlocked.add(id.name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(unlocked.toList()));
  }

  static Future<Set<Achievement>> getUnlocked() async {
    final raw = await _loadUnlocked();
    return raw.map((s) => Achievement.values.firstWhere((a) => a.name == s)).toSet();
  }

  static Future<bool> isUnlocked(Achievement id) async {
    final unlocked = await _loadUnlocked();
    return unlocked.contains(id.name);
  }

  static Future<int> totalUnlocked() async {
    final unlocked = await _loadUnlocked();
    return unlocked.length;
  }

  static Future<Set<Achievement>> checkAndShowNew(
      BuildContext context, Set<Achievement> justUnlocked) async {
    final unlocked = await _loadUnlocked();
    final newOnes = justUnlocked.where((a) => !unlocked.contains(a.name)).toSet();
    for (final a in newOnes) {
      await unlock(a);
    }
    if (newOnes.isNotEmpty && context.mounted) {
      _showAchievementDialog(context, newOnes);
    }
    return newOnes;
  }

  static void _showAchievementDialog(
      BuildContext context, Set<Achievement> achievements) {
    if (achievements.length == 1) {
      final a = achievements.first;
      final data = all.firstWhere((d) => d.id == a);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Icon(data.icon, size: 64, color: data.color),
                const SizedBox(height: 12),
                Text('Achievement Unlocked!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(ctx).colorScheme.onSurface,
                    )),
                const SizedBox(height: 8),
                Text(data.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: data.color,
                    )),
                const SizedBox(height: 4),
                Text(data.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Nice!'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
