// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assignedUserId: json['assignedUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      points: (json['points'] as num).toInt(),
      categoryId: json['categoryId'] as String?,
      familyId: json['familyId'] as String?,
      recurrenceType:
          $enumDecodeNullable(_$RecurrenceTypeEnumMap, json['recurrenceType']),
      recurrenceInterval: (json['recurrenceInterval'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      photoUrl: json['photoUrl'] as String?,
      notes: json['notes'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      lastReminderSent: json['lastReminderSent'] == null
          ? null
          : DateTime.parse(json['lastReminderSent'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'assignedUserId': instance.assignedUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'deadline': instance.deadline.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'points': instance.points,
      'categoryId': instance.categoryId,
      'familyId': instance.familyId,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType],
      'recurrenceInterval': instance.recurrenceInterval,
      'tags': instance.tags,
      'photoUrl': instance.photoUrl,
      'notes': instance.notes,
      'completedAt': instance.completedAt?.toIso8601String(),
      'lastReminderSent': instance.lastReminderSent?.toIso8601String(),
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
  TaskStatus.overdue: 'overdue',
};

const _$TaskTypeEnumMap = {
  TaskType.daily: 'daily',
  TaskType.weekly: 'weekly',
  TaskType.oneTime: 'one_time',
};

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.custom: 'custom',
};
