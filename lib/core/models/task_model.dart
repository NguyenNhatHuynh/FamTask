import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
  overdue,
}

enum TaskType {
  oneTime,
  recurring,
}

enum RecurrenceType {
  daily,
  weekly,
  monthly,
  custom,
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required String assignedUserId,
    required DateTime createdAt,
    required DateTime deadline,
    required TaskStatus status,
    required TaskType type,
    required int points,
    String? categoryId,
    String? familyId,
    RecurrenceType? recurrenceType,
    int? recurrenceInterval, // số ngày/tuần/tháng
    List<String>? tags,
    String? photoUrl,
    String? notes,
    DateTime? completedAt,
    DateTime? lastReminderSent,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}