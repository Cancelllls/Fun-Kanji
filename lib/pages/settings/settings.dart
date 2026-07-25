import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fun_with_kanji/config/app_constants.dart';
import 'package:fun_with_kanji/models/fun_with_kanji.dart';
import 'package:fun_with_kanji/pages/settings/settings_view.dart';
import 'package:fun_with_kanji/utils/open_issue_dialog.dart';
import 'package:fun_with_kanji/utils/theme_mode_localization.dart';
import 'package:fun_with_kanji/widgets/theme_builder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsController createState() => SettingsController();
}

class SettingsController extends State<SettingsPage> {
  late final Future<SharedPreferences> preferencesFuture;

  @override
  void initState() {
    preferencesFuture = SharedPreferences.getInstance();
    super.initState();
  }

  void resetLearningProgressAction() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.areYouSure),
        content: Text(L10n.of(context)!.resetLearningProgress),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop<bool>(false),
            child: Text(
              L10n.of(context)!.cancel,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop<bool>(true),
            child: Text(
              L10n.of(context)!.reset,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (result != true) return;
    await FunWithKanji.of(context).resetLearningProgress();
  }

  void openWebsite() => launchUrlString(AppConstants.website);

  void displayAboutDialog() => showAboutDialog(
        context: context,
        applicationName: AppConstants.appName,
        children: [
          const Text('Developer: Antigravity User'),
          const SizedBox(height: 16),
          const Text('Huge thanks and credit to the original Fun with Kanji developer for creating the foundation of this app!'),
        ],
      );

  void exportAction() async {
    try {
      final export = await FunWithKanji.of(context).export();
      final exportStr = await compute(jsonEncode, export);
      final name =
          'fun_with_kanji_export_${DateTime.now().toIso8601String()}.json';

      FlutterFileSaver().writeFileAsString(
        fileName: name,
        data: exportStr,
      );
    } catch (e, s) {
      showOpenIssueDialog(context, e, s);
      rethrow;
    }
  }

  void importAction() async {
    final picked = await FilePicker.pickFiles(
      allowedExtensions: ['json'],
      withData: true,
      type: FileType.custom,
    );
    final file = picked?.files.first;
    if (file == null) return;
    try {
      final jsonStr = String.fromCharCodes(file.bytes!);
      final json = await compute(jsonDecode, jsonStr);
      await FunWithKanji.of(context).import(Map<String, dynamic>.from(json));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L10n.of(context)!.importFinished),
      ));
    } catch (e, s) {
      showOpenIssueDialog(context, e, s);
      rethrow;
    }
  }

  void setThemeMode() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.style),
        content: StatefulBuilder(builder: (context, setState) {
          final groupValue = ThemeController.of(context).themeMode;
          // ignore: prefer_function_declarations_over_variables
          final onChanged = (val) {
            setState(() {
              ThemeController.of(context).setThemeMode(val);
            });
          };
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(ThemeMode.system.toLocalizedString(context)),
                trailing: groupValue == ThemeMode.system ? const Icon(Icons.check) : null,
                onTap: () => onChanged(ThemeMode.system),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(ThemeMode.light.toLocalizedString(context)),
                trailing: groupValue == ThemeMode.light ? const Icon(Icons.check) : null,
                onTap: () => onChanged(ThemeMode.light),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(ThemeMode.dark.toLocalizedString(context)),
                trailing: groupValue == ThemeMode.dark ? const Icon(Icons.check) : null,
                onTap: () => onChanged(ThemeMode.dark),
              ),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(L10n.of(context)!.close),
          ),
        ],
      ),
    );
    setState(() {});
  }

  void setColor() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.color),
        content: StatefulBuilder(builder: (context, setState) {
          final groupValue = ThemeController.of(context).primaryColor;
          // ignore: prefer_function_declarations_over_variables
          final onChanged = (val) {
            setState(() {
              ThemeController.of(context).setPrimaryColor(val);
            });
          };
          const colors = [
            null,
            AppConstants.fallbackPrimaryColor,
            Color(0xFF1565C0),
            Color(0xFF2E7D32),
            Color(0xFFE65100),
            Color(0xFFC62828),
            Color(0xFFAD1457),
            Color(0xFF00695C),
          ];
          return SizedBox(
            height: 360,
            width: 360,
            child: ListView(
              children: colors
                  .map((color) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: color == null
                            ? Text(L10n.of(context)!.system)
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.circle, color: color),
                              ),
                        trailing: groupValue == color ? const Icon(Icons.check) : null,
                        onTap: () => onChanged(color),
                      ))
                  .toList(),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(L10n.of(context)!.close),
          ),
        ],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SettingsView(this);
}
