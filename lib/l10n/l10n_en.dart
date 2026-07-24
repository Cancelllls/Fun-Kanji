// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get learn => 'Learn';

  @override
  String get overview => 'Overview';

  @override
  String get info => 'Info';

  @override
  String get settings => 'Settings';

  @override
  String get hiragana => 'Hiragana';

  @override
  String get katakana => 'Katakana';

  @override
  String get radicalsName => 'Radicals';

  @override
  String radicals(Object level) {
    return 'Radicals level $level';
  }

  @override
  String get kanji => 'Kanji';

  @override
  String kanjiPrimarySchoolClass(Object level) {
    return 'Kanji primary school class $level';
  }

  @override
  String kanjiMiddleSchoolClass(Object level) {
    return 'Kanji middle school level $level';
  }

  @override
  String countEntries(Object count) {
    return '$count entries';
  }

  @override
  String get meanings => 'Meanings:';

  @override
  String get onReadings => 'On readings:';

  @override
  String get kunReadings => 'Kun readings:';

  @override
  String get moreInfo => 'More info';

  @override
  String get learnJapaneseLetteringSystems => 'Learn Japanese Writing Systems';

  @override
  String get learnJapaneseLetteringSystemsDesc =>
      'We will learn three writing systems in this app:\n\n- Hiragana\n- Katakana\n- Kanji';

  @override
  String get hiraganaDesc =>
      'All starts with the 46 characters of Hiragana and their diagrephics and digraphs. Hiragana is a phonetic writing system which can be used to write all words in the Japanese language.';

  @override
  String get katakanaDesc =>
      'This is the other phonetic lettering system and is mostly used to write foreign-language words. For each Hiragana there is a Katakana counter part.';

  @override
  String get radicalsDesc =>
      'Kanji Radicals are graphemes, or graphical parts, that are used in organizing Japanese Kanji in dictionaries. They are derived from the 214 Chinese Kangxi radicals.\n\nEach Kanji is made of one or more Radicals. Just divide a Kanji into it`s Radicals and try to memorize a little story with them. This is the key to bring them into your long-term memory.';

  @override
  String get kanjiDesc =>
      'Japanese also uses Chinese characters which are called Kanji. This app lists the 2136 Jōyō-Kanji which are taught in Japanese schools. Kanji are not a phonetic lettering system. Each Kanji represents one or multiple words and has a On- and a Kun-reading.\n\nBut how should it be possible to learn so many characters? Don\'t worry! For this we have the Kanji Radicals.';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get resetLearningProgress => 'Reset learning progress';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get check => 'Check';

  @override
  String get enterRomaji => 'Enter Romaji';

  @override
  String get allStarsWon => 'All stars won';

  @override
  String get welcomeText =>
      'Welcome to Fun With Kanji. Together we will learn all Japanese characters you need to read texts in Japanese. It will be a long journey but we will do this step by step.';

  @override
  String get about => 'About';

  @override
  String get website => 'Website';

  @override
  String countIntroduced(Object count) {
    return '$count introduced';
  }

  @override
  String get importLearningProgress => 'Import learning progress';

  @override
  String get exportLearningProgress => 'Export learning progress';

  @override
  String savedAt(Object path) {
    return 'Saved at $path';
  }

  @override
  String get importFinished => 'Import finished';

  @override
  String get importFailed => 'Sorry... Import failed.';

  @override
  String get search => 'Search';

  @override
  String get oopsSomethignWentWrong => 'Oops... something went wrong!';

  @override
  String get errorDesc =>
      'An error has occurred. You can help fix it by reporting it.';

  @override
  String get report => 'Report';

  @override
  String get save => 'Save';

  @override
  String get addHint => 'Add hint';

  @override
  String get looksLikeAManWithAHat => 'Looks like a man with a hat';

  @override
  String get showHint => 'Show hint';

  @override
  String get readOutLoud => 'Read out loud';

  @override
  String get playSoundEffects => 'Play sound effects';

  @override
  String get style => 'Style';

  @override
  String get color => 'Color';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get close => 'Close';

  @override
  String get searchOnlineForSampleVocabulary =>
      'Search online for sample vocabulary';

  @override
  String get langPrefix => '';

  @override
  String nextLevelUpInHours(Object count) {
    return 'Next star after $count hours';
  }

  @override
  String get learnWithSpacedRepition => 'Learn with spaced repitition';

  @override
  String get enterKanjiAndKana => 'Enter kanji and kana';

  @override
  String get enterKanji => 'Enter kanji';
}
