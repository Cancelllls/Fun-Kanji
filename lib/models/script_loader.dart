import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:fun_with_kanji/models/kana.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/radical.dart';

abstract class ScriptLoader {
  static final Map<String, dynamic> _cache = {};

  static Future<List<Kana>> loadHiragana() async {
    const key = 'hiragana';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Kana>;
    }
    final jsonString = await rootBundle.loadString('assets/data/hiragana.json');
    final result = await _convertToKana(jsonString);
    _cache[key] = result;
    return result;
  }

  static Future<List<Kana>> loadKatakana() async {
    const key = 'katakana';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Kana>;
    }
    final jsonString = await rootBundle.loadString('assets/data/katakana.json');
    final result = await _convertToKana(jsonString);
    _cache[key] = result;
    return result;
  }

  static Future<List<Radical>> loadRadicals(
      BuildContext context, int level) async {
    final language = L10n.of(context)!.langPrefix;
    final key = 'radicals_${language}_$level';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Radical>;
    }
    final jsonString = await rootBundle
        .loadString('assets/data/radicals${language}_$level.json');
    final result = await _convertToRadicals(jsonString);
    _cache[key] = result;
    return result;
  }

  static Future<List<Kanji>> loadKanji(int level, BuildContext context) async {
    final language = L10n.of(context)!.langPrefix;
    final key = 'kanji_${language}_$level';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Kanji>;
    }

    if (level < 1 || level > 9) throw ('Level must be one of 1-9');
    final jsonString =
        await rootBundle.loadString('assets/data/kanji_$level$language.json');
    final result = await _convertToKanji(jsonString);
    _cache[key] = result;
    return result;
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
    final key = 'jlpt_n_${nLevel}_$part';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Kanji>;
    }
    final jsonString =
        await rootBundle.loadString('assets/data/kanji_jlpt_n_${nLevel}_$part.json');
    final result = await _convertToKanji(jsonString);
    _cache[key] = result;
    return result;
  }

  static Future<List<Kanji>> loadAllJlptLevel(int nLevel) async {
    final key = 'jlpt_all_level_$nLevel';
    if (_cache.containsKey(key)) {
      return _cache[key] as List<Kanji>;
    }
    final int partCount = getJlptPartCount(nLevel);
    final List<Kanji> all = [];
    for (int p = 1; p <= partCount; p++) {
      try {
        all.addAll(await loadJlptKanji(nLevel, p));
      } catch (_) {}
    }
    _cache[key] = all;
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
