package krillefear.funny_kanji

import krillefear.funwithkanji.R

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class KanjiWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.kanji_widget_layout).apply {
                // Open App on Widget Click
                val pendingIntent = es.antonborri.home_widget.HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_title, pendingIntent)
                setOnClickPendingIntent(R.id.widget_kanji, pendingIntent)
                
                val kanji = widgetData.getString("kanji", "日")
                val meaning = widgetData.getString("meaning", "Day / Sun")
                setTextViewText(R.id.widget_kanji, kanji)
                setTextViewText(R.id.widget_meaning, meaning)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
