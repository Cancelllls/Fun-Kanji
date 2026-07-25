import 'package:flutter/material.dart';

import 'package:fun_with_kanji/widgets/dynamic_background.dart';

class ReadingPracticeScreen extends StatelessWidget {
  const ReadingPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Reading Practice'),
        ),
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
              vocabs: [
                StoryVocab('私', 'わたし', 'I / me'),
                StoryVocab('名前', 'なまえ', 'Name'),
                StoryVocab('今日', 'きょう', 'Today'),
                StoryVocab('天気', 'てんき', 'Weather'),
                StoryVocab('良い', 'よい', 'Good'),
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
              vocabs: [
                StoryVocab('水', 'みず', 'Water'),
                StoryVocab('飲む', 'のむ', 'To drink'),
                StoryVocab('店員', 'てんいん', 'Clerk / Waiter'),
                StoryVocab('来る', 'くる', 'To come'),
                StoryVocab('美味しい', 'おいしい', 'Delicious'),
                StoryVocab('食べ物', 'たべもの', 'Food'),
              ],
            ),
            SizedBox(height: 16),
            StoryCard(
              title: 'Level 3: At the Station',
              storySegments: [
                StorySegment('駅', 'えき', 'Station'),
                StorySegment('はどこですか？', null, null),
                StorySegment('東京', 'とうきょう', 'Tokyo'),
                StorySegment('駅', 'えき', 'Station'),
                StorySegment('は', null, null),
                StorySegment('新宿', 'しんじゅく', 'Shinjuku'),
                StorySegment('の', null, null),
                StorySegment('次', 'つぎ', 'Next'),
                StorySegment('です。', null, null),
                StorySegment('出口', 'でぐち', 'Exit'),
                StorySegment('は', null, null),
                StorySegment('東口', 'ひがしぐち', 'East exit'),
                StorySegment('です。', null, null),
                StorySegment('切符', 'きっぷ', 'Ticket'),
                StorySegment('を', null, null),
                StorySegment('買', 'か', 'Buy'),
                StorySegment('いました。', null, null),
              ],
              vocabs: [
                StoryVocab('駅', 'えき', 'Station'),
                StoryVocab('東京', 'とうきょう', 'Tokyo'),
                StoryVocab('新宿', 'しんじゅく', 'Shinjuku'),
                StoryVocab('出口', 'でぐち', 'Exit'),
                StoryVocab('切符', 'きっぷ', 'Ticket'),
                StoryVocab('買う', 'かう', 'To buy'),
              ],
            ),
            SizedBox(height: 16),
            StoryCard(
              title: 'Level 4: Daily Routine',
              storySegments: [
                StorySegment('毎朝', 'まいあさ', 'Every morning'),
                StorySegment('七時', 'しちじ', '7 o\'clock'),
                StorySegment('に', null, null),
                StorySegment('起', 'お', 'Wake up'),
                StorySegment('きます。', null, null),
                StorySegment('朝', 'あさ', 'Morning'),
                StorySegment('ごはんを', null, null),
                StorySegment('食', 'た', 'Eat'),
                StorySegment('べて、', null, null),
                StorySegment('学校', 'がっこう', 'School'),
                StorySegment('へ', null, null),
                StorySegment('行', 'い', 'Go'),
                StorySegment('きます。', null, null),
                StorySegment('夜', 'よる', 'Night'),
                StorySegment('十時', 'じゅうじ', '10 o\'clock'),
                StorySegment('に', null, null),
                StorySegment('寝', 'ね', 'Sleep'),
                StorySegment('ます。', null, null),
              ],
              vocabs: [
                StoryVocab('毎朝', 'まいあさ', 'Every morning'),
                StoryVocab('起きる', 'おきる', 'To wake up'),
                StoryVocab('朝ごはん', 'あさごはん', 'Breakfast'),
                StoryVocab('学校', 'がっこう', 'School'),
                StoryVocab('行く', 'いく', 'To go'),
                StoryVocab('夜', 'よる', 'Night'),
                StoryVocab('寝る', 'ねる', 'To sleep'),
              ],
            ),
            SizedBox(height: 16),
            StoryCard(
              title: 'Level 5: Shopping',
              storySegments: [
                StorySegment('今日', 'きょう', 'Today'),
                StorySegment('は', null, null),
                StorySegment('買', 'か', 'Buy'),
                StorySegment('い', null, null),
                StorySegment('物', 'もの', 'Thing'),
                StorySegment('に', null, null),
                StorySegment('行', 'い', 'Go'),
                StorySegment('きました。', null, null),
                StorySegment('新', 'あたら', 'New'),
                StorySegment('しい', null, null),
                StorySegment('服', 'ふく', 'Clothes'),
                StorySegment('が', null, null),
                StorySegment('欲', 'ほ', 'Want'),
                StorySegment('しいです。', null, null),
                StorySegment('高', 'たか', 'Expensive'),
                StorySegment('いですね。', null, null),
                StorySegment('安', 'やす', 'Cheap'),
                StorySegment('いのをください。', null, null),
              ],
              vocabs: [
                StoryVocab('買い物', 'かいもの', 'Shopping'),
                StoryVocab('新しい', 'あたらしい', 'New'),
                StoryVocab('服', 'ふく', 'Clothes'),
                StoryVocab('欲しい', 'ほしい', 'Want'),
                StoryVocab('高い', 'たかい', 'Expensive'),
                StoryVocab('安い', 'やすい', 'Cheap'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoryCard extends StatefulWidget {
  final String title;
  final List<StorySegment> storySegments;
  final List<StoryVocab> vocabs;

  const StoryCard({
    super.key,
    required this.title,
    required this.storySegments,
    this.vocabs = const [],
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _showVocab = false;

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
            Text(widget.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                )),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 8,
              children: widget.storySegments.map((segment) {
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
                        color:
                            isKanji ? scheme.primary : scheme.onSurface,
                        fontWeight:
                            isKanji ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (widget.vocabs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(color: scheme.outlineVariant.withValues(alpha: 0.5)),
              InkWell(
                onTap: () => setState(() => _showVocab = !_showVocab),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        _showVocab
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 20,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Vocabulary (${widget.vocabs.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: widget.vocabs.map((v) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: scheme.tertiaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: v.word,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onTertiaryContainer,
                                ),
                              ),
                              TextSpan(
                                text: ' ${v.reading}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              TextSpan(
                                text: '\n${v.meaning}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                crossFadeState: _showVocab
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
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

class StoryVocab {
  final String word;
  final String reading;
  final String meaning;
  const StoryVocab(this.word, this.reading, this.meaning);
}
