import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/deck.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/pages/decks/deck_view.dart';
import 'package:fun_with_kanji/pages/learning/drawing_practice.dart';
import 'package:fun_with_kanji/pages/minigame/onyomi_kunyomi.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';
import 'package:google_fonts/google_fonts.dart';

class DecksScreen extends StatefulWidget {
  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0; // 0=N5, 1=N4, 2=N3, 3=N2, 4=N1, 5=Custom
  List<Deck> _customDecks = [];
  bool _loading = false;
  Map<int, List<Map<String, dynamic>>> _jlptPartsCache = {};

  final List<Map<String, dynamic>> _jlptLevels = [
    {'level': 5, 'label': 'N5', 'desc': 'Beginner (100 Kanji)', 'color': const Color(0xFF10B981)},
    {'level': 4, 'label': 'N4', 'desc': 'Elementary (300 Kanji)', 'color': const Color(0xFF3B82F6)},
    {'level': 3, 'label': 'N3', 'desc': 'Intermediate (650 Kanji)', 'color': const Color(0xFF8B5CF6)},
    {'level': 2, 'label': 'N2', 'desc': 'Pre-Advanced (1000 Kanji)', 'color': const Color(0xFFF59E0B)},
    {'level': 1, 'label': 'N1', 'desc': 'Advanced (2000 Kanji)', 'color': const Color(0xFFEF4444)},
    {'level': 0, 'label': 'Custom', 'desc': 'Your Decks', 'color': AppColors.primary},
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomDecks();
    _preloadJlptData();
  }

  Future<void> _loadCustomDecks() async {
    final decks = await DeckManager.getDecks();
    if (mounted) {
      setState(() {
        _customDecks = decks;
      });
    }
  }

  Future<void> _preloadJlptData() async {
    setState(() => _loading = true);
    final Map<int, List<Map<String, dynamic>>> cache = {};

    for (int lvl = 1; lvl <= 5; lvl++) {
      final partCount = ScriptLoader.getJlptPartCount(lvl);
      final List<Map<String, dynamic>> parts = [];
      for (int p = 1; p <= partCount; p++) {
        try {
          final kanjiList = await ScriptLoader.loadJlptKanji(lvl, p);
          parts.add({
            'part': p,
            'title': 'JLPT N$lvl • Part $p',
            'kanjiList': kanjiList,
            'kanjiCount': kanjiList.length,
            'previewChars': kanjiList.take(4).map((k) => k.kanji).toList(),
          });
        } catch (_) {}
      }
      cache[lvl] = parts;
    }

    if (mounted) {
      setState(() {
        _jlptPartsCache = cache;
        _loading = false;
      });
    }
  }

  void _showCreateDeckDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gradientDarkStart : AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.style,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Create Custom Deck',
                      style: GoogleFonts.sawarabiMincho(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Deck Name',
                    hintText: 'e.g., Daily Favorites, JLPT Review',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'e.g., Essential kanji for daily practice',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        await DeckManager.addDeck(
                          name,
                          description: descController.text.trim(),
                        );
                        if (mounted) {
                          Navigator.pop(context);
                          _loadCustomDecks();
                        }
                      }
                    },
                    child: const Text(
                      'Create Deck',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPracticeWriting(List<Kanji> kanjiList, String title) {
    if (kanjiList.isEmpty) return;
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => DrawingPracticeScreen(kanji: kanjiList.first.kanji),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _openQuiz(List<Kanji> kanjiList) {
    if (kanjiList.isEmpty) return;
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnyomiKunyomiMinigame(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Kanji Decks & JLPT',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.surface : AppColors.gradientDarkStart,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Create New Deck',
              color: primaryColor,
              onPressed: _showCreateDeckDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            // Level Selector Filter Pills
            SizedBox(
              height: 54,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _jlptLevels.length,
                itemBuilder: (context, index) {
                  final item = _jlptLevels[index];
                  final isSelected = _selectedTabIndex == index;
                  final color = item['color'] as Color;

                  return M3SpringPressable(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.05)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : Colors.grey.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Content Deck List / Grid
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _selectedTabIndex == 5
                      ? _buildCustomDecksList(isDark)
                      : _buildJlptDecksList(_selectedTabIndex + 1, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJlptDecksList(int tabIndex, bool isDark) {
    final jlptLevel = 6 - tabIndex;
    final parts = _jlptPartsCache[jlptLevel] ?? [];
    final levelMeta = _jlptLevels.firstWhere(
      (l) => l['level'] == jlptLevel,
      orElse: () => _jlptLevels[0],
    );
    final accentColor = levelMeta['color'] as Color;

    if (parts.isEmpty) {
      return Center(
        child: Text(
          'No JLPT N$jlptLevel decks loaded.',
          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: parts.length,
      itemBuilder: (context, index) {
        final partData = parts[index];
        final String title = partData['title'];
        final int kanjiCount = partData['kanjiCount'];
        final List<Kanji> kanjiList = partData['kanjiList'];
        final List<String> previewChars = partData['previewChars'];

        return M3SpringPressable(
          onTap: () {
            _openPracticeWriting(kanjiList, title);
          },
          child: M3FloatingCard(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            glowColor: accentColor.withValues(alpha: 0.15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'JLPT N$jlptLevel',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Part ${partData['part']}',
                          style: GoogleFonts.sawarabiMincho(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$kanjiCount Kanji',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Kanji Preview Badges
                Row(
                  children: [
                    ...previewChars.map(
                      (char) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            char,
                            style: GoogleFonts.sawarabiMincho(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: AppColors.primary),
                      tooltip: 'Practice Canvas',
                      onPressed: () => _openPracticeWriting(kanjiList, title),
                    ),
                    IconButton(
                      icon: const Icon(Icons.quiz_outlined, color: AppColors.secondary),
                      tooltip: 'Reading Quiz',
                      onPressed: () => _openQuiz(kanjiList),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomDecksList(bool isDark) {
    if (_customDecks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.style_outlined,
              size: 64,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            const SizedBox(height: 14),
            Text(
              'No Custom Decks Yet',
              style: GoogleFonts.sawarabiMincho(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap + button to build your personalized Kanji study deck!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _showCreateDeckDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create Custom Deck'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _customDecks.length,
      itemBuilder: (context, index) {
        final deck = _customDecks[index];
        return M3SpringPressable(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => DeckViewScreen(deck: deck),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ).then((_) => _loadCustomDecks());
          },
          child: M3FloatingCard(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            glowColor: AppColors.primary.withValues(alpha: 0.15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.style,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deck.name,
                        style: GoogleFonts.sawarabiMincho(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (deck.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          deck.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        '${deck.kanjiIds.length} Kanji',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  tooltip: 'Delete Deck',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Deck?'),
                        content: Text('Are you sure you want to delete "${deck.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await DeckManager.removeDeck(deck.id);
                      _loadCustomDecks();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
