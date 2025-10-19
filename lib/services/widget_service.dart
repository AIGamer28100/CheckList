import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../utils/database_helper.dart';
import 'package:intl/intl.dart';

/// Service for managing home screen widgets
class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  static const String _androidWidgetName = 'TodoWidgetProvider';
  static const String _iosWidgetName = 'TodoWidget';

  /// Update all widgets with current task data
  Future<void> updateWidgets() async {
    try {
      // Get task data
      final repository = TaskRepository(DatabaseHelper());
      final tasks = await repository.getAll();

      // Calculate statistics
      final totalTasks = tasks.length;
      final completedTasks = tasks
          .where((t) => t.status == TaskStatus.completed)
          .length;
      final pendingTasks = totalTasks - completedTasks;
      final todayTasks = tasks.where((t) => t.isDueToday).length;
      final overdueTasks = tasks.where((t) => t.isOverdue).length;

      // Get upcoming tasks (max 5)
      final upcomingTasks = tasks
          .where(
            (t) =>
                t.status != TaskStatus.completed &&
                t.status != TaskStatus.cancelled,
          )
          .take(5)
          .toList();

      // Save data to widget storage
      await HomeWidget.saveWidgetData<int>('total_tasks', totalTasks);
      await HomeWidget.saveWidgetData<int>('completed_tasks', completedTasks);
      await HomeWidget.saveWidgetData<int>('pending_tasks', pendingTasks);
      await HomeWidget.saveWidgetData<int>('today_tasks', todayTasks);
      await HomeWidget.saveWidgetData<int>('overdue_tasks', overdueTasks);

      // Save upcoming tasks data
      for (int i = 0; i < upcomingTasks.length; i++) {
        final task = upcomingTasks[i];
        await HomeWidget.saveWidgetData<String>('task_${i}_id', task.id);
        await HomeWidget.saveWidgetData<String>('task_${i}_title', task.title);
        await HomeWidget.saveWidgetData<String>(
          'task_${i}_priority',
          task.priority.name,
        );
        await HomeWidget.saveWidgetData<bool>(
          'task_${i}_completed',
          task.status == TaskStatus.completed,
        );
        if (task.dueDate != null) {
          await HomeWidget.saveWidgetData<String>(
            'task_${i}_due',
            task.dueDate!.toIso8601String(),
          );
        }
      }
      await HomeWidget.saveWidgetData<int>(
        'upcoming_task_count',
        upcomingTasks.length,
      );

      // For iOS widgets, also save tasks as JSON
      final tasksJson = upcomingTasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'isCompleted': task.status == TaskStatus.completed,
          'priority': task.priority.name,
          'dueDate': task.dueDate != null
              ? DateFormat('MMM d').format(task.dueDate!)
              : null,
        };
      }).toList();
      await HomeWidget.saveWidgetData<String>(
        'tasks_json',
        jsonEncode(tasksJson),
      );

      // Update widgets
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );

      debugPrint('Widgets updated successfully');
    } catch (e) {
      debugPrint('Error updating widgets: $e');
    }
  }

  /// Handle widget tap to open specific task
  Future<String?> getWidgetTappedTaskId() async {
    try {
      final data = await HomeWidget.getWidgetData<String>('tapped_task_id');
      if (data != null) {
        // Clear the tapped task ID
        await HomeWidget.saveWidgetData<String>('tapped_task_id', '');
      }
      return data;
    } catch (e) {
      debugPrint('Error getting tapped task: $e');
      return null;
    }
  }

  /// Toggle task completion from widget
  Future<void> toggleTaskFromWidget(String taskId) async {
    try {
      final repository = TaskRepository(DatabaseHelper());
      final task = await repository.getById(taskId);

      if (task != null) {
        final updatedTask = task.copyWith(
          status: task.status == TaskStatus.completed
              ? TaskStatus.todo
              : TaskStatus.completed,
          completedAt: task.status == TaskStatus.completed
              ? null
              : DateTime.now(),
        );

        await repository.update(updatedTask);
        await updateWidgets();

        debugPrint('Task toggled from widget: $taskId');
      }
    } catch (e) {
      debugPrint('Error toggling task from widget: $e');
    }
  }

  /// Initialize widget callbacks
  void setupWidgetCallbacks() {
    HomeWidget.widgetClicked.listen((uri) {
      debugPrint('Widget clicked with URI: $uri');
      // Handle widget interactions
      if (uri != null) {
        final taskId = uri.queryParameters['taskId'];
        if (taskId != null) {
          toggleTaskFromWidget(taskId);
        }
      }
    });
  }

  /// Register background callback for widget updates
  static void backgroundCallback(Uri? uri) {
    debugPrint('Widget background callback: $uri');
    if (uri != null) {
      final taskId = Uri.parse(uri.toString()).queryParameters['taskId'];
      if (taskId != null) {
        WidgetService().toggleTaskFromWidget(taskId);
      }
    }
  }
}
