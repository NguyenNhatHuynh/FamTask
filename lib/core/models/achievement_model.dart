import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

@freezed
class Achievement with _$Achievement {
  @JsonSerializable(explicitToJson: true)
  const factory Achievement({
    required String id,
    required String name,
    required String description,
    required String icon,
    required int pointsRequired,
    DateTime? achievedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}