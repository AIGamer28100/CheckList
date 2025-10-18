import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// Priority levels for tasks
enum TaskPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Task status
enum TaskStatus {
  @JsonValue('todo')
  todo,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Task model with all necessary fields for advanced functionality
@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    DateTime? dueDate,
    DateTime? reminderTime,
    @Default([]) List<String> tags,
    String? location,
    String? githubIssueUrl,
    String? githubRepoId,
    String? calendarEventId,
    @Default([]) List<String> attachments,
    @Default([]) List<Task> subtasks,
    String? parentTaskId,
    @Default(false) bool isRecurring,
    String? recurrencePattern,
    int? estimatedMinutes,
    int? actualMinutes,
    @Default(0) int completionPercentage,
    String? createdBy,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

/// Extension methods for Task
extension TaskExtensions on Task {
  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  /// Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  /// Check if task is due this week
  bool get isDueThisWeek {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return dueDate!.isAfter(weekStart) && dueDate!.isBefore(weekEnd);
  }

  /// Get completion percentage including subtasks
  double get overallCompletionPercentage {
    if (subtasks.isEmpty) {
      return status == TaskStatus.completed
          ? 100.0
          : completionPercentage.toDouble();
    }

    final subtaskCompletion =
        subtasks
            .map((subtask) => subtask.overallCompletionPercentage)
            .reduce((a, b) => a + b) /
        subtasks.length;

    return (completionPercentage + subtaskCompletion) / 2;
  }

  /// Check if task has location
  bool get hasLocation => location != null && location!.isNotEmpty;

  /// Check if task is linked to GitHub
  bool get isGitHubLinked => githubIssueUrl != null || githubRepoId != null;

  /// Check if task is linked to Calendar
  bool get isCalendarLinked => calendarEventId != null;

  /// Get display color based on priority
  String get priorityColor {
    switch (priority) {
      case TaskPriority.low:
        return '#4CAF50'; // Green
      case TaskPriority.medium:
        return '#FF9800'; // Orange
      case TaskPriority.high:
        return '#F44336'; // Red
      case TaskPriority.urgent:
        return '#9C27B0'; // Purple
    }
  }

  /// Create a copy with updated completion status
  Task markAsCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completionPercentage: 100,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a copy with updated progress
  Task updateProgress(int percentage) {
    return copyWith(
      completionPercentage: percentage.clamp(0, 100),
      status: percentage >= 100 ? TaskStatus.completed : status,
      completedAt: percentage >= 100 ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );
  }
}
