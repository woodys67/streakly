import '../models/badge_definition.dart';
import '../models/badge_evaluation_context.dart';
import '../models/badge_event.dart';
import '../models/challenge.dart';
import 'badge_catalog.dart';

class BadgeEvaluator {
  static List<BadgeDefinition> evaluate(BadgeEvaluationContext ctx) {
    final earned = <BadgeDefinition>[];
    for (final badge in BadgeCatalog.all) {
      if (ctx.earnedBadges.any((b) => b.badgeId == badge.id)) continue;
      if (_check(badge, ctx)) earned.add(badge);
    }
    return earned;
  }

  static bool _check(BadgeDefinition badge, BadgeEvaluationContext ctx) {
    final challenges = ctx.allChallenges;
    final event = ctx.event;

    switch (badge.id) {
      // ── 스트릭 ──────────────────────────────────────────────
      case 'streak_001':
        return _maxStreakAcrossAll(challenges) >= 1;
      case 'streak_002':
        return _maxStreakAcrossAll(challenges) >= 3;
      case 'streak_003':
        return _maxStreakAcrossAll(challenges) >= 7;
      case 'streak_004':
        return _maxStreakAcrossAll(challenges) >= 14;
      case 'streak_005':
        return _maxStreakAcrossAll(challenges) >= 21;
      case 'streak_006':
        return _maxStreakAcrossAll(challenges) >= 30;
      case 'streak_007':
        return _maxStreakAcrossAll(challenges) >= 50;
      case 'streak_008':
        return _maxStreakAcrossAll(challenges) >= 66;
      case 'streak_009':
        return _maxStreakAcrossAll(challenges) >= 100;
      case 'streak_010':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['prevBestStreak'] as int? ?? 0) > 0 &&
            _maxStreakAcrossAll(challenges) >
                (event.payload['prevBestStreak'] as int);
      case 'streak_011':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['streakBrokeRecently'] as bool? ?? false) &&
            _maxStreakAcrossAll(challenges) >= 7;
      case 'streak_012':
        return _yearlyStreakTotal(challenges, DateTime.now().year) >= 300;

      // ── 완주 ────────────────────────────────────────────────
      case 'complete_001':
        return challenges.any((c) => c.isCompleted);
      case 'complete_002':
        return challenges.where((c) => c.isCompleted).length >= 3;
      case 'complete_003':
        return challenges.where((c) => c.isCompleted).length >= 10;
      case 'complete_004':
        return challenges.where((c) => c.isCompleted).length >= 25;
      case 'complete_005':
        return challenges.any((c) => c.isCompleted && c.successRate == 1.0);
      case 'complete_006':
        return _consecutivePerfect(challenges) >= 2;
      case 'complete_007':
        return challenges
            .any((c) => c.isCompleted && c.targetDays >= 28);
      case 'complete_008':
        return _distinctCompletedNames(challenges) >= 3;
      case 'complete_009':
        return _completedInYear(challenges, DateTime.now().year) >= 12;
      case 'complete_010':
        final completed = challenges.where((c) => c.isCompleted).toList();
        if (completed.length < 20) return false;
        final avgRate = completed.fold<double>(0, (s, c) => s + c.successRate) /
            completed.length;
        return avgRate >= 0.8;

      // ── 로그 ────────────────────────────────────────────────
      case 'log_001':
        return _totalLogCount(challenges) >= 1;
      case 'log_002':
        return event.type == BadgeEventType.logWritten &&
            (event.payload['consecutiveLogDays'] as int? ?? 0) >= 7;
      case 'log_003':
        return event.type == BadgeEventType.logWritten &&
            (event.payload['consecutiveLogDays'] as int? ?? 0) >= 21;
      case 'log_004':
        return _totalLogCount(challenges) >= 100;
      case 'log_005':
        return event.type == BadgeEventType.logWritten &&
            (event.payload['contentLength'] as int? ?? 0) >= 200;
      case 'log_006':
        return event.type == BadgeEventType.logViewed &&
            (event.payload['daysSinceCompletion'] as int? ?? 0) >= 30;
      case 'log_007':
        return _totalLogCount(challenges) >= 500;
      case 'log_008':
        return _logSpanDays(challenges) >= 365;

