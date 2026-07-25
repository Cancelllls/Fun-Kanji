import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

class OnyomiKunyomiMinigame extends StatefulWidget {
  const OnyomiKunyomiMinigame({super.key});

  @override
  State<OnyomiKunyomiMinigame> createState() => _OnyomiKunyomiMinigameState();
}

class _OnyomiKunyomiMinigameState extends State<OnyomiKunyomiMinigame>
    with SingleTickerProviderStateMixin {
  int _highestSeenLevel = 3;
  static const _maxLevel = 9;
  bool _loading = true;
  String? _error;
  List<Kanji> _kanjis = [];
  Kanji? _currentKanji;
  String _currentReading = '';
  bool _isOnyomi = false;
  int _score = 0;
  int _highScore = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _totalCorrect = 0;
  int _totalWrong = 0;
  String? _feedback;
  bool _isCorrect = false;
  bool _showMeaning = false;
  bool _sessionOver = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  AudioPlayer? _audioPlayer;
  bool _audioReady = false;

  static const _hsKey = 'onyomi_kunyomi_highscore';
  static const _bestStreakKey = 'onyomi_kunyomi_best_streak';
  static const _showMeaningKey = 'onyomi_kunyomi_show_meaning';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initAudio();
    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    try {
      _audioPlayer = AudioPlayer();
      _audioReady = true;
    } catch (_) {}
  }

  Future<void> _playSound(String name) async {
    if (!_audioReady || _audioPlayer == null) return;
    try {
      await _audioPlayer!.setAsset('assets/sounds/$name.mp3');
      await _audioPlayer!.play();
    } catch (_) {}
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _highScore = prefs.getInt(_hsKey) ?? 0;
      _bestStreak = prefs.getInt(_bestStreakKey) ?? 0;
      _showMeaning = prefs.getBool(_showMeaningKey) ?? false;
    } catch (_) {}
  }

  Future<void> _saveHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_hsKey, _highScore);
    } catch (_) {}
  }

  Future<void> _saveBestStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bestStreakKey, _bestStreak);
    } catch (_) {}
  }

  Future<void> _toggleMeaningHint() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showMeaningKey, !_showMeaning);
    setState(() => _showMeaning = !_showMeaning);
  }

  Future<void> _loadData() async {
    try {
      await _loadPrefs();
      final List<Kanji> allKanji = [];
      for (int i = 1; i <= _highestSeenLevel; i++) {
        final kanji = await ScriptLoader.loadKanji(i, context);
        allKanji.addAll(kanji);
      }
      _kanjis = allKanji
          .where((k) => k.readingsOn.isNotEmpty && k.readingsKun.isNotEmpty)
          .toList();

      if (_kanjis.isEmpty) {
        setState(() {
          _error = 'No kanji with both On and Kun readings found.';
          _loading = false;
        });
        return;
      }
      _nextQuestion();
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = 'Failed to load kanji data: $e';
        _loading = false;
      });
    }
  }

  Future<void> _restartSession() async {
    _sessionOver = false;
    setState(() => _loading = true);
    _error = null;
    _kanjis = [];
    _score = 0;
    _streak = 0;
    _totalCorrect = 0;
    _totalWrong = 0;
    _feedback = null;
    await _loadData();
  }

  void _nextQuestion() {
    if (_kanjis.isEmpty) return;
    final random = Random();
    _currentKanji = _kanjis[random.nextInt(_kanjis.length)];
    _isOnyomi = random.nextBool();
    if (_isOnyomi) {
      _currentReading = _currentKanji!.readingsOn[
          random.nextInt(_currentKanji!.readingsOn.length)];
    } else {
      _currentReading = _currentKanji!.readingsKun[
          random.nextInt(_currentKanji!.readingsKun.length)];
    }
    _feedback = null;
    setState(() {});
  }

  void _submitAnswer(bool guessIsOnyomi) {
    _isCorrect = guessIsOnyomi == _isOnyomi;
    if (_isCorrect) {
      _score++;
      _streak++;
      _totalCorrect++;
      if (_streak > _bestStreak) {
        _bestStreak = _streak;
        _saveBestStreak();
      }
      if (_score > _highScore) {
        _highScore = _score;
        _saveHighScore();
      }
      _feedback =
          'Correct! $_currentReading is ${_isOnyomi ? 'onyomi' : 'kunyomi'}';
      _pulseController.forward().then((_) => _pulseController.reverse());
      _playSound('correct');
    } else {
      _totalWrong++;
      if (_streak > 0) _sessionOver = true;
      _streak = 0;
      _feedback =
          'Wrong! $_currentReading is ${_isOnyomi ? 'onyomi' : 'kunyomi'}';
      _playSound('wrong');
    }
    setState(() {});
    Future.delayed(
      Duration(milliseconds: _isCorrect ? 900 : 1600),
      () {
        if (mounted) _nextQuestion();
      },
    );
  }

  void _changeLevel() async {
    final selected = await showDialog<int>(
      context: context,
      builder: (ctx) {
        int tempLevel = _highestSeenLevel;
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('Select Kanji Levels'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Highest level to include: $tempLevel',
                  style:
                      TextStyle(color: Theme.of(ctx).colorScheme.onSurface),
                ),
                Slider(
                  value: tempLevel.toDouble(),
                  min: 1,
                  max: _maxLevel.toDouble(),
                  divisions: _maxLevel - 1,
                  label: '$tempLevel',
                  onChanged: (v) =>
                      setDialogState(() => tempLevel = v.round()),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, tempLevel),
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
    if (selected != null && selected != _highestSeenLevel) {
      _highestSeenLevel = selected;
      await _restartSession();
    }
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
          title: const Text('Onyomi vs Kunyomi'),
          actions: [
            IconButton(
              icon: Icon(
                  _showMeaning ? Icons.visibility : Icons.visibility_off,
                  color: scheme.onSurfaceVariant),
              tooltip: _showMeaning ? 'Hide meaning hint' : 'Show meaning hint',
              onPressed: _loading ? null : _toggleMeaningHint,
            ),
            IconButton(
              icon: Icon(Icons.tune, color: scheme.onSurfaceVariant),
              tooltip: 'Change level',
              onPressed: _loading ? null : _changeLevel,
            ),
          ],
        ),
        body: _sessionOver ? _buildSessionSummary(scheme) : _buildBody(scheme),
      ),
    );
  }

  Widget _buildSessionSummary(ColorScheme scheme) {
    final accuracy = (_totalCorrect + _totalWrong) > 0
        ? (_totalCorrect / (_totalCorrect + _totalWrong) * 100).round()
        : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 64, color: AppColors.starColor),
                const SizedBox(height: 16),
                Text('Session Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    )),
                const SizedBox(height: 24),
                _summaryRow(scheme, 'Final Score', '$_score',
                    scheme.tertiary),
                _summaryRow(
                    scheme, 'Best Streak', '$_bestStreak', AppColors.starColor),
                _summaryRow(scheme, 'Correct', '$_totalCorrect',
                    scheme.tertiary),
                _summaryRow(
                    scheme, 'Wrong', '$_totalWrong', scheme.error),
                _summaryRow(scheme, 'Accuracy', '$accuracy%',
                    scheme.primary),
                const SizedBox(height: 24),
                if (_streak >= 5) _buildBadge(scheme),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: _restartSession,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(ColorScheme scheme, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 16)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildBadge(ColorScheme scheme) {
    final badge = _streak >= 15
        ? '15+ Streak Master!'
        : _streak >= 10
            ? '10 Streak Expert!'
            : '5 Streak!';
    final color = _streak >= 15
        ? AppColors.starColor
        : _streak >= 10
            ? scheme.tertiary
            : scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: color),
          const SizedBox(width: 8),
          Text(badge,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme scheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: scheme.error),
              const SizedBox(height: 16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.error)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _restartSession,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_kanjis.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No kanji with both readings in levels 1-$_highestSeenLevel.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _changeLevel,
              child: const Text('Change Level'),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildScoreBar(scheme),
            if (_streak >= 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildStreakBadge(scheme),
              ),
            const SizedBox(height: 12),
            _buildKanjiCard(scheme),
            if (_showMeaning && _currentKanji != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _currentKanji!.meanings.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            _buildReadingDisplay(scheme),
            const SizedBox(height: 32),
            _buildAnswerButtons(scheme),
            const SizedBox(height: 20),
            if (_feedback != null) _buildFeedbackChip(scheme),
            const Spacer(),
            _buildKanjiMeaning(scheme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakBadge(ColorScheme scheme) {
    String text;
    Color color;
    if (_streak >= 15) {
      text = '15+ Streak!';
      color = AppColors.starColor;
    } else if (_streak >= 10) {
      text = '10 Streak!';
      color = scheme.tertiary;
    } else {
      text = '5 Streak!';
      color = scheme.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: color, size: 18),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildScoreBar(ColorScheme scheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _scoreItem(
                Icons.emoji_events, '$_score', scheme.tertiary, 'Score'),
            Container(width: 1, height: 32, color: scheme.outlineVariant),
            _scoreItem(Icons.trending_up, '$_highScore', AppColors.starColor,
                'Best'),
            Container(width: 1, height: 32, color: scheme.outlineVariant),
            _scoreItem(Icons.local_fire_department, '$_streak',
                AppColors.confettiPink, 'Streak'),
          ],
        ),
      ),
    );
  }

  Widget _scoreItem(IconData icon, String value, Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildKanjiCard(ColorScheme scheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            ),
            child: Text(
              _currentKanji!.kanji,
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w300,
                color: scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadingDisplay(ColorScheme scheme) {
    return Text(
      _currentReading,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: scheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAnswerButtons(ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed:
                _feedback == null ? () => _submitAnswer(true) : null,
            child: const Column(
              children: [
                Text('音読み', style: TextStyle(fontSize: 14)),
                Text('Onyomi',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.tertiary,
              foregroundColor: scheme.onTertiary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed:
                _feedback == null ? () => _submitAnswer(false) : null,
            child: const Column(
              children: [
                Text('訓読み', style: TextStyle(fontSize: 14)),
                Text('Kunyomi',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackChip(ColorScheme scheme) {
    return AnimatedOpacity(
      opacity: _feedback != null ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color:
              _isCorrect ? scheme.tertiaryContainer : scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isCorrect ? Icons.check_circle : Icons.cancel,
              color: _isCorrect ? scheme.tertiary : scheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _feedback!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isCorrect
                      ? scheme.onTertiaryContainer
                      : scheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanjiMeaning(ColorScheme scheme) {
    if (_currentKanji == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Meaning: ${_currentKanji!.meanings.join(", ")}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
