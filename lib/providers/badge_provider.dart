import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/badge_definition.dart';
import '../models/badge_evaluation_context.dart';
import '../models/badge_event.dart';
import '../models/challenge.dart';
import '../models/user_badge.dart';
import '../services/badge_evaluator.dart';
import '../services/badge_repository.dart';

class BadgeProvider extends ChangeNotifier {
  List<UserBadge> _earned = [];
  final Queue<BadgeDefinition> _pendingUnlocks = Queue();

  List<UserBadge> get earned => _earned;
  bool get hasPendingUnlock => _pendingUnlocks.isNotEmpty;
  BadgeDefinition? get nextUnlock =>
      _pendingUnlocks.isNotEmpty ? _pendingUnlocks.first : null;

  Future<void> load() async {
    _earned = await BadgeRepository.loadAll();
    notifyListeners();
  }

  Future<void> checkAndAward(
    BadgeEvent event,
    List<Challenge> challenges,
  ) async {
    final ctx = BadgeEvaluationContext(
      allChallenges: challenges,
      earnedBadges: _earned,
      event: event,
    );

    final newBadges = BadgeEvaluator.evaluate(ctx);
    if (newBadges.isEmpty) return;

    for (final badge in newBadges) {
      final userBadge = UserBadge(
        badgeId: badge.id,
        earnedAt: DateTime.now(),
      );
      await BadgeRepository.save(userBadge);
      _earned = [..._earned, userBadge];
      _pendingUnlocks.add(badge);
      debugPrint('[Badge] 획득: ${badge.nameKo} (${badge.id})');
    }

    notifyListeners();
  }

  void consumeNextUnlock() {
    if (_pendingUnlocks.isNotEmpty) {
      _pendingUnlocks.removeFirst();
      notifyListeners();
    }
  }

  bool hasEarned(String badgeId) => _earned.any((b) => b.badgeId == badgeId);

  DateTime? earnedAt(String badgeId) {
    try {
      return _earned.firstWhere((b) => b.badgeId == badgeId).earnedAt;
    } catch (_) {
      return null;
    }
  }
}
