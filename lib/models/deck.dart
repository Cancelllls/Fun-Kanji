import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Deck {
  final String id;
  final String name;
  final List<String> kanjiIds;

  Deck({required this.id, required this.name, this.kanjiIds = const []});

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      name: json['name'],
      kanjiIds: List<String>.from(json['kanjiIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kanjiIds': kanjiIds,
    };
  }
}

class DeckManager {
  static const String _decksKey = 'custom_decks';

  static Future<List<Deck>> getDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? decksJson = prefs.getString(_decksKey);
    if (decksJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(decksJson);
    return decoded.map((e) => Deck.fromJson(e)).toList();
  }

  static Future<void> saveDecks(List<Deck> decks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(decks.map((e) => e.toJson()).toList());
    await prefs.setString(_decksKey, encoded);
  }

  static Future<void> addDeck(String name) async {
    final decks = await getDecks();
    decks.add(Deck(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name));
    await saveDecks(decks);
  }

  static Future<void> addKanjiToDeck(String deckId, String kanji) async {
    final decks = await getDecks();
    final deckIndex = decks.indexWhere((d) => d.id == deckId);
    if (deckIndex != -1) {
      final deck = decks[deckIndex];
      if (!deck.kanjiIds.contains(kanji)) {
        final updatedKanjiIds = List<String>.from(deck.kanjiIds)..add(kanji);
        decks[deckIndex] = Deck(id: deck.id, name: deck.name, kanjiIds: updatedKanjiIds);
        await saveDecks(decks);
      }
    }
  }

  static Future<void> removeDeck(String deckId) async {
    final decks = await getDecks();
    decks.removeWhere((d) => d.id == deckId);
    await saveDecks(decks);
  }
}
