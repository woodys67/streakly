import 'challenge.dart';
import 'user_badge.dart';
import 'badge_event.dart';

class BadgeEvaluationContext {
  final List<Challenge> allChallenges;
  final List<UserBadge> earnedBadges;
  final BadgeEvent event;

  const BadgeEvaluationContext({
    required this.allChallenges,
    required this.earnedBadges,
    required this.event,
  });
}
