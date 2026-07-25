import 'package:flutter/material.dart';
import 'package:fun_with_kanji/models/deck.dart';
import 'package:fun_with_kanji/pages/decks/deck_view.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

class DecksScreen extends StatefulWidget {
  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  List<Deck> _decks = [];

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final decks = await DeckManager.getDecks();
    setState(() {
      _decks = decks;
    });
  }

  void _addDeck() {
    String newDeckName = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Deck'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Deck Name'),
          onChanged: (value) => newDeckName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newDeckName.trim().isNotEmpty) {
                await DeckManager.addDeck(newDeckName.trim());
                if (mounted) {
                  Navigator.pop(context);
                  _loadDecks();
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: const Text('Custom Study Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create new deck',
            onPressed: _addDeck,
          )
        ],
      ),
      body: _decks.isEmpty
          ? const Center(child: Text('No custom decks yet. Create one!'))
          : ListView.builder(
              itemCount: _decks.length,
              itemBuilder: (context, index) {
                final deck = _decks[index];
                return ListTile(
                  title: Text(deck.name),
                  subtitle: Text('${deck.kanjiIds.length} Kanji'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error),
                    tooltip: 'Delete deck',
                    onPressed: () async {
                      await DeckManager.removeDeck(deck.id);
                      _loadDecks();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DeckViewScreen(deck: deck),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.08),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              )),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
