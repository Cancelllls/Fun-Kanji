import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kana.dart';
import 'package:fun_with_kanji/models/script_loader.dart';
import 'package:fun_with_kanji/pages/learning/drawing_practice.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';
import 'package:fun_with_kanji/widgets/m3_expressive_motion.dart';

class KanaPracticeScreen extends StatefulWidget {
  const KanaPracticeScreen({super.key});

  @override
  State<KanaPracticeScreen> createState() => _KanaPracticeScreenState();
}

class _KanaPracticeScreenState extends State<KanaPracticeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Kana> _hiragana = [];
  List<Kana> _katakana = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadKana();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadKana() async {
    setState(() => _loading = true);
    final h = await ScriptLoader.loadHiragana();
    final k = await ScriptLoader.loadKatakana();

    if (mounted) {
      setState(() {
        _hiragana = h;
        _katakana = k;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Kana Syllabary (あ & ア)',
            style: GoogleFonts.sawarabiMincho(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Hiragana (あ)'),
              Tab(text: 'Katakana (ア)'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildKanaGrid(_hiragana),
                  _buildKanaGrid(_katakana),
                ],
              ),
      ),
    );
  }

  Widget _buildKanaGrid(List<Kana> kanaList) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: kanaList.length,
      itemBuilder: (context, index) {
        final kana = kanaList[index];
        return M3SpringPressable(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DrawingPracticeScreen(kanji: kana.kana),
              ),
            );
          },
          child: M3FloatingCard(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kana.kana,
                  style: GoogleFonts.yujiSyuku(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kana.romaji,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
