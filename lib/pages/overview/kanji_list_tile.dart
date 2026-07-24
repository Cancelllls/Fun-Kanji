import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_with_kanji/pages/learning/drawing_practice.dart';

import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/deck.dart';

class KanjiListTile extends StatelessWidget {
  final Kanji kanji;
  final String? subtitle;
  final IconData? moreIcon;
  const KanjiListTile({
    required this.kanji,
    this.subtitle,
    this.moreIcon,
    super.key,
  });

  void showInfo(Kanji kanji, BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
              child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    kanji.kanji,
                    style: GoogleFonts.yujiSyuku(textStyle: const TextStyle(fontSize: 60)),
                  ))),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(L10n.of(context)!.meanings),
                  subtitle: Text(kanji.meanings.join(', ')),
                ),
                ListTile(
                  title: Text(L10n.of(context)!.onReadings),
                  subtitle: Text(kanji.readingsOn.join(', ')),
                ),
                ListTile(
                  title: Text(L10n.of(context)!.kunReadings),
                  subtitle: Text(kanji.readingsKun.join(', ')),
                ),
                ListTile(
                  title: Text('${L10n.of(context)!.radicalsName}:'),
                  subtitle: Text(kanji.radicals.join(', ')),
                ),
                if (kanji.vocabs.isNotEmpty) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Example Vocabulary:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  ),
                  ...kanji.vocabs.map((vocab) => ListTile(
                    title: Text('${vocab.word} (${vocab.furigana})'),
                    subtitle: Text(vocab.translation.join(', ')),
                  )),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDecksDialog(context, kanji);
              },
              child: const Text('Add to Deck'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DrawingPracticeScreen(kanji: kanji.kanji)),
                );
              },
              child: const Text('Draw Practice'),
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        ),
      );

  void _showDecksDialog(BuildContext context, Kanji kanji) async {
    final decks = await DeckManager.getDecks();
    if (!context.mounted) return;
    if (decks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No custom decks exist. Create one from the Home Screen first!')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Deck'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              return ListTile(
                title: Text(deck.name),
                onTap: () async {
                  await DeckManager.addKanjiToDeck(deck.id, kanji.kanji);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${kanji.kanji} to ${deck.name}')),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: ListTile(
            leading: CircleAvatar(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              backgroundColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
              child: SizedBox(
                width: 32,
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(kanji.kanji),
                ),
              ),
            ),
            title: Text(kanji.meanings.join(', '), style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle ?? L10n.of(context)!.moreInfo),
            trailing: Icon(moreIcon ?? Icons.arrow_right_outlined),
            onTap: () => showInfo(kanji, context),
          ),
        ),
      ),
    );
  }
}
