import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';
import 'package:fun_with_kanji/widgets/m3_glassmorphism.dart';

class JukugoItem {
  final String jukugo;
  final String furigana;
  final String meaning;
  final List<String> kanjiParts;

  JukugoItem({
    required this.jukugo,
    required this.furigana,
    required this.meaning,
    required this.kanjiParts,
  });
}

class JukugoBuilderScreen extends StatefulWidget {
  const JukugoBuilderScreen({super.key});

  @override
  State<JukugoBuilderScreen> createState() => _JukugoBuilderScreenState();
}

class _JukugoBuilderScreenState extends State<JukugoBuilderScreen> {
  final List<JukugoItem> _sampleJukugo = [
    JukugoItem(
      jukugo: '日本語',
      furigana: 'にほんご',
      meaning: 'Japanese Language',
      kanjiParts: ['日', '本', '語'],
    ),
    JukugoItem(
      jukugo: '大学',
      furigana: 'だいがく',
      meaning: 'University',
      kanjiParts: ['大', '学'],
    ),
    JukugoItem(
      jukugo: '電車',
      furigana: 'でんしゃ',
      meaning: 'Electric Train',
      kanjiParts: ['電', '車'],
    ),
    JukugoItem(
      jukugo: '勉強',
      furigana: 'べんきょう',
      meaning: 'Study / Practice',
      kanjiParts: ['勉', '強'],
    ),
  ];

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
            'Compound Word Builder (熟語)',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _sampleJukugo.length,
          itemBuilder: (context, index) {
            final item = _sampleJukugo[index];
            return M3SpringPressable(
              onTap: () {},
              child: M3GlassCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.jukugo,
                          style: GoogleFonts.yujiSyuku(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.furigana,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.meaning,
                      style: GoogleFonts.sawarabiMincho(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: item.kanjiParts.map((k) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            k,
                            style: GoogleFonts.yujiSyuku(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
