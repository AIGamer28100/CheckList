// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.todo,
  priority:
      $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
      TaskPriority.medium,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  reminderTime: json['reminderTime'] == null
      ? null
      : DateTime.parse(json['reminderTime'] as String),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  location: json['location'] as String?,
  githubIssueUrl: json['githubIssueUrl'] as String?,
  githubRepoId: json['githubRepoId'] as String?,
  calendarEventId: json['calendarEventId'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  subtasks:
      (json['subtasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  parentTaskId: json['parentTaskId'] as String?,
  isRecurring: json['isRecurring'] as bool? ?? false,
  recurrencePattern: json['recurrencePattern'] as String?,
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
  completionPercentage: (json['completionPercentage'] as num?)?.toInt() ?? 0,
  createdBy: json['createdBy'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'tags': instance.tags,
      'location': instance.location,
      'githubIssueUrl': instance.githubIssueUrl,
      'githubRepoId': instance.githubRepoId,
      'calendarEventId': instance.calendarEventId,
      'attachments': instance.attachments,
      'subtasks': instance.subtasks,
      'parentTaskId': instance.parentTaskId,
      'isRecurring': instance.isRecurring,
      'recurrencePattern': instance.recurrencePattern,
      'estimatedMinutes': instance.estimatedMinutes,
      'actualMinutes': instance.actualMinutes,
      'completionPercentage': instance.completionPercentage,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.urgent: 'urgent',
};
