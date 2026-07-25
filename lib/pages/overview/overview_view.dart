import 'package:flutter/material.dart';

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
            ),
          ),
        ),
      ),
      body: searchResult != null
          ? RefreshIndicator(
              onRefresh: () async => controller.search(controller.searchController.text),
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
                          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                        subtitle: Text(searchResult[i].runtimeType.toString()),
                      ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => controller.search(controller.searchController.text),
              child: ListView(
                children: WritingSystem.values
                    .map((writingSystem) => OverviewListTile(
                          onTap: () => controller.goToViewer(writingSystem),
                          writingSystem: writingSystem,
                          title: writingSystem.getTitle(context),
                        ))
                    .toList(),
              ),
            ),
      ),
    );
  }
}
