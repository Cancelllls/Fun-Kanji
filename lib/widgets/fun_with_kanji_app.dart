import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_with_kanji/config/app_constants.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/pages/home/home_layout.dart';
import 'package:fun_with_kanji/pages/tutorial/tutorial.dart';
import 'package:fun_with_kanji/utils/theme_data_builder.dart';
import 'package:fun_with_kanji/widgets/theme_builder.dart';

class FunWithKanjiApp extends StatelessWidget {
  final Isar isar;
  const FunWithKanjiApp({required this.isar, super.key});

  @override
  Widget build(BuildContext context) => ThemeBuilder(
      builder: (context, themeMode, primaryColor) => DynamicColorBuilder(
            builder: (light, dark) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(light, primaryColor, true),
              darkTheme: buildTheme(dark, primaryColor, false),
              themeMode: themeMode,
              title: AppConstants.appName,
              home: _TutorialGate(isar: isar),
              localizationsDelegates: L10n.localizationsDelegates,
              supportedLocales: L10n.supportedLocales,
              builder: FunWithKanji(isar).builder,
            ),
          ));
}

class _TutorialGate extends StatefulWidget {
  final Isar isar;
  const _TutorialGate({required this.isar});

  @override
  State<_TutorialGate> createState() => _TutorialGateState();
}

class _TutorialGateState extends State<_TutorialGate> {
  bool _loading = true;
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('tutorial_seen') ?? false;
    if (mounted) {
      setState(() {
        _showTutorial = !seen;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (_showTutorial) {
      return TutorialPage(
        onComplete: () {
          if (mounted) setState(() => _showTutorial = false);
        },
      );
    }
    return const HomeLayout();
  }
}
