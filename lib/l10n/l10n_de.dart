// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get learn => 'Lernen';

  @override
  String get overview => 'Überblick';

  @override
  String get info => 'Info';

  @override
  String get settings => 'Einstellungen';

  @override
  String get hiragana => 'Hiragana';

  @override
  String get katakana => 'Katakana';

  @override
  String get radicalsName => 'Radicals';

  @override
  String radicals(Object level) {
    return 'Radicals Level $level';
  }

  @override
  String get kanji => 'Kanji';

  @override
  String kanjiPrimarySchoolClass(Object level) {
    return 'Kanji Grundschule Klasse $level';
  }

  @override
  String kanjiMiddleSchoolClass(Object level) {
    return 'Kanji Mittelschule Level $level';
  }

  @override
  String countEntries(Object count) {
    return '$count entries';
  }

  @override
  String get meanings => 'Bedeutungen:';

  @override
  String get onReadings => 'On Lesung:';

  @override
  String get kunReadings => 'Kun Lesung:';

  @override
  String get moreInfo => 'Mehr Informationen';

  @override
  String get learnJapaneseLetteringSystems => 'Lerne japanische Schriftzeichen';

  @override
  String get learnJapaneseLetteringSystemsDesc =>
      'Wir werden in dieser App drei Schriftsysteme lernen:\n\n- Hiragana\n- Katakana\n- Kanji';

  @override
  String get hiraganaDesc =>
      'Alles beginnt mit den 46 Zeichen von Hiragana und ihren Digraphen. Hiragana ist ein phonetisches Schriftsystem, mit dem alle Wörter in der japanischen Sprache geschrieben werden können.';

  @override
  String get katakanaDesc =>
      'Dies ist das andere phonetische Schriftsystem und wird hauptsächlich zum Schreiben von fremdsprachigen Wörtern verwendet. Zu jedem Hiragana gibt es ein Katakana Gegenstück.';

  @override
  String get radicalsDesc =>
      'Kanji Radicals sind Grapheme oder grafische Teile, die beim Organisieren japanischer Kanji in Wörterbüchern verwendet werden. Sie leiten sich von den 214 Chinesischen Kangxi radicals ab.\n\n Jedes Kanji besteht aus einem oder mehreren Radicals. Teile einfach ein Kanji in seine radicals auf und versuche dir eine kleine Geschichte zu jedem einuzprägen. Das ist der Schlüssel, um sie in dein Langzeitgedächtnis zu bringen.';

  @override
  String get kanjiDesc =>
      'Japanisch verwendet auch chinesische Schriftzeichen, die Kanji genannt werden. Diese App listet die 2136 Jōyō-Kanji auf, die in japanischen Schulen gelehrt werden. Ein Kanji steht für ein oder mehrere Wörter und hat eine On- und eine Kun-Lesung.\n\n Aber wie sollte es möglich sein, so viele Schriftzeichen zu lernen? Mach dir keine Sorge! Dafür haben wir die Kanji Radicals.';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get resetLearningProgress => 'Lernfortschritt zurücksetzen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get check => 'Prüfen';

  @override
  String get enterRomaji => 'Romaji eingeben';

  @override
  String get allStarsWon => 'Alle Sterne gesammelt';

  @override
  String get welcomeText =>
      'Willkommen bei Fun With Kanji. Gemeinsam lernen wir alle japanischen Schriftzeichen, die du zum Lesen von Texten auf Japanisch benötigst. Es wird ein langer Weg sein, aber wir werden das Schritt für Schritt tun.';

  @override
  String get about => 'About';

  @override
  String get website => 'Website';

  @override
  String countIntroduced(Object count) {
    return '$count eingeführt';
  }

  @override
  String get importLearningProgress => 'Lernfortschritt importieren';

  @override
  String get exportLearningProgress => 'Lernfortschritt exportieren';

  @override
  String savedAt(Object path) {
    return 'Saved at $path';
  }

  @override
  String get importFinished => 'Import abgeschlossen';

  @override
  String get importFailed => 'Entschuldigung... Import fehlgeschlagen.';

  @override
  String get search => 'Suchen';

  @override
  String get oopsSomethignWentWrong =>
      'Hoppla... Da ist etwas schief gelaufen!';

  @override
  String get errorDesc =>
      'Ein Fehler ist aufgetreten. Du kannst bei der Behebung helfen, indem du diesen meldest.';

  @override
  String get report => 'Melden';

  @override
  String get save => 'Speichern';

  @override
  String get addHint => 'Merkhilfe hinzufügen';

  @override
  String get looksLikeAManWithAHat => 'Sieht aus wie ein Mann mit einem Hut';

  @override
  String get showHint => 'Merkhilfe anzeigen';

  @override
  String get readOutLoud => 'Laut vorlesen';

  @override
  String get playSoundEffects => 'Soundeffekte abspielen';

  @override
  String get style => 'Style';

  @override
  String get color => 'Farbe';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get close => 'Schließen';

  @override
  String get searchOnlineForSampleVocabulary =>
      'Online nach Beispielvokabeln suchen';

  @override
  String get langPrefix => '_de';

  @override
  String nextLevelUpInHours(Object count) {
    return 'Nächster Stern nach $count Stunden';
  }

  @override
  String get learnWithSpacedRepition => 'Lernen mit spaced repitition';

  @override
  String get enterKanjiAndKana => 'Kanji und Kana eingeben';

  @override
  String get enterKanji => 'Enter kanji';
}
