import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class MatchCard {
  final String id;
  final String text;
  final String matchId;
  final bool isKanji;
  bool isFlipped;
  bool isMatched;

  MatchCard({
    required this.id,
    required this.text,
    required this.matchId,
    required this.isKanji,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class KanjiMatchGameScreen extends StatefulWidget {
  const KanjiMatchGameScreen({super.key});

  @override
  State<KanjiMatchGameScreen> createState() => _KanjiMatchGameScreenState();
}

class _KanjiMatchGameScreenState extends State<KanjiMatchGameScreen> {
  bool _loading = true;
  List<MatchCard> _cards = [];
  MatchCard? _firstFlipped;
  MatchCard? _secondFlipped;
  bool _busy = false;
  int _moves = 0;
  int _matchesFound = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startNewGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _startNewGame() async {
    setState(() {
      _loading = true;
      _moves = 0;
      _matchesFound = 0;
      _firstFlipped = null;
      _secondFlipped = null;
    });

    final n5List = await ScriptLoader.loadJlptKanji(5, 1);
    n5List.shuffle();
    final selected = n5List.take(6).toList();

    final List<MatchCard> cards = [];
    for (var k in selected) {
      final matchId = k.kanji;
      cards.add(MatchCard(
        id: '${k.kanji}_kanji',
        text: k.kanji,
        matchId: matchId,
        isKanji: true,
      ));
      cards.add(MatchCard(
        id: '${k.kanji}_meaning',
        text: k.meanings.isNotEmpty ? k.meanings.first : 'Kanji',
        matchId: matchId,
        isKanji: false,
      ));
    }

    cards.shuffle();

    if (mounted) {
      setState(() {
        _cards = cards;
        _loading = false;
      });
    }
  }

  void _onCardTap(MatchCard card) {
    if (_busy || card.isFlipped || card.isMatched) return;
    HapticFeedback.selectionClick();

    setState(() {
      card.isFlipped = true;
    });

    if (_firstFlipped == null) {
      _firstFlipped = card;
    } else {
      _secondFlipped = card;
      _moves++;
      _checkMatch();
    }
  }

  void _checkMatch() {
    _busy = true;
    final card1 = _firstFlipped!;
    final card2 = _secondFlipped!;

    if (card1.matchId == card2.matchId) {
      // Match found
      HapticFeedback.mediumImpact();
      setState(() {
        card1.isMatched = true;
        card2.isMatched = true;
        _matchesFound++;
        _firstFlipped = null;
        _secondFlipped = null;
        _busy = false;
      });

      if (_matchesFound == 6) {
        _confettiController.play();
      }
    } else {
      // No match
      Timer(const Duration(milliseconds: 900), () {
        if (mounted) {
          setState(() {
            card1.isFlipped = false;
            card2.isFlipped = false;
            _firstFlipped = null;
            _secondFlipped = null;
            _busy = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Kanji Memory Match',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Restart Game',
              onPressed: _startNewGame,
            ),
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Moves: $_moves',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Matches: $_matchesFound / 6',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _cards.length,
                          itemBuilder: (context, index) {
                            final card = _cards[index];
                            return M3SpringPressable(
                              onTap: () => _onCardTap(card),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: card.isMatched
                                      ? AppColors.tertiary.withValues(alpha: 0.2)
                                      : card.isFlipped
                                          ? (isDark ? AppColors.gradientDarkStart : AppColors.surface)
                                          : AppColors.primary.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: card.isMatched
                                        ? AppColors.tertiary
                                        : AppColors.primary.withValues(alpha: 0.4),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: card.isFlipped || card.isMatched
                                      ? Text(
                                          card.text,
                                          textAlign: TextAlign.center,
                                          style: card.isKanji
                                              ? GoogleFonts.yujiSyuku(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                )
                                              : GoogleFonts.sawarabiMincho(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                        )
                                      : const Icon(
                                          Icons.help_outline,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
