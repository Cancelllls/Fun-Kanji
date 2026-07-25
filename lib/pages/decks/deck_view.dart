import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _deckKanjis =
        allKanji.where((k) => widget.deck.kanjiIds.contains(k.kanji)).toList();
    if (mounted) setState(() => _loading = false);
  }

  void _startStudy() {
    if (_deckKanjis.isEmpty) return;
    HapticFeedback.mediumImpact();
    final kanjiStrings = _deckKanjis.map((k) => k.kanji).toList();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondary) =>
            DeckStudyPage(kanjiList: kanjiStrings, deckName: widget.deck.name),
        transitionsBuilder: (_, animation, secondary, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.deck.name),
        ),
        floatingActionButton: _deckKanjis.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: _startStudy,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Study'),
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              )
            : null,
        body: _loading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _deckKanjis.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 64, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text('No kanji in this deck yet.',
                            style:
                                TextStyle(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Text('Add some from the dictionary!',
                            style: TextStyle(
                                fontSize: 13,
                                color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  )
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
                              child:
                                  KanjiListTile(kanji: _deckKanjis[index]),
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

class DeckStudyPage extends StatefulWidget {
  final List<String> kanjiList;
  final String deckName;

  const DeckStudyPage({
    super.key,
    required this.kanjiList,
    required this.deckName,
  });

  @override
  State<DeckStudyPage> createState() => _DeckStudyPageState();
}

class _DeckStudyPageState extends State<DeckStudyPage>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  bool _flipped = false;
  Map<String, Kanji>? _kanjiData;
  bool _loading = true;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadKanjiData();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadKanjiData() async {
    final Map<String, Kanji> data = {};
    for (int i = 1; i <= 9; i++) {
      try {
        final kanjis = await ScriptLoader.loadKanji(i, context);
        for (final k in kanjis) {
          if (widget.kanjiList.contains(k.kanji)) {
            data[k.kanji] = k;
          }
        }
      } catch (_) {}
    }
    if (mounted) setState(() => _loading = false);
  }

  void _flipCard() {
    _flipped = !_flipped;
    _flipped ? _flipController.forward() : _flipController.reverse();
    HapticFeedback.selectionClick();
  }

  void _nextCard() {
    if (_index < widget.kanjiList.length - 1) {
      _flipped = false;
      _flipController.reset();
      setState(() => _index++);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Complete!'),
          content: Text(
              'You reviewed all ${widget.kanjiList.length} kanji in this deck.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Review Again'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  void _prevCard() {
    if (_index > 0) {
      _flipped = false;
      _flipController.reset();
      setState(() => _index--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currentKanji = widget.kanjiList[_index];
    final data = _kanjiData?[currentKanji];
    final progress = '${_index + 1}/${widget.kanjiList.length}';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(progress,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: scheme.primary)),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _flipCard,
                      child: AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_flipAnimation.value * 3.14159),
                            child: _flipAnimation.value < 0.5
                                ? _buildFront(scheme, currentKanji,
                                    data?.meanings.firstOrNull ?? '')
                                : _buildBack(scheme, data),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _index > 0 ? _prevCard : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Prev'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _nextCard,
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(_index < widget.kanjiList.length - 1
                              ? 'Next'
                              : 'Finish'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFront(ColorScheme scheme, String kanji, String meaning) {
    return Container(
      width: 280,
      height: 360,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(kanji,
              style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w300,
                  color: scheme.onPrimaryContainer)),
          const Spacer(),
          Text('Tap to flip',
              style: TextStyle(
                  fontSize: 13,
                  color: scheme.onPrimaryContainer
                      .withValues(alpha: 0.5))),
          Text(meaning,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: scheme.onPrimaryContainer
                      .withValues(alpha: 0.7))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBack(ColorScheme scheme, Kanji? data) {
    if (data == null) return _buildFront(scheme, '?', 'No data');
    return Container(
      width: 280,
      height: 360,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Meanings',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary)),
            const SizedBox(height: 4),
            Text(data.meanings.join(', '),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface)),
            const SizedBox(height: 16),
            Text('On readings',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary)),
            Text(data.readingsOn.join(', '),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: scheme.onSurface)),
            const SizedBox(height: 16),
            Text('Kun readings',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary)),
            Text(data.readingsKun.join(', '),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: scheme.onSurface)),
            const SizedBox(height: 12),
            if (data.radicals.isNotEmpty)
              Text('Radicals: ${data.radicals.join(", ")}',
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
