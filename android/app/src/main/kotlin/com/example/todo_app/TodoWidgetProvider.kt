package com.example.todo_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class TodoWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Get data from SharedPreferences
                val totalTasks = widgetData.getInt("total_tasks", 0)
                val completedTasks = widgetData.getInt("completed_tasks", 0)
                val pendingTasks = widgetData.getInt("pending_tasks", 0)
                val todayTasks = widgetData.getInt("today_tasks", 0)
                val overdueTasks = widgetData.getInt("overdue_tasks", 0)
                
                // Update the widget (home_widget plugin handles this automatically)
            }
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
