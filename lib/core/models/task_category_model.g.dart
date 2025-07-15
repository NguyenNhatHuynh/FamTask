// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskCategoryImpl _$$TaskCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TaskCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      color: json['color'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TaskCategoryImplToJson(_$TaskCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconName': instance.iconName,
      'color': instance.color,
      'description': instance.description,
    };
