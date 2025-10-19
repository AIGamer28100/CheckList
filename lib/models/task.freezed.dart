// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get reminderTime => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get githubIssueUrl => throw _privateConstructorUsedError;
  String? get githubRepoId => throw _privateConstructorUsedError;
  String? get calendarEventId => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  List<Task> get subtasks => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;
  String? get recurrencePattern => throw _privateConstructorUsedError;
  int? get estimatedMinutes => throw _privateConstructorUsedError;
  int? get actualMinutes => throw _privateConstructorUsedError;
  int get completionPercentage => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    TaskStatus status,
    TaskPriority priority,
    DateTime? dueDate,
    DateTime? reminderTime,
    List<String> tags,
    String? location,
    String? githubIssueUrl,
    String? githubRepoId,
    String? calendarEventId,
    List<String> attachments,
    List<Task> subtasks,
    String? parentTaskId,
    bool isRecurring,
    String? recurrencePattern,
    int? estimatedMinutes,
    int? actualMinutes,
    int completionPercentage,
    String? createdBy,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? location = freezed,
    Object? githubIssueUrl = freezed,
    Object? githubRepoId = freezed,
    Object? calendarEventId = freezed,
    Object? attachments = null,
    Object? subtasks = null,
    Object? parentTaskId = freezed,
    Object? isRecurring = null,
    Object? recurrencePattern = freezed,
    Object? estimatedMinutes = freezed,
    Object? actualMinutes = freezed,
    Object? completionPercentage = null,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reminderTime: freezed == reminderTime
                ? _value.reminderTime
                : reminderTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            githubIssueUrl: freezed == githubIssueUrl
                ? _value.githubIssueUrl
                : githubIssueUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            githubRepoId: freezed == githubRepoId
                ? _value.githubRepoId
                : githubRepoId // ignore: cast_nullable_to_non_nullable
                      as String?,
            calendarEventId: freezed == calendarEventId
                ? _value.calendarEventId
                : calendarEventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            attachments: null == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            subtasks: null == subtasks
                ? _value.subtasks
                : subtasks // ignore: cast_nullable_to_non_nullable
                      as List<Task>,
            parentTaskId: freezed == parentTaskId
                ? _value.parentTaskId
                : parentTaskId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRecurring: null == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool,
            recurrencePattern: freezed == recurrencePattern
                ? _value.recurrencePattern
                : recurrencePattern // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedMinutes: freezed == estimatedMinutes
                ? _value.estimatedMinutes
                : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            actualMinutes: freezed == actualMinutes
                ? _value.actualMinutes
                : actualMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            completionPercentage: null == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                      as int,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    TaskStatus status,
    TaskPriority priority,
    DateTime? dueDate,
    DateTime? reminderTime,
    List<String> tags,
    String? location,
    String? githubIssueUrl,
    String? githubRepoId,
    String? calendarEventId,
    List<String> attachments,
    List<Task> subtasks,
    String? parentTaskId,
    bool isRecurring,
    String? recurrencePattern,
    int? estimatedMinutes,
    int? actualMinutes,
    int completionPercentage,
    String? createdBy,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? location = freezed,
    Object? githubIssueUrl = freezed,
    Object? githubRepoId = freezed,
    Object? calendarEventId = freezed,
    Object? attachments = null,
    Object? subtasks = null,
    Object? parentTaskId = freezed,
    Object? isRecurring = null,
    Object? recurrencePattern = freezed,
    Object? estimatedMinutes = freezed,
    Object? actualMinutes = freezed,
    Object? completionPercentage = null,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$TaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reminderTime: freezed == reminderTime
            ? _value.reminderTime
            : reminderTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        githubIssueUrl: freezed == githubIssueUrl
            ? _value.githubIssueUrl
            : githubIssueUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        githubRepoId: freezed == githubRepoId
            ? _value.githubRepoId
            : githubRepoId // ignore: cast_nullable_to_non_nullable
                  as String?,
        calendarEventId: freezed == calendarEventId
            ? _value.calendarEventId
            : calendarEventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        attachments: null == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        subtasks: null == subtasks
            ? _value._subtasks
            : subtasks // ignore: cast_nullable_to_non_nullable
                  as List<Task>,
        parentTaskId: freezed == parentTaskId
            ? _value.parentTaskId
            : parentTaskId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRecurring: null == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurrencePattern: freezed == recurrencePattern
            ? _value.recurrencePattern
            : recurrencePattern // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedMinutes: freezed == estimatedMinutes
            ? _value.estimatedMinutes
            : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        actualMinutes: freezed == actualMinutes
            ? _value.actualMinutes
            : actualMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        completionPercentage: null == completionPercentage
            ? _value.completionPercentage
            : completionPercentage // ignore: cast_nullable_to_non_nullable
                  as int,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    required this.id,
    required this.title,
    this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.reminderTime,
    final List<String> tags = const [],
    this.location,
    this.githubIssueUrl,
    this.githubRepoId,
    this.calendarEventId,
    final List<String> attachments = const [],
    final List<Task> subtasks = const [],
    this.parentTaskId,
    this.isRecurring = false,
    this.recurrencePattern,
    this.estimatedMinutes,
    this.actualMinutes,
    this.completionPercentage = 0,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    final Map<String, dynamic> metadata = const {},
  }) : _tags = tags,
       _attachments = attachments,
       _subtasks = subtasks,
       _metadata = metadata;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final TaskStatus status;
  @override
  @JsonKey()
  final TaskPriority priority;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? reminderTime;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? location;
  @override
  final String? githubIssueUrl;
  @override
  final String? githubRepoId;
  @override
  final String? calendarEventId;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<Task> _subtasks;
  @override
  @JsonKey()
  List<Task> get subtasks {
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtasks);
  }

  @override
  final String? parentTaskId;
  @override
  @JsonKey()
  final bool isRecurring;
  @override
  final String? recurrencePattern;
  @override
  final int? estimatedMinutes;
  @override
  final int? actualMinutes;
  @override
  @JsonKey()
  final int completionPercentage;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? completedAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, reminderTime: $reminderTime, tags: $tags, location: $location, githubIssueUrl: $githubIssueUrl, githubRepoId: $githubRepoId, calendarEventId: $calendarEventId, attachments: $attachments, subtasks: $subtasks, parentTaskId: $parentTaskId, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, completionPercentage: $completionPercentage, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.githubIssueUrl, githubIssueUrl) ||
                other.githubIssueUrl == githubIssueUrl) &&
            (identical(other.githubRepoId, githubRepoId) ||
                other.githubRepoId == githubRepoId) &&
            (identical(other.calendarEventId, calendarEventId) ||
                other.calendarEventId == calendarEventId) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks) &&
            (identical(other.parentTaskId, parentTaskId) ||
                other.parentTaskId == parentTaskId) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurrencePattern, recurrencePattern) ||
                other.recurrencePattern == recurrencePattern) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    status,
    priority,
    dueDate,
    reminderTime,
    const DeepCollectionEquality().hash(_tags),
    location,
    githubIssueUrl,
    githubRepoId,
    calendarEventId,
    const DeepCollectionEquality().hash(_attachments),
    const DeepCollectionEquality().hash(_subtasks),
    parentTaskId,
    isRecurring,
    recurrencePattern,
    estimatedMinutes,
    actualMinutes,
    completionPercentage,
    createdBy,
    createdAt,
    updatedAt,
    completedAt,
    const DeepCollectionEquality().hash(_metadata),
  ]);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    required final String id,
    required final String title,
    final String? description,
    final TaskStatus status,
    final TaskPriority priority,
    final DateTime? dueDate,
    final DateTime? reminderTime,
    final List<String> tags,
    final String? location,
    final String? githubIssueUrl,
    final String? githubRepoId,
    final String? calendarEventId,
    final List<String> attachments,
    final List<Task> subtasks,
    final String? parentTaskId,
    final bool isRecurring,
    final String? recurrencePattern,
    final int? estimatedMinutes,
    final int? actualMinutes,
    final int completionPercentage,
    final String? createdBy,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? completedAt,
    final Map<String, dynamic> metadata,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  TaskStatus get status;
  @override
  TaskPriority get priority;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get reminderTime;
  @override
  List<String> get tags;
  @override
  String? get location;
  @override
  String? get githubIssueUrl;
  @override
  String? get githubRepoId;
  @override
  String? get calendarEventId;
  @override
  List<String> get attachments;
  @override
  List<Task> get subtasks;
  @override
  String? get parentTaskId;
  @override
  bool get isRecurring;
  @override
  String? get recurrencePattern;
  @override
  int? get estimatedMinutes;
  @override
  int? get actualMinutes;
  @override
  int get completionPercentage;
  @override
  String? get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
