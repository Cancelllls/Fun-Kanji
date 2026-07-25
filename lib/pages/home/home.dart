import 'package:flutter/material.dart';

import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:fun_with_kanji/config/config_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/pages/home/home_view.dart';
import 'package:fun_with_kanji/pages/minigame/onyomi_kunyomi.dart';
import 'package:fun_with_kanji/pages/reading/reading_practice.dart';
import 'package:fun_with_kanji/pages/decks/decks.dart';
import 'package:fun_with_kanji/pages/learning/learning.dart';
import 'package:fun_with_kanji/utils/achievement_manager.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:home_widget/home_widget.dart';
import 'package:fun_with_kanji/models/script_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageController createState() => HomePageController();
}

class HomePageController extends State<HomePage> {
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadAndCheckStreak();
  }

  Future<void> _loadAndCheckStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt(ConfigKeys.currentStreak) ?? 0;
    String lastLoginStr = prefs.getString(ConfigKeys.lastLoginDate) ?? '';
    
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    if (lastLoginStr.isNotEmpty) {
      DateTime lastLogin = DateTime.parse(lastLoginStr);
      DateTime lastLoginDate = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
      
      final difference = today.difference(lastLoginDate).inDays;
      if (difference == 1) {
        streak += 1;
      } else if (difference > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }
    
    await prefs.setInt(ConfigKeys.currentStreak, streak);
    await prefs.setString(ConfigKeys.lastLoginDate, today.toIso8601String());
    
    if (mounted) {
      setState(() {
        currentStreak = streak;
      });
    }

    final Set<Achievement> streakAchievements = {};
    if (streak >= 5) streakAchievements.add(Achievement.fiveDayStreak);
    if (streak >= 7) streakAchievements.add(Achievement.sevenDayStreak);
    if (streakAchievements.isNotEmpty) {
      await AchievementManager.checkAndShowNew(context, streakAchievements);
    }

    await _updateWidgetData(today);
  }

  Future<void> _updateWidgetData(DateTime today) async {
    try {
      final kanjis = await ScriptLoader.loadKanji(1, context);
      if (kanjis.isNotEmpty) {
        final dayOfYear = int.parse(today.difference(DateTime(today.year, 1, 1)).inDays.toString());
        final dailyKanji = kanjis[dayOfYear % kanjis.length];
        
        await HomeWidget.saveWidgetData<String>('kanji', dailyKanji.kanji);
        await HomeWidget.saveWidgetData<String>('meaning', dailyKanji.meanings.join(', '));
        await HomeWidget.updateWidget(name: 'KanjiWidgetProvider');
      }
    } catch (_) {}
  }

  void launchMinigame() => Navigator.of(context).push(
        _createRoute(const OnyomiKunyomiMinigame()),
      );

  void launchReadingPractice() => Navigator.of(context).push(
        _createRoute(const ReadingPracticeScreen()),
      );

  void launchDecks() => Navigator.of(context).push(
        _createRoute(const DecksScreen()),
      );

  void learnSystem(WritingSystem writingSystem) {
    _saveLastStudied(writingSystem);
    Navigator.of(context).push(
      _createRoute(LearningPage(writingSystem: writingSystem)),
    );
  }

  void _saveLastStudied(WritingSystem system) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_studied_system', system.name);
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void writingSystemSettings(WritingSystem writingSystem) async {
    final action = await showDialog<WritingSystemSettingsAction?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.settings),
        content: SizedBox(
          width: double.maxFinite,
          height: 128,
          child: ListView(
            children: WritingSystemSettingsAction.values
                .map(
                  (action) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(action.localizedName(context)),
                    leading: Icon(action.icon),
                    onTap: () => Navigator.of(context).pop(action),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(L10n.of(context)!.cancel),
          ),
        ],
      ),
    );
    if (action == null) return;

    switch (action) {
      case WritingSystemSettingsAction.reset:
        FunWithKanji.of(context).resetLearningProgressForSystem(writingSystem);
        break;
    }
  }

  @override
  Widget build(BuildContext context) => HomePageView(this);
}

enum WritingSystemSettingsAction { reset }

extension on WritingSystemSettingsAction {
  String localizedName(BuildContext context) {
    switch (this) {
      case WritingSystemSettingsAction.reset:
        return L10n.of(context)!.reset;
    }
  }

  IconData get icon {
    switch (this) {
      case WritingSystemSettingsAction.reset:
        return Icons.delete_outlined;
    }
  }
}
