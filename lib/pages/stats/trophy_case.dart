import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class BadgeItem {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final Color color;

  BadgeItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.color,
  });
}

class TrophyCaseScreen extends StatelessWidget {
  const TrophyCaseScreen({super.key});

  List<BadgeItem> _getBadges() {
    return [
      BadgeItem(
        title: 'First Step',
        description: 'Completed your first Kanji lesson',
        icon: Icons.school,
        isUnlocked: true,
        color: AppColors.primary,
      ),
      BadgeItem(
        title: 'Stroke Sensei',
        description: 'Achieved 100% accuracy in Calligraphy practice',
        icon: Icons.edit_note,
        isUnlocked: true,
        color: const Color(0xFF10B981),
      ),
      BadgeItem(
        title: 'N5 Apprentice',
        description: 'Studied 50 Beginner JLPT N5 Kanji',
        icon: Icons.star,
        isUnlocked: true,
        color: const Color(0xFFF59E0B),
      ),
      BadgeItem(
        title: 'SRS Guru',
        description: 'Advanced 20 Kanji to Guru status',
        icon: Icons.workspace_premium,
        isUnlocked: false,
        color: const Color(0xFF8B5CF6),
      ),
      BadgeItem(
        title: 'Memory Master',
        description: 'Completed Kanji Memory Match under 15 moves',
        icon: Icons.extension,
        isUnlocked: false,
        color: const Color(0xFFEC4899),
      ),
      BadgeItem(
        title: 'Exam Champion',
        description: 'Passed JLPT Mock Exam with 100% score',
        icon: Icons.emoji_events,
        isUnlocked: false,
        color: const Color(0xFFEF4444),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final badges = _getBadges();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Trophy Case & Badges',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return M3SpringPressable(
              onTap: () {},
              child: M3FloatingCard(
                padding: const EdgeInsets.all(16),
                glowColor: badge.isUnlocked
                    ? badge.color.withValues(alpha: 0.2)
                    : Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: badge.isUnlocked
                            ? badge.color.withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.icon,
                        size: 36,
                        color: badge.isUnlocked ? badge.color : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      badge.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sawarabiMincho(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: badge.isUnlocked
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
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
