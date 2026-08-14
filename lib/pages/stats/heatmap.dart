import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class ActivityHeatmapWidget extends StatelessWidget {
  const ActivityHeatmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return M3FloatingCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '365-Day Study Activity',
                style: GoogleFonts.sawarabiMincho(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.local_fire_department, color: AppColors.primary, size: 18),
                  SizedBox(width: 4),
                  Text(
                    '7 Day Streak!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Heatmap Matrix Simulation Grid
          SizedBox(
            height: 110,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: 140, // 20 weeks of daily activity
              itemBuilder: (context, index) {
                // Generate realistic study intensity levels 0..4
                final level = (index * 7 + 3) % 5;
                Color cellColor;
                switch (level) {
                  case 0:
                    cellColor = isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05);
                    break;
                  case 1:
                    cellColor = AppColors.primary.withValues(alpha: 0.25);
                    break;
                  case 2:
                    cellColor = AppColors.primary.withValues(alpha: 0.50);
                    break;
                  case 3:
                    cellColor = AppColors.primary.withValues(alpha: 0.75);
                    break;
                  case 4:
                    cellColor = AppColors.primary;
                    break;
                  default:
                    cellColor = AppColors.primary;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less ', style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54)),
              Container(width: 8, height: 8, color: Colors.grey.withValues(alpha: 0.2)),
              const SizedBox(width: 2),
              Container(width: 8, height: 8, color: AppColors.primary.withValues(alpha: 0.4)),
              const SizedBox(width: 2),
              Container(width: 8, height: 8, color: AppColors.primary),
              const SizedBox(width: 2),
              Text(' More', style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
