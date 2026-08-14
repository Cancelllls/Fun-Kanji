import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';
import 'package:fun_with_kanji/widgets/m3_glassmorphism.dart';

class KanjiMnemonicViewerScreen extends StatelessWidget {
  final Kanji kanji;

  const KanjiMnemonicViewerScreen({super.key, required this.kanji});

  String _generateMnemonicStory() {
    if (kanji.meanings.isEmpty) return 'A visual memory hook character.';
    final meaning = kanji.meanings.first;
    return 'Picture the character "${kanji.kanji}" as a memory hook for "$meaning". Notice how its strokes flow together to form the visual concept of $meaning.';
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
            'Kanji Mnemonic Story',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              M3GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      kanji.kanji,
                      style: GoogleFonts.yujiSyuku(
                        fontSize: 110,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      kanji.meanings.join(', '),
                      style: GoogleFonts.sawarabiMincho(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              M3FloatingCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          'Visual Memory Hook',
                          style: GoogleFonts.sawarabiMincho(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _generateMnemonicStory(),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
