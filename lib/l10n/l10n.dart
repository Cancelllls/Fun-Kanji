import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de')
  ];

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @hiragana.
  ///
  /// In en, this message translates to:
  /// **'Hiragana'**
  String get hiragana;

  /// No description provided for @katakana.
  ///
  /// In en, this message translates to:
  /// **'Katakana'**
  String get katakana;

  /// No description provided for @radicalsName.
  ///
  /// In en, this message translates to:
  /// **'Radicals'**
  String get radicalsName;

  /// No description provided for @radicals.
  ///
  /// In en, this message translates to:
  /// **'Radicals level {level}'**
  String radicals(Object level);

  /// No description provided for @kanji.
  ///
  /// In en, this message translates to:
  /// **'Kanji'**
  String get kanji;

  /// No description provided for @kanjiPrimarySchoolClass.
  ///
  /// In en, this message translates to:
  /// **'Kanji primary school class {level}'**
  String kanjiPrimarySchoolClass(Object level);

  /// No description provided for @kanjiMiddleSchoolClass.
  ///
  /// In en, this message translates to:
  /// **'Kanji middle school level {level}'**
  String kanjiMiddleSchoolClass(Object level);

  /// No description provided for @countEntries.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String countEntries(Object count);

  /// No description provided for @meanings.
  ///
  /// In en, this message translates to:
  /// **'Meanings:'**
  String get meanings;

  /// No description provided for @onReadings.
  ///
  /// In en, this message translates to:
  /// **'On readings:'**
  String get onReadings;

  /// No description provided for @kunReadings.
  ///
  /// In en, this message translates to:
  /// **'Kun readings:'**
  String get kunReadings;

  /// No description provided for @moreInfo.
  ///
  /// In en, this message translates to:
  /// **'More info'**
  String get moreInfo;

  /// No description provided for @learnJapaneseLetteringSystems.
  ///
  /// In en, this message translates to:
  /// **'Learn Japanese Writing Systems'**
  String get learnJapaneseLetteringSystems;

  /// No description provided for @learnJapaneseLetteringSystemsDesc.
  ///
  /// In en, this message translates to:
  /// **'We will learn three writing systems in this app:\n\n- Hiragana\n- Katakana\n- Kanji'**
  String get learnJapaneseLetteringSystemsDesc;

  /// No description provided for @hiraganaDesc.
  ///
  /// In en, this message translates to:
  /// **'All starts with the 46 characters of Hiragana and their diagrephics and digraphs. Hiragana is a phonetic writing system which can be used to write all words in the Japanese language.'**
  String get hiraganaDesc;

  /// No description provided for @katakanaDesc.
  ///
  /// In en, this message translates to:
  /// **'This is the other phonetic lettering system and is mostly used to write foreign-language words. For each Hiragana there is a Katakana counter part.'**
  String get katakanaDesc;

  /// No description provided for @radicalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Kanji Radicals are graphemes, or graphical parts, that are used in organizing Japanese Kanji in dictionaries. They are derived from the 214 Chinese Kangxi radicals.\n\nEach Kanji is made of one or more Radicals. Just divide a Kanji into it`s Radicals and try to memorize a little story with them. This is the key to bring them into your long-term memory.'**
  String get radicalsDesc;

  /// No description provided for @kanjiDesc.
  ///
  /// In en, this message translates to:
  /// **'Japanese also uses Chinese characters which are called Kanji. This app lists the 2136 Jōyō-Kanji which are taught in Japanese schools. Kanji are not a phonetic lettering system. Each Kanji represents one or multiple words and has a On- and a Kun-reading.\n\nBut how should it be possible to learn so many characters? Don\'t worry! For this we have the Kanji Radicals.'**
  String get kanjiDesc;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @resetLearningProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset learning progress'**
  String get resetLearningProgress;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @enterRomaji.
  ///
  /// In en, this message translates to:
  /// **'Enter Romaji'**
  String get enterRomaji;

  /// No description provided for @allStarsWon.
  ///
  /// In en, this message translates to:
  /// **'All stars won'**
  String get allStarsWon;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Fun With Kanji. Together we will learn all Japanese characters you need to read texts in Japanese. It will be a long journey but we will do this step by step.'**
  String get welcomeText;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @countIntroduced.
  ///
  /// In en, this message translates to:
  /// **'{count} introduced'**
  String countIntroduced(Object count);

  /// No description provided for @importLearningProgress.
  ///
  /// In en, this message translates to:
  /// **'Import learning progress'**
  String get importLearningProgress;

  /// No description provided for @exportLearningProgress.
  ///
  /// In en, this message translates to:
  /// **'Export learning progress'**
  String get exportLearningProgress;

  /// No description provided for @savedAt.
  ///
  /// In en, this message translates to:
  /// **'Saved at {path}'**
  String savedAt(Object path);

  /// No description provided for @importFinished.
  ///
  /// In en, this message translates to:
  /// **'Import finished'**
  String get importFinished;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Sorry... Import failed.'**
  String get importFailed;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @oopsSomethignWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops... something went wrong!'**
  String get oopsSomethignWentWrong;

  /// No description provided for @errorDesc.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred. You can help fix it by reporting it.'**
  String get errorDesc;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @addHint.
  ///
  /// In en, this message translates to:
  /// **'Add hint'**
  String get addHint;

  /// No description provided for @looksLikeAManWithAHat.
  ///
  /// In en, this message translates to:
  /// **'Looks like a man with a hat'**
  String get looksLikeAManWithAHat;

  /// No description provided for @showHint.
  ///
  /// In en, this message translates to:
  /// **'Show hint'**
  String get showHint;

  /// No description provided for @readOutLoud.
  ///
  /// In en, this message translates to:
  /// **'Read out loud'**
  String get readOutLoud;

  /// No description provided for @playSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Play sound effects'**
  String get playSoundEffects;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchOnlineForSampleVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Search online for sample vocabulary'**
  String get searchOnlineForSampleVocabulary;

  /// No description provided for @langPrefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get langPrefix;

  /// No description provided for @nextLevelUpInHours.
  ///
  /// In en, this message translates to:
  /// **'Next star after {count} hours'**
  String nextLevelUpInHours(Object count);

  /// No description provided for @learnWithSpacedRepition.
  ///
  /// In en, this message translates to:
  /// **'Learn with spaced repitition'**
  String get learnWithSpacedRepition;

  /// No description provided for @enterKanjiAndKana.
  ///
  /// In en, this message translates to:
  /// **'Enter kanji and kana'**
  String get enterKanjiAndKana;

  /// No description provided for @enterKanji.
  ///
  /// In en, this message translates to:
  /// **'Enter kanji'**
  String get enterKanji;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return L10nDe();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
