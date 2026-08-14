import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fun_with_kanji/models/deck.dart';

class DeckIO {
  static String exportDeckToJson(Deck deck) {
    final Map<String, dynamic> data = {
      'app': 'Fun Kanji',
      'version': '1.0.0',
      'deck': deck.toJson(),
    };
    return jsonEncode(data);
  }

  static Future<Deck?> importDeckFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      if (decoded.containsKey('deck')) {
        final deckMap = Map<String, dynamic>.from(decoded['deck']);
        final deck = Deck.fromJson(deckMap);
        await DeckManager.addDeck(
          deck.name,
          description: deck.description,
          jlptLevel: deck.jlptLevel,
          colorHex: deck.colorHex,
        );

        // Add kanji items
        for (var k in deck.kanjiIds) {
          await DeckManager.addKanjiToDeck(deck.id, k);
        }
        return deck;
      }
    } catch (_) {}
    return null;
  }

  static void showExportDialog(BuildContext context, Deck deck) {
    final jsonStr = exportDeckToJson(deck);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Deck: ${deck.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Copy this JSON code to share your custom deck with friends or backup:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                jsonStr,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
