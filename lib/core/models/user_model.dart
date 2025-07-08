@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    required int totalPoints,
    required int level,
    required DateTime joinedAt,
    List<String>? achievements,
    String? familyId,
    bool? isActive,
    DateTime? lastActiveAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}