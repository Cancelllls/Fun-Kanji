import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/config/app_constants.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/pages/home/home.dart';
import 'package:fun_with_kanji/pages/home/learn_unit_list_tile.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:fun_with_kanji/pages/learning/drawing_practice.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;
  const HomePageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(AppConstants.appName),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.starColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: AppColors.starColor, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.currentStreak}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<void>(
            stream: FunWithKanji.of(context).onChanges,
            builder: (context, snapshot) => ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildOverallProgress(context, scheme),
                    const SizedBox(height: 12),
                    _buildContinueLearning(context, scheme),
                    const SizedBox(height: 12),
                    _buildKanjiOfDay(context, scheme),
                    const SizedBox(height: 12),
                    _FeatureCard(
                      icon: Icons.gamepad,
                      label: 'Onyomi vs Kunyomi Minigame',
                      color: scheme.primary,
                      containerColor: scheme.primaryContainer,
                      onTap: controller.launchMinigame,
                    ),
                    const SizedBox(height: 12),
                    _FeatureCard(
                      icon: Icons.menu_book,
                      label: 'Interactive Reading Practice',
                      color: scheme.tertiary,
                      containerColor: scheme.tertiaryContainer,
                      onTap: controller.launchReadingPractice,
                    ),
                    const SizedBox(height: 12),
                    _FeatureCard(
                      icon: Icons.style,
                      label: 'Custom Study Decks',
                      color: scheme.secondary,
                      containerColor: scheme.secondaryContainer,
                      onTap: controller.launchDecks,
                    ),
                    const SizedBox(height: 16),
                    ...WritingSystem.values
                        .map((writingSystem) => FutureBuilder<int>(
                              future:
                                  FunWithKanji.of(context).loadProgressPercent(
                                writingSystem,
                              ),
                              builder: (context, snapshot) => AnimatedScale(
                                scale: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? 0
                                    : 1,
                                curve: Curves.easeInOut,
                                duration: Duration(
                                    milliseconds:
                                        300 + (100 * writingSystem.index)),
                                child: LeanUnitListTile(
                                  progress: snapshot.data,
                                  title: writingSystem.getTitle(context),
                                  symbol: writingSystem.symbol,
                                  onTap: () =>
                                      controller.learnSystem(writingSystem),
                                  onSettings: () => controller
                                      .writingSystemSettings(writingSystem),
                                ),
                              ),
                            )),
                  ],
                )),
      ),
    );
  }

  Widget _buildOverallProgress(BuildContext context, ColorScheme scheme) {
    return FutureBuilder<Map<String, int>>(
      future: _loadOverallStats(context),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        if (stats == null) return const SizedBox.shrink();
        final totalChars = stats['total'] ?? 1;
        final finished = stats['finished'] ?? 0;
        final pct = (finished / totalChars * 100).round();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: AppColors.starColor, size: 24),
                    const SizedBox(width: 8),
                    Text('Overall Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        )),
                    const Spacer(),
                    Text('$pct%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: finished / (totalChars > 0 ? totalChars : 1),
                    minHeight: 8,
                    backgroundColor: scheme.surfaceContainerHighest,
                    color: AppColors.tertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$finished of $totalChars characters mastered',
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, int>> _loadOverallStats(BuildContext context) async {
    try {
      int finished = 0;
      int total = 0;
      for (final system in WritingSystem.values) {
        total += system.entries;
        finished +=
            await FunWithKanji.of(context).getFinishedCount(system);
      }
      return {'finished': finished, 'total': total};
    } catch (_) {
      return {'finished': 0, 'total': 1};
    }
  }

  Widget _buildKanjiOfDay(BuildContext context, ColorScheme scheme) {
    return FutureBuilder<DailyKanji?>(
      future: _loadKanjiOfDay(context),
      builder: (context, snapshot) {
        final daily = snapshot.data;
        if (daily == null) return const SizedBox.shrink();

        return M3SpringPressable(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DrawingPracticeScreen(kanji: daily.kanji),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5C158).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      daily.kanji,
                      style: GoogleFonts.yujiSyuku(
                        textStyle: TextStyle(
                          fontSize: 36,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.today,
                                size: 16, color: Color(0xFFEC4899)),
                            const SizedBox(width: 4),
                            const Text('Kanji of the Day',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEC4899),
                                )),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          daily.meaning,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to practice drawing ✍️',
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_note, color: scheme.primary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DailyKanji?> _loadKanjiOfDay(BuildContext context) async {
    try {
      final kanjis = await ScriptLoader.loadKanji(1, context);
      if (kanjis.isEmpty) return null;
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      final kanji = kanjis[dayOfYear % kanjis.length];
      return DailyKanji(kanji.kanji, kanji.meanings.join(', '));
    } catch (_) {
      return null;
    }
  }

  Widget _buildContinueLearning(BuildContext context, ColorScheme scheme) {
    return FutureBuilder<WritingSystem?>(
      future: _getLastStudiedSystem(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final system = snapshot.data!;
        return _FeatureCard(
          icon: Icons.play_circle_fill,
          label: 'Continue ${system.getTitle(context)}',
          color: scheme.primary,
          containerColor: scheme.primaryContainer,
          onTap: () => controller.learnSystem(system),
        );
      },
    );
  }

  Future<WritingSystem?> _getLastStudiedSystem() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('last_studied_system');
    if (name == null) return null;
    try {
      return WritingSystem.values.firstWhere((s) => s.name == name);
    } catch (_) {
      return null;
    }
  }
}

class DailyKanji {
  final String kanji;
  final String meaning;
  const DailyKanji(this.kanji, this.meaning);
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color containerColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.containerColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return M3SpringPressable(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: containerColor,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
