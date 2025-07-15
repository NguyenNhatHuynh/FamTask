import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('overdue')
  overdue,
}

enum TaskType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('one_time')
  oneTime,
}

enum RecurrenceType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('custom')
  custom,
}

@freezed
class Task with _$Task {
  @JsonSerializable(explicitToJson: true)
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
    int? recurrenceInterval,
    List<String>? tags,
    String? photoUrl,
    String? notes,
    DateTime? completedAt,
    DateTime? lastReminderSent,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
