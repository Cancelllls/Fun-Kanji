import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/pages/overview/kanji_list_tile.dart';
import 'package:fun_with_kanji/pages/overview/overview.dart';
import 'package:fun_with_kanji/pages/overview/overview_list_tile.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';
import 'package:fun_with_kanji/widgets/dynamic_background.dart';

class OverviewPageView extends StatelessWidget {
  final OverviewController controller;
  const OverviewPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final searchResult = controller.searchResult;
    final isSearching =
        controller.searchController.text.isNotEmpty || searchResult != null;

    return DynamicGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 12,
          title: Semantics(
            label: L10n.of(context)!.search,
            child: TextField(
              onChanged: controller.search,
              controller: controller.searchController,
              decoration: InputDecoration(
                filled: true,
                hintText: L10n.of(context)!.search,
                prefixIcon: controller.searchLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(Icons.search_outlined),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.cancelSearch,
                      )
                    : null,
              ),
            ),
          ),
        ),
        body: searchResult != null
            ? RefreshIndicator(
                onRefresh: () async =>
                    controller.search(controller.searchController.text),
                child: ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, i) => searchResult[i] is Kanji
                      ? KanjiListTile(
                          kanji: searchResult[i] as Kanji,
                          subtitle: L10n.of(context)!.kanji,
                          moreIcon: Icons.info_outlined,
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(searchResult[i].toString()),
                              ),
                            ),
                          ),
                          title: Text(searchResult[i].description),
                          subtitle:
                              Text(searchResult[i].runtimeType.toString()),
                        ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    controller.search(controller.searchController.text),
                child: ListView(
                  children: [
                    _buildRecentSearches(context),
                    ...WritingSystem.values
                      .map((writingSystem) => OverviewListTile(
                            onTap: () =>
                                controller.goToViewer(writingSystem),
                            writingSystem: writingSystem,
                            title: writingSystem.getTitle(context),
                          )),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: SearchHistory.getRecent(),
      builder: (context, snapshot) {
        final history = snapshot.data ?? [];
        if (history.isEmpty) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Recent',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => SearchHistory.clear(),
                    child: Text('Clear',
                        style: TextStyle(fontSize: 12, color: scheme.error)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: history.map((term) {
                  return ActionChip(
                    label: Text(term, style: const TextStyle(fontSize: 13)),
                    avatar: const Icon(Icons.search, size: 14),
                    onPressed: () {
                      controller.searchController.text = term;
                      controller.search(term);
                    },
                    backgroundColor:
                        scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchHistory {
  static const _key = 'search_history';

  static Future<List<String>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  static Future<void> add(String term) async {
    if (term.trim().isEmpty) return;
    final history = await getRecent();
    history.remove(term);
    history.insert(0, term);
    if (history.length > 8) history.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(history));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
