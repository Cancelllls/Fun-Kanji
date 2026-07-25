import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/config/app_constants.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/pages/home/home.dart';
import 'package:fun_with_kanji/pages/home/learn_unit_list_tile.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

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
                  padding: const EdgeInsets.all(32),
                  children: [
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
