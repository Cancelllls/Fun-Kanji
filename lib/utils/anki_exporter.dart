import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fun_with_kanji/models/deck.dart';

class AnkiExporter {
  static String exportDeckToAnkiJson(Deck deck) {
    final List<Map<String, String>> notes = deck.kanjiIds.map((k) {
      return {
        'front': k,
        'back': 'Kanji character $k from ${deck.name}',
      };
    }).toList();

    final Map<String, dynamic> ankiPackage = {
      'generator': 'Fun Kanji Anki Exporter',
      'deckName': deck.name,
      'notes': notes,
    };
    return jsonEncode(ankiPackage);
  }

  static void showAnkiExportModal(BuildContext context, Deck deck) {
    final jsonPayload = exportDeckToAnkiJson(deck);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Anki Deck: ${deck.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anki-formatted payload for Anki Desktop / AnkiMobile sync:',
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
                jsonPayload,
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
