@freezed
class Family with _$Family {
  const factory Family({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
    required List<String> memberIds,
    String? inviteCode,
    String? description,
    Map<String, dynamic>? settings,
  }) = _Family;

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}