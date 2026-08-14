import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:fun_with_kanji/l10n/l10n.dart';

import 'package:fun_with_kanji/models/kana.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/radical.dart';

abstract class ScriptLoader {
  static Future<List<Kana>> loadHiragana() async {
    final jsonString = await rootBundle.loadString('assets/data/hiragana.json');
    return _convertToKana(jsonString);
  }

  static Future<List<Kana>> loadKatakana() async {
    final jsonString = await rootBundle.loadString('assets/data/katakana.json');
    return _convertToKana(jsonString);
  }

  static Future<List<Radical>> loadRadicals(
      BuildContext context, int level) async {
    final language = L10n.of(context)!.langPrefix;
    final jsonString = await rootBundle
        .loadString('assets/data/radicals${language}_$level.json');
    return _convertToRadicals(jsonString);
  }

  static Future<List<Kanji>> loadKanji(int level, BuildContext context) async {
    final language = L10n.of(context)!.langPrefix;

    if (level < 1 || level > 9) throw ('Level must be one of 1-9');
    final jsonString =
        await rootBundle.loadString('assets/data/kanji_$level$language.json');
    return _convertToKanji(jsonString);
  }

  static int getJlptPartCount(int nLevel) {
    switch (nLevel) {
      case 5:
        return 2;
      case 4:
        return 4;
      case 3:
        return 8;
      case 2:
        return 8;
      case 1:
        return 24;
      default:
        return 1;
    }
  }

  static Future<List<Kanji>> loadJlptKanji(int nLevel, int part) async {
    final jsonString =
        await rootBundle.loadString('assets/data/kanji_jlpt_n_${nLevel}_$part.json');
    return _convertToKanji(jsonString);
  }

  static Future<List<Kanji>> loadAllJlptLevel(int nLevel) async {
    final int partCount = getJlptPartCount(nLevel);
    final List<Kanji> all = [];
    for (int p = 1; p <= partCount; p++) {
      try {
        all.addAll(await loadJlptKanji(nLevel, p));
      } catch (_) {}
    }
    return all;
  }

  static Future<List<Kana>> _convertToKana(String json) async {
    final list = jsonDecode(json) as List;
    return list.map((j) => Kana.fromJson(Map<String, dynamic>.from(j))).toList();
  }

  static Future<List<Radical>> _convertToRadicals(String json) async {
    final list = jsonDecode(json) as List;
    return list.map((j) => Radical.fromJson(Map<String, dynamic>.from(j))).toList();
  }

  static Future<List<Kanji>> _convertToKanji(String json) async {
    final list = jsonDecode(json) as List;
    return list.map((j) => Kanji.fromJson(Map<String, dynamic>.from(j))).toList();
  }
}
