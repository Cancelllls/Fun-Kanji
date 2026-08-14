import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';
import 'package:fun_with_kanji/widgets/theme_builder.dart';

class ThemeOption {
  final String name;
  final String description;
  final Color primaryColor;
  final Color accentColor;

  ThemeOption({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.accentColor,
  });
}

class ThemePickerScreen extends StatelessWidget {
  const ThemePickerScreen({super.key});

  List<ThemeOption> _getThemes() {
    return [
      ThemeOption(
        name: 'Minimalist Zen (Sakura)',
        description: 'Cherry Blossom Pink & Matte Slate',
        primaryColor: AppColors.primary,
        accentColor: AppColors.secondary,
      ),
      ThemeOption(
        name: 'Bamboo Forest',
        description: 'Emerald Green & Bamboo Charcoal',
        primaryColor: const Color(0xFF10B981),
        accentColor: const Color(0xFF065F46),
      ),
      ThemeOption(
        name: 'Cyber Neon',
        description: 'Electric Violet & Solar Gold',
        primaryColor: const Color(0xFF8B5CF6),
        accentColor: const Color(0xFFF59E0B),
      ),
      ThemeOption(
        name: 'Monochrome Slate',
        description: 'Deep Charcoal & Zen Cream',
        primaryColor: const Color(0xFF475569),
        accentColor: const Color(0xFF0F172A),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themes = _getThemes();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Theme Palette Switcher',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: themes.length,
          itemBuilder: (context, index) {
            final theme = themes[index];
            return M3SpringPressable(
              onTap: () {
                ThemeController.of(context).setPrimaryColor(theme.primaryColor);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Switched to ${theme.name}')),
                );
              },
              child: M3FloatingCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                glowColor: theme.primaryColor.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.primaryColor, theme.accentColor],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            theme.name,
                            style: GoogleFonts.sawarabiMincho(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            theme.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_outline, color: AppColors.primary),
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
