// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get assignedUserId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskType get type => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get familyId => throw _privateConstructorUsedError;
  RecurrenceType? get recurrenceType => throw _privateConstructorUsedError;
  int? get recurrenceInterval => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get lastReminderSent => throw _privateConstructorUsedError;

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
  $Res call(
      {String id,
      String title,
      String description,
      String assignedUserId,
      DateTime createdAt,
      DateTime deadline,
      TaskStatus status,
      TaskType type,
      int points,
      String? categoryId,
      String? familyId,
      RecurrenceType? recurrenceType,
      int? recurrenceInterval,
      List<String>? tags,
      String? photoUrl,
      String? notes,
      DateTime? completedAt,
      DateTime? lastReminderSent});
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
    Object? description = null,
    Object? assignedUserId = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? status = null,
    Object? type = null,
    Object? points = null,
    Object? categoryId = freezed,
    Object? familyId = freezed,
    Object? recurrenceType = freezed,
    Object? recurrenceInterval = freezed,
    Object? tags = freezed,
    Object? photoUrl = freezed,
    Object? notes = freezed,
    Object? completedAt = freezed,
    Object? lastReminderSent = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      assignedUserId: null == assignedUserId
          ? _value.assignedUserId
          : assignedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceType: freezed == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType?,
      recurrenceInterval: freezed == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReminderSent: freezed == lastReminderSent
          ? _value.lastReminderSent
          : lastReminderSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String assignedUserId,
      DateTime createdAt,
      DateTime deadline,
      TaskStatus status,
      TaskType type,
      int points,
      String? categoryId,
      String? familyId,
      RecurrenceType? recurrenceType,
      int? recurrenceInterval,
      List<String>? tags,
      String? photoUrl,
      String? notes,
      DateTime? completedAt,
      DateTime? lastReminderSent});
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
    Object? description = null,
    Object? assignedUserId = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? status = null,
    Object? type = null,
    Object? points = null,
    Object? categoryId = freezed,
    Object? familyId = freezed,
    Object? recurrenceType = freezed,
    Object? recurrenceInterval = freezed,
    Object? tags = freezed,
    Object? photoUrl = freezed,
    Object? notes = freezed,
    Object? completedAt = freezed,
    Object? lastReminderSent = freezed,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      assignedUserId: null == assignedUserId
          ? _value.assignedUserId
          : assignedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceType: freezed == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType?,
      recurrenceInterval: freezed == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReminderSent: freezed == lastReminderSent
          ? _value.lastReminderSent
          : lastReminderSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.assignedUserId,
      required this.createdAt,
      required this.deadline,
      required this.status,
      required this.type,
      required this.points,
      this.categoryId,
      this.familyId,
      this.recurrenceType,
      this.recurrenceInterval,
      final List<String>? tags,
      this.photoUrl,
      this.notes,
      this.completedAt,
      this.lastReminderSent})
      : _tags = tags;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String assignedUserId;
  @override
  final DateTime createdAt;
  @override
  final DateTime deadline;
  @override
  final TaskStatus status;
  @override
  final TaskType type;
  @override
  final int points;
  @override
  final String? categoryId;
  @override
  final String? familyId;
  @override
  final RecurrenceType? recurrenceType;
  @override
  final int? recurrenceInterval;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? photoUrl;
  @override
  final String? notes;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? lastReminderSent;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, assignedUserId: $assignedUserId, createdAt: $createdAt, deadline: $deadline, status: $status, type: $type, points: $points, categoryId: $categoryId, familyId: $familyId, recurrenceType: $recurrenceType, recurrenceInterval: $recurrenceInterval, tags: $tags, photoUrl: $photoUrl, notes: $notes, completedAt: $completedAt, lastReminderSent: $lastReminderSent)';
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
            (identical(other.assignedUserId, assignedUserId) ||
                other.assignedUserId == assignedUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.recurrenceType, recurrenceType) ||
                other.recurrenceType == recurrenceType) &&
            (identical(other.recurrenceInterval, recurrenceInterval) ||
                other.recurrenceInterval == recurrenceInterval) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.lastReminderSent, lastReminderSent) ||
                other.lastReminderSent == lastReminderSent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      assignedUserId,
      createdAt,
      deadline,
      status,
      type,
      points,
      categoryId,
      familyId,
      recurrenceType,
      recurrenceInterval,
      const DeepCollectionEquality().hash(_tags),
      photoUrl,
      notes,
      completedAt,
      lastReminderSent);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String title,
      required final String description,
      required final String assignedUserId,
      required final DateTime createdAt,
      required final DateTime deadline,
      required final TaskStatus status,
      required final TaskType type,
      required final int points,
      final String? categoryId,
      final String? familyId,
      final RecurrenceType? recurrenceType,
      final int? recurrenceInterval,
      final List<String>? tags,
      final String? photoUrl,
      final String? notes,
      final DateTime? completedAt,
      final DateTime? lastReminderSent}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get assignedUserId;
  @override
  DateTime get createdAt;
  @override
  DateTime get deadline;
  @override
  TaskStatus get status;
  @override
  TaskType get type;
  @override
  int get points;
  @override
  String? get categoryId;
  @override
  String? get familyId;
  @override
  RecurrenceType? get recurrenceType;
  @override
  int? get recurrenceInterval;
  @override
  List<String>? get tags;
  @override
  String? get photoUrl;
  @override
  String? get notes;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get lastReminderSent;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
