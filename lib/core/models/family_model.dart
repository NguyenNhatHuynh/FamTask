import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_model.freezed.dart';
part 'family_model.g.dart';

@freezed
class Family with _$Family {
  const factory Family({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
    required List<String> memberIds,
    required String inviteCode,
    String? description,
    Map<String, dynamic>? settings,
  }) = _Family;

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}
