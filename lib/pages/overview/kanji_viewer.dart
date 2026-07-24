import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/pages/overview/kanji_list_tile.dart';

class KanjiViewer extends StatelessWidget {
  final int level;
  const KanjiViewer({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Kanji Level $level'),
      ),
      body: FutureBuilder<List<Kanji>>(
        future: ScriptLoader.loadKanji(level, context),
        builder: (context, snapshot) {
          final kanji = snapshot.data;
          if (kanji == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: kanji.length,
              itemBuilder: (_, i) => AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: KanjiListTile(kanji: kanji[i]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
