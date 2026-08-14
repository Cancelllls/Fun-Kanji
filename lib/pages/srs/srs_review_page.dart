import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/models/srs_manager.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class SrsReviewScreen extends StatefulWidget {
  const SrsReviewScreen({super.key});

  @override
  State<SrsReviewScreen> createState() => _SrsReviewScreenState();
}

class _SrsReviewScreenState extends State<SrsReviewScreen> {
  bool _loading = true;
  List<SrsItem> _dueItems = [];
  Map<String, Kanji> _kanjiLookup = {};
  int _currentIndex = 0;
  bool _showAnswer = false;
  late ConfettiController _confettiController;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final due = await SrsManager.getDueReviews();

    // Load kanji details
    final Map<String, Kanji> lookup = {};
    for (int n = 1; n <= 5; n++) {
      try {
        final list = await ScriptLoader.loadAllJlptLevel(n);
        for (var k in list) {
          lookup[k.kanji] = k;
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _dueItems = due;
        _kanjiLookup = lookup;
        _loading = false;
      });
    }
  }

  void _answer(bool correct) async {
    if (_dueItems.isEmpty || _currentIndex >= _dueItems.length) return;
    HapticFeedback.mediumImpact();

    final item = _dueItems[_currentIndex];
    await SrsManager.recordReviewResult(item.kanji, correct);

    if (correct) {
      _confettiController.play();
    }

    setState(() {
      _completedCount++;
      _showAnswer = false;
      _currentIndex++;
    });
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
            'SRS Review Session',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
              ),
            ),
            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _dueItems.isEmpty || _currentIndex >= _dueItems.length
                    ? _buildCompletedState(isDark)
                    : _buildReviewCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, size: 72, color: AppColors.tertiary),
            ),
            const SizedBox(height: 20),
            Text(
              'All Due Reviews Completed!',
              style: GoogleFonts.sawarabiMincho(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Great job! You reviewed $_completedCount Kanji items today.',
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Return Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(bool isDark) {
    final currentItem = _dueItems[_currentIndex];
    final kanjiObj = _kanjiLookup[currentItem.kanji];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${_currentIndex + 1} of ${_dueItems.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Stage: ${currentItem.stageName}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Flashcard
          Expanded(
            child: M3SpringPressable(
              onTap: () {
                setState(() {
                  _showAnswer = !_showAnswer;
                });
              },
              child: SizedBox(
                width: double.infinity,
                child: M3FloatingCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(
                      currentItem.kanji,
                      style: GoogleFonts.yujiSyuku(
                        fontSize: 110,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!_showAnswer)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app, size: 18),
                            SizedBox(width: 6),
                            Text('Tap to Reveal Meaning & Reading'),
                          ],
                        ),
                      )
                    else ...[
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        kanjiObj?.meanings.join(', ') ?? 'Kanji Review',
                        style: GoogleFonts.sawarabiMincho(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (kanjiObj != null) ...[
                        Text(
                          'Onyomi: ${kanjiObj.readingsOn.join(", ")}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kunyomi: ${kanjiObj.readingsKun.join(", ")}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          if (_showAnswer)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _answer(false),
                      icon: const Icon(Icons.close),
                      label: const Text('Forgot'),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _answer(true),
                      icon: const Icon(Icons.check),
                      label: const Text('Remembered'),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  setState(() => _showAnswer = true);
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Show Answer'),
              ),
            ),
        ],
      ),
    );
  }
}
