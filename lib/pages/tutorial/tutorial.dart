import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_with_kanji/config/app_colors.dart';

class TutorialPage extends StatefulWidget {
  final VoidCallback onComplete;
  const TutorialPage({super.key, required this.onComplete});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _page = 0;
  final _controller = PageController();

  static const _pages = [
    _TutorialData(
      icon: Icons.school,
      title: 'Welcome to Fun Kanji!',
      description:
          'Your all-in-one companion for mastering Japanese characters.\n\nLearn Hiragana, Katakana, Kanji radicals, and all 2,136 Joyo Kanji with spaced repetition.',
      color: Color(0xFF4F46E5),
    ),
    _TutorialData(
      icon: Icons.replay,
      title: 'Smart Learning',
      description:
          'Rate your recall after each character and our SM-2 algorithm schedules reviews at the optimal time.\n\nEarn stars and unlock confetti celebrations as you progress!',
      color: Color(0xFF22C55E),
    ),
    _TutorialData(
      icon: Icons.auto_awesome,
      title: 'Practice & Play',
      description:
          'Test yourself with the Onyomi vs Kunyomi minigame, practice stroke order, read interactive stories, and create custom study decks.\n\nAll 100% offline and private.',
      color: Color(0xFFFBBF24),
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.animateToPage(_page + 1,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_seen', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text('Skip',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: data.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(data.icon, size: 56, color: data.color),
                        ),
                        const SizedBox(height: 48),
                        Text(data.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            )),
                        const SizedBox(height: 20),
                        Text(data.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: scheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => Container(
                        width: _page == i ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _page == i
                              ? AppColors.primary
                              : scheme.outlineVariant.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                    child: Text(
                        _page < _pages.length - 1 ? 'Next' : 'Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _TutorialData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
