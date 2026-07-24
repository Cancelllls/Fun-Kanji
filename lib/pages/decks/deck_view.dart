import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/models/deck.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/pages/overview/kanji_list_tile.dart';

class DeckViewScreen extends StatefulWidget {
  final Deck deck;
  const DeckViewScreen({super.key, required this.deck});

  @override
  State<DeckViewScreen> createState() => _DeckViewScreenState();
}

class _DeckViewScreenState extends State<DeckViewScreen> {
  bool _loading = true;
  List<Kanji> _deckKanjis = [];

  @override
  void initState() {
    super.initState();
    _loadKanji();
  }

  Future<void> _loadKanji() async {
    final List<Kanji> allKanji = [];
    for (int i = 1; i <= 9; i++) {
      try {
        allKanji.addAll(await ScriptLoader.loadKanji(i, context));
      } catch (_) {}
    }
    _deckKanjis = allKanji.where((k) => widget.deck.kanjiIds.contains(k.kanji)).toList();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.deck.name),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _deckKanjis.isEmpty
              ? const Center(child: Text('No Kanji in this deck.'))
              : AnimationLimiter(
                  child: ListView.builder(
                    itemCount: _deckKanjis.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: KanjiListTile(kanji: _deckKanjis[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
