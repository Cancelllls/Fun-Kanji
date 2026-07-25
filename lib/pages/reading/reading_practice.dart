import 'package:flutter/material.dart';

class ReadingPracticeScreen extends StatelessWidget {
  const ReadingPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          StoryCard(
            title: 'Level 1: Greetings',
            storySegments: [
              StorySegment('こんにちは。', null, null),
              StorySegment('私', 'わたし', 'I / me'),
              StorySegment('の', null, null),
              StorySegment('名前', 'なまえ', 'Name'),
              StorySegment('はジョンです。', null, null),
              StorySegment('今日', 'きょう', 'Today'),
              StorySegment('は', null, null),
              StorySegment('天気', 'てんき', 'Weather'),
              StorySegment('が', null, null),
              StorySegment('良', 'よ', 'Good'),
              StorySegment('いです。', null, null),
            ],
          ),
          SizedBox(height: 16),
          StoryCard(
            title: 'Level 2: At the Restaurant',
            storySegments: [
              StorySegment('すみません、', null, null),
              StorySegment('水', 'みず', 'Water'),
              StorySegment('を', null, null),
              StorySegment('飲', 'の', 'Drink'),
              StorySegment('みたいです。', null, null),
              StorySegment('店員', 'てんいん', 'Clerk / Waiter'),
              StorySegment('が', null, null),
              StorySegment('来', 'き', 'Come'),
              StorySegment('ました。', null, null),
              StorySegment('美味', 'おい', 'Delicious'),
              StorySegment('しい', null, null),
              StorySegment('食', 'た', 'Eat'),
              StorySegment('べ', null, null),
              StorySegment('物', 'もの', 'Thing'),
              StorySegment('ですね。', null, null),
            ],
          ),
        ],
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  final String title;
  final List<StorySegment> storySegments;

  const StoryCard({super.key, required this.title, required this.storySegments});

  void _showMeaning(BuildContext context, StorySegment segment) {
    if (segment.meaning == null) return;
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(segment.text,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                )),
            const SizedBox(height: 8),
            Text(segment.reading ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: scheme.onSurfaceVariant,
                )),
            const SizedBox(height: 16),
            Divider(color: scheme.outlineVariant),
            const SizedBox(height: 16),
            Text(segment.meaning!,
                style: TextStyle(
                  fontSize: 24,
                  color: scheme.onSurface,
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                )),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 8,
              children: storySegments.map((segment) {
                final isKanji = segment.meaning != null;
                return GestureDetector(
                  onTap: () => _showMeaning(context, segment),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2, vertical: 4),
                    decoration: BoxDecoration(
                      color: isKanji
                          ? scheme.primaryContainer.withValues(alpha: 0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isKanji
                          ? Border.all(color: scheme.primary)
                          : null,
                    ),
                    child: Text(
                      segment.text,
                      style: TextStyle(
                        fontSize: 20,
                        color: isKanji
                            ? scheme.primary
                            : scheme.onSurface,
                        fontWeight:
                            isKanji ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class StorySegment {
  final String text;
  final String? reading;
  final String? meaning;
  const StorySegment(this.text, this.reading, this.meaning);
}
