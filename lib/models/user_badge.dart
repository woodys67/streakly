class UserBadge {
  final String badgeId;
  final DateTime earnedAt;

  const UserBadge({required this.badgeId, required this.earnedAt});

  Map<String, dynamic> toJson() => {
        'badge_id': badgeId,
        'earned_at': earnedAt.toIso8601String(),
      };

  factory UserBadge.fromJson(Map<String, dynamic> j) => UserBadge(
        badgeId: j['badge_id'] as String,
        earnedAt: DateTime.parse(j['earned_at'] as String),
      );
}
