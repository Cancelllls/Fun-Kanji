import 'package:home_widget/home_widget.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/script_loader.dart';

class WidgetService {
  static const String _groupId = 'group.krillefear.fun_with_kanji';

  static Future<void> updateKanjiOfDayWidget() async {
    try {
      final n5List = await ScriptLoader.loadJlptKanji(5, 1);
      if (n5List.isEmpty) return;

      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final Kanji todayKanji = n5List[dayOfYear % n5List.length];

      await HomeWidget.saveWidgetData<String>('widget_kanji', todayKanji.kanji);
      await HomeWidget.saveWidgetData<String>(
        'widget_meaning',
        todayKanji.meanings.isNotEmpty ? todayKanji.meanings.first : '',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_onyomi',
        todayKanji.readingsOn.isNotEmpty ? todayKanji.readingsOn.first : '',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_kunyomi',
        todayKanji.readingsKun.isNotEmpty ? todayKanji.readingsKun.first : '',
      );

      await HomeWidget.updateWidget(
        name: 'KanjiWidgetProvider',
        androidName: 'KanjiWidgetProvider',
      );
    } catch (_) {}
  }
}
