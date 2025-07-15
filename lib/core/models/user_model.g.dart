// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalPoints: (json['totalPoints'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      familyId: json['familyId'] as String?,
      isActive: json['isActive'] as bool?,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'totalPoints': instance.totalPoints,
      'level': instance.level,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'achievements': instance.achievements,
      'familyId': instance.familyId,
      'isActive': instance.isActive,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
    };
