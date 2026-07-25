import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';

class OnyomiKunyomiMinigame extends StatefulWidget {
  const OnyomiKunyomiMinigame({super.key});

  @override
  State<OnyomiKunyomiMinigame> createState() => _OnyomiKunyomiMinigameState();
}

class _OnyomiKunyomiMinigameState extends State<OnyomiKunyomiMinigame> {
  bool _loading = true;
  List<Kanji> _kanjis = [];
  Kanji? _currentKanji;
  String _currentReading = '';
  bool _isOnyomi = false;
  int _score = 0;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load a few levels of Kanji
    final List<Kanji> allKanji = [];
    for (int i = 1; i <= 3; i++) {
      allKanji.addAll(await ScriptLoader.loadKanji(i, context));
    }
    // Filter kanjis that have at least one of both reading types
    _kanjis = allKanji.where((k) => k.readingsOn.isNotEmpty && k.readingsKun.isNotEmpty).toList();
    _nextQuestion();
    setState(() {
      _loading = false;
    });
  }

  void _nextQuestion() {
    if (_kanjis.isEmpty) return;
    final random = Random();
    _currentKanji = _kanjis[random.nextInt(_kanjis.length)];
    
    // Pick randomly between Onyomi or Kunyomi
    _isOnyomi = random.nextBool();
    if (_isOnyomi) {
      _currentReading = _currentKanji!.readingsOn[random.nextInt(_currentKanji!.readingsOn.length)];
    } else {
      _currentReading = _currentKanji!.readingsKun[random.nextInt(_currentKanji!.readingsKun.length)];
    }
    _feedback = null;
  }

  void _submitAnswer(bool guessIsOnyomi) {
    if (guessIsOnyomi == _isOnyomi) {
      _score++;
      _feedback = 'Correct! $_currentReading is ${_isOnyomi ? 'Onyomi' : 'Kunyomi'}';
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _nextQuestion();
          });
        }
      });
    } else {
      _feedback = 'Wrong! $_currentReading is ${_isOnyomi ? 'Onyomi' : 'Kunyomi'}';
      _score = 0; // Reset streak
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _nextQuestion();
          });
        }
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onyomi vs Kunyomi'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Score: $_score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer,
                  )),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _kanjis.isEmpty
              ? const Center(child: Text('No Kanji data found'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentKanji!.kanji,
                        style: TextStyle(
                          fontSize: 100,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Is this reading Onyomi or Kunyomi?',
                          style: TextStyle(
                            fontSize: 16,
                            color: scheme.onSurfaceVariant,
                          )),
                      const SizedBox(height: 10),
                      Text(
                        _currentReading,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              foregroundColor: scheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              elevation: 0,
                            ),
                            onPressed: _feedback == null
                                ? () => _submitAnswer(true)
                                : null,
                            child: const Text('Onyomi (On)',
                                style:
                                    TextStyle(fontSize: 18)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.tertiary,
                              foregroundColor: scheme.onTertiary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              elevation: 0,
                            ),
                            onPressed: _feedback == null
                                ? () => _submitAnswer(false)
                                : null,
                            child: const Text('Kunyomi (Kun)',
                                style:
                                    TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      if (_feedback != null)
                        Text(
                          _feedback!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _feedback!.startsWith('Correct')
                                ? scheme.tertiary
                                : scheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
