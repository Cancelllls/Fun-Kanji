import 'package:flutter/material.dart';

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
              child: Text(
                '🔥 ${controller.currentStreak}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  ElevatedButton.icon(
                    icon: const Icon(Icons.gamepad),
                    label: const Text('Onyomi vs Kunyomi Minigame'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: controller.launchMinigame,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Interactive Reading Practice'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: controller.launchReadingPractice,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.style),
                    label: const Text('Custom Study Decks'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: controller.launchDecks,
                  ),
                  const SizedBox(height: 16),
                  ...WritingSystem.values
                    .map((writingSystem) => FutureBuilder<int>(
                          future: FunWithKanji.of(context).loadProgressPercent(
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
                        ))
                    ,
                ],
              )),
      ),
    );
  }
}
