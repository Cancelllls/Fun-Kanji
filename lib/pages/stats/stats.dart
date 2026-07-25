import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/utils/achievement_manager.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Map<String, int> _progress = {};
  int _totalMastered = 0;
  int _totalCharacters = 0;
  int _achievementCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final progress = <String, int>{};
    int mastered = 0;
    int total = 0;
    for (final system in WritingSystem.values) {
      final finished =
          await FunWithKanji.of(context).getFinishedCount(system);
      final pct = await FunWithKanji.of(context).loadProgressPercent(system);
      progress[system.name] = pct;
      mastered += finished;
      total += system.entries;
    }
    final achievementCount = await AchievementManager.totalUnlocked();
    if (mounted) {
      setState(() {
        _progress = progress;
        _totalMastered = mastered;
        _totalCharacters = total;
        _achievementCount = achievementCount;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortedSystems = WritingSystem.values.toList()
      ..sort((a, b) => (_progress[b.name] ?? 0).compareTo(_progress[a.name] ?? 0));

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Stats'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : RefreshIndicator(
                onRefresh: _loadStats,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildSummary(scheme),
                    const SizedBox(height: 16),
                    Text('Progress by System',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        )),
                    const SizedBox(height: 12),
                    ...sortedSystems.map((s) => _buildProgressRow(scheme, s)),
                    const SizedBox(height: 24),
                    _buildAchievements(scheme),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummary(ColorScheme scheme) {
    final pct = _totalCharacters > 0
        ? (_totalMastered / _totalCharacters * 100).round()
        : 0;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.tertiary, size: 32),
                  const SizedBox(height: 8),
                  Text('$_totalMastered',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface)),
                  Text('Mastered',
                      style: TextStyle(
                          fontSize: 13, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome,
                      color: AppColors.starColor, size: 32),
                  const SizedBox(height: 8),
                  Text('$pct%',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface)),
                  Text('Complete',
                      style: TextStyle(
                          fontSize: 13, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events,
                      color: AppColors.confettiPink, size: 32),
                  const SizedBox(height: 8),
                  Text('$_achievementCount',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface)),
                  Text('Badges',
                      style: TextStyle(
                          fontSize: 13, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(ColorScheme scheme, WritingSystem system) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(system.getTitle(context), style: TextStyle(fontSize: 14, color: scheme.onSurface))),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_progress[system.name] ?? 0) / 100,
                minHeight: 10,
                backgroundColor: scheme.surfaceContainerHighest,
                color: AppColors.tertiary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text('${_progress[system.name] ?? 0}%',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(ColorScheme scheme) {
    return FutureBuilder<Set<Achievement>>(
      future: AchievementManager.getUnlocked(),
      builder: (context, snapshot) {
        final unlocked = snapshot.data ?? {};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                )),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AchievementManager.all.map((data) {
                final isUnlocked = unlocked.contains(data.id);
                return Container(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? data.color.withValues(alpha: 0.1)
                        : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: isUnlocked
                        ? Border.all(
                            color: data.color.withValues(alpha: 0.3))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        data.icon,
                        color: isUnlocked
                            ? data.color
                            : scheme.onSurfaceVariant.withValues(alpha: 0.3),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Icon(Icons.check_circle, color: AppColors.tertiary, size: 32),
                            Text(data.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isUnlocked
                                      ? scheme.onSurface
                                      : scheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                )),
                            Text(data.description,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onSurfaceVariant
                                      .withValues(alpha: isUnlocked ? 0.7 : 0.3),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
