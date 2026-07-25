import 'package:flutter/material.dart';

import 'package:fun_with_kanji/l10n/l10n.dart';

import 'package:fun_with_kanji/models/kana.dart';
import 'package:fun_with_kanji/models/script_loader.dart';

class KatakanaViewer extends StatelessWidget {
  const KatakanaViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.katakana),
      ),
      body: FutureBuilder<List<Kana>>(
        future: ScriptLoader.loadKatakana(),
        builder: (context, snapshot) {
          final katakana = snapshot.data;
          if (katakana == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return ListView.builder(
            itemCount: katakana.length,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(katakana[i].kana),
                  ),
                ),
              ),
              title: Text(katakana[i].roumaji),
              subtitle: Text(katakana[i].type),
            ),
          );
        },
      ),
    );
  }
}
