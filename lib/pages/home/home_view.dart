import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/config/app_constants.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/pages/home/home.dart';
import 'package:fun_with_kanji/pages/home/learn_unit_list_tile.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
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
                    _buildKanjiOfDay(context, scheme),
                    const SizedBox(height: 12),
                    _FeatureButton(
                      icon: Icons.gamepad,
                      label: 'Onyomi vs Kunyomi Minigame',
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.onPrimaryContainer,
                      onPressed: controller.launchMinigame,
                    ),
                    const SizedBox(height: 12),
                    _FeatureButton(
                      icon: Icons.menu_book,
                      label: 'Interactive Reading Practice',
                      backgroundColor: scheme.tertiaryContainer,
                      foregroundColor: scheme.onTertiaryContainer,
                      onPressed: controller.launchReadingPractice,
                    ),
                    const SizedBox(height: 12),
                    _FeatureButton(
                      icon: Icons.style,
                      label: 'Custom Study Decks',
                      backgroundColor: scheme.secondaryContainer,
                      foregroundColor: scheme.onSecondaryContainer,
                      onPressed: controller.launchDecks,
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: null,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
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
                            Icon(Icons.today,
                                size: 16, color: scheme.primary),
                            const SizedBox(width: 4),
                            Text('Kanji of the Day',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.primary,
                                )),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          daily.meaning,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
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
}

class DailyKanji {
  final String kanji;
  final String meaning;
  const DailyKanji(this.kanji, this.meaning);
}

class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const _FeatureButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
