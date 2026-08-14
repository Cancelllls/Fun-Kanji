import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class JlptExamQuestion {
  final Kanji kanji;
  final String questionText;
  final String correctAnswer;
  final List<String> options;

  JlptExamQuestion({
    required this.kanji,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
  });
}

class JlptExamScreen extends StatefulWidget {
  final int jlptLevel;

  const JlptExamScreen({super.key, this.jlptLevel = 5});

  @override
  State<JlptExamScreen> createState() => _JlptExamScreenState();
}

class _JlptExamScreenState extends State<JlptExamScreen> {
  bool _loading = true;
  List<JlptExamQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadExamQuestions();
  }

  Future<void> _loadExamQuestions() async {
    setState(() => _loading = true);
    final allKanji = await ScriptLoader.loadAllJlptLevel(widget.jlptLevel);
    allKanji.shuffle();

    final selected = allKanji.take(10).toList();
    final List<JlptExamQuestion> questions = [];

    for (var k in selected) {
      final String correct = k.readingsOn.isNotEmpty
          ? k.readingsOn.first
          : (k.readingsKun.isNotEmpty ? k.readingsKun.first : k.meanings.first);

      final List<String> options = [correct];
      final distractors = allKanji
          .where((item) => item.kanji != k.kanji)
          .map((item) => item.readingsOn.isNotEmpty
              ? item.readingsOn.first
              : (item.readingsKun.isNotEmpty ? item.readingsKun.first : item.meanings.first))
          .toSet()
          .toList();

      distractors.shuffle();
      options.addAll(distractors.take(3));
      options.shuffle();

      questions.add(JlptExamQuestion(
        kanji: k,
        questionText: 'Select the primary reading / meaning for:',
        correctAnswer: correct,
        options: options,
      ));
    }

    if (mounted) {
      setState(() {
        _questions = questions;
        _loading = false;
      });
    }
  }

  void _submitAnswer(String option) {
    if (_isAnswered) return;
    HapticFeedback.selectionClick();

    setState(() {
      _selectedAnswer = option;
      _isAnswered = true;
      if (option == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    final double percentage = (_score / _questions.length) * 100;
    final bool passed = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          passed ? '🎉 Exam Passed!' : '📖 Keep Practicing!',
          style: GoogleFonts.sawarabiMincho(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Score: $_score / ${_questions.length}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: passed ? AppColors.tertiary : Colors.red[400],
              ),
            ),
            const SizedBox(height: 10),
            Text('Grade: ${percentage.toInt()}%'),
            const SizedBox(height: 14),
            Text(
              passed
                  ? 'Congratulations! You demonstrated strong mastery of JLPT N${widget.jlptLevel} Kanji.'
                  : 'Review N${widget.jlptLevel} Kanji decks and try the mock exam again.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _loadExamQuestions();
            },
            child: const Text('Retake Exam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'JLPT N${widget.jlptLevel} Mock Exam',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Progress Bar
                    LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      color: AppColors.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Question ${_currentIndex + 1} of ${_questions.length}'),
                        Text('Score: $_score'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Kanji Question Card
                    SizedBox(
                      width: double.infinity,
                      child: M3FloatingCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              _questions[_currentIndex].kanji.kanji,
                              style: GoogleFonts.yujiSyuku(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _questions[_currentIndex].questionText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Option Buttons
                    Expanded(
                      child: ListView.builder(
                        itemCount: _questions[_currentIndex].options.length,
                        itemBuilder: (context, index) {
                          final option = _questions[_currentIndex].options[index];
                          final isCorrectOption = option == _questions[_currentIndex].correctAnswer;
                          final isSelected = option == _selectedAnswer;

                          Color buttonColor = Colors.grey.withValues(alpha: 0.15);
                          if (_isAnswered) {
                            if (isCorrectOption) buttonColor = AppColors.tertiary.withValues(alpha: 0.3);
                            if (isSelected && !isCorrectOption) buttonColor = Colors.red.withValues(alpha: 0.3);
                          }

                          return M3SpringPressable(
                            onTap: () => _submitAnswer(option),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isAnswered && isCorrectOption
                                      ? AppColors.tertiary
                                      : Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (_isAnswered)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _nextQuestion,
                          child: Text(_currentIndex == _questions.length - 1 ? 'Finish Exam' : 'Next Question'),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
