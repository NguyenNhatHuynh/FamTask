import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_category_model.freezed.dart';
part 'task_category_model.g.dart';

@freezed
class TaskCategory with _$TaskCategory {
  const factory TaskCategory({
    required String id,
    required String name,
    required String iconName,
    required String color,
    String? description,
  }) = _TaskCategory;

  factory TaskCategory.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryFromJson(json);
}