      // ── 타이밍 ──────────────────────────────────────────────
      case 'timing_001':
        return event.type == BadgeEventType.checkIn &&
            event.timestamp.hour < 6 &&
            (event.payload['earlyCheckinCount'] as int? ?? 0) >= 7;
      case 'timing_002':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['morningCheckinStreak'] as int? ?? 0) >= 21;
      case 'timing_003':
        return event.type == BadgeEventType.checkIn &&
            event.timestamp.hour == 0 &&
            (event.payload['lateNightCheckinCount'] as int? ?? 0) >= 5;
      case 'timing_004':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['onTimeCheckinCount'] as int? ?? 0) >= 10;
      case 'timing_005':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['weekendStreakWeeks'] as int? ?? 0) >= 4;
      case 'timing_006':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['weekdayStreakWeeks'] as int? ?? 0) >= 4;
      case 'timing_007':
        return event.type == BadgeEventType.checkIn &&
            event.timestamp.hour == 23 &&
            event.timestamp.minute == 59 &&
            (event.payload['midnightCheckinCount'] as int? ?? 0) >= 3;
      case 'timing_008':
        return event.type == BadgeEventType.checkIn &&
            event.timestamp.month == 1 &&
            event.timestamp.day == 1;

      // ── 서브루틴 ────────────────────────────────────────────
      case 'sub_001':
        return event.type == BadgeEventType.subroutineCreated;
      case 'sub_002':
        return challenges
            .any((c) => c.isCompleted && c.subRoutines.length >= 3);
      case 'sub_003':
        return challenges.any((c) =>
            c.isCompleted &&
            c.subRoutines.length >= 5 &&
            c.successRate >= 0.9);
      case 'sub_004':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['parallelCheckinDays'] as int? ?? 0) >= 7;
      case 'sub_005':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['fullSweepCount'] as int? ?? 0) >= 21;
      case 'sub_006':
        return challenges.any((c) =>
            c.isCompleted &&
            c.subRoutines.length >= 5 &&
            c.successRate == 1.0);

      // ── 팀 챌린지 ───────────────────────────────────────────
      case 'team_001':
        return event.type == BadgeEventType.teamJoined;
      case 'team_002':
        return event.type == BadgeEventType.teamCompleted &&
            (event.payload['wasLeader'] as bool? ?? false);
      case 'team_003':
        return event.type == BadgeEventType.teamCompleted &&
            (event.payload['allMembersCompleted'] as bool? ?? false);
      case 'team_004':
        return event.type == BadgeEventType.checkIn &&
            (event.payload['cheerleaderDays'] as int? ?? 0) >= 7;
      case 'team_005':
        return event.type == BadgeEventType.teamCompleted &&
            (event.payload['teamRank'] as int? ?? 99) == 1;
      case 'team_006':
        return event.type == BadgeEventType.teamCompleted &&
            (event.payload['repeatTeamCompletions'] as int? ?? 0) >= 3;

      default:
        return false;
    }
  }

  // ── 헬퍼 ────────────────────────────────────────────────────

  static int _maxStreakAcrossAll(List<Challenge> challenges) =>
      challenges.fold(0, (max, c) => c.streak > max ? c.streak : max);

  static int _yearlyStreakTotal(List<Challenge> challenges, int year) =>
      challenges
          .where((c) => c.startDate.year == year)
          .fold(0, (sum, c) => sum + c.completedDays.length);

  static int _consecutivePerfect(List<Challenge> challenges) {
    final completed = challenges.where((c) => c.isCompleted).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    int consecutive = 0, max = 0;
    for (final c in completed) {
      if (c.successRate == 1.0) {
        consecutive++;
        if (consecutive > max) max = consecutive;
      } else {
        consecutive = 0;
      }
    }
    return max;
  }

  static int _distinctCompletedNames(List<Challenge> challenges) =>
      challenges.where((c) => c.isCompleted).map((c) => c.name).toSet().length;

  static int _completedInYear(List<Challenge> challenges, int year) =>
      challenges
          .where((c) => c.isCompleted && c.startDate.year == year)
          .length;

  static int _totalLogCount(List<Challenge> challenges) =>
      challenges.fold(0, (sum, c) => sum + c.logs.length);

  static int _logSpanDays(List<Challenge> challenges) {
    final allLogs = challenges.expand((c) => c.logs).toList();
    if (allLogs.isEmpty) return 0;
    allLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return allLogs.last.timestamp.difference(allLogs.first.timestamp).inDays;
  }
}
