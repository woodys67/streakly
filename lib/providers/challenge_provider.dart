import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/challenge.dart';
import '../models/routine.dart';
import '../models/daily_log.dart';
import '../models/badge_event.dart';
import '../services/migration_service.dart';
import '../services/notification_service.dart';
import 'badge_provider.dart';

const String _challengesKey = 'challenges';
const String _willpowerSpentKey = 'willpower_spent';
const int _recoveryCost = 3;
const int _recoveryCooldownDays = 7;
const _uuid = Uuid();

class ChallengeProvider extends ChangeNotifier {
  List<Challenge> _challenges = [];
  int _selectedChallengeIndex = 0;
  bool _isLoading = false;
  int _willpowerSpent = 0;
  int _bestStreak = 0;
  BadgeProvider? _badgeProvider;

  void setBadgeProvider(BadgeProvider bp) => _badgeProvider = bp;

  List<Challenge> get challenges => _challenges;
  bool get isLoading => _isLoading;

  List<Challenge> get activeChallenges =>
      _challenges.where((c) => !c.isCompleted).toList();

  /// 오늘 요일에 해당하는 활성 챌린지만 반환.
  /// repeatDays가 비어 있으면 매일 표시, 설정돼 있으면 해당 요일(0=월~6=일)에만 표시.
  List<Challenge> get todaysChallenges {
    final todayIndex = DateTime.now().weekday - 1; // 1=월 → 0, 7=일 → 6
    return _challenges.where((c) {
      if (c.isCompleted) return false;
      if (c.repeatDays.isEmpty) return true;
      return c.repeatDays.contains(todayIndex);
    }).toList();
  }

  List<Challenge> get completedChallenges =>
      _challenges.where((c) => c.isCompleted).toList();

  Challenge? get selectedChallenge {
    if (_challenges.isEmpty) return null;
    final active = activeChallenges;
    if (active.isEmpty) return null;
    if (_selectedChallengeIndex >= active.length) {
      _selectedChallengeIndex = 0;
    }
    return active[_selectedChallengeIndex];
  }

  int get selectedChallengeIndex => _selectedChallengeIndex;

  int get totalStreak {
    if (_challenges.isEmpty) return 0;
    return _challenges.fold<int>(0, (sum, c) => sum + c.streak);
  }

  int get longestStreak => _bestStreak;

  int get totalRecoveries => _willpowerSpent ~/ _recoveryCost;

  // 모든 챌린지 completedDays 합산 (패널티 없음, 항상 증가)
  int get willpower =>
      _challenges.fold(0, (sum, c) => sum + c.completedDays.length);

  // 스트릭 복구에 사용된 의지력을 차감한 실질 의지력
  int get effectiveWillpower => (willpower - _willpowerSpent).clamp(0, 99999);

  // 오늘 완료한 챌린지 수 (오늘 획득한 의지력)
  int get todayWillpower =>
      _challenges.where((c) => c.isTodayCompleted).length;

  bool canRecoverStreak(Challenge challenge) {
    if (challenge.isTodayCompleted) return false;
    if (challenge.isCurrentlyPaused) return false;
    final prev = challenge.previousScheduledDay;
    if (prev == null) return false;
    if (challenge.completedDays.contains(prev)) return false;
    if (challenge.lastRecoveryDate != null &&
        DateTime.now().difference(challenge.lastRecoveryDate!).inDays < _recoveryCooldownDays) return false;
    return true;
  }

  bool canPause(Challenge challenge) {
    return !challenge.isCurrentlyPaused;
  }

  Future<void> removePause(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    final today = DateTime.now();
    final updatedPauses = challenge.pausePeriods
        .where((p) => !p.includes(today))
        .toList();

    _challenges[idx] = challenge.copyWith(pausePeriods: updatedPauses);
    notifyListeners();

    await _saveLocalChallenges();

    final user = _currentUser;
    if (user != null) {
      try {
        await _db.from('challenges').update({
          'pause_periods': updatedPauses.map((p) => p.toJson()).toList(),
        }).eq('id', challengeId).eq('user_id', user.id);
      } catch (e) {
        debugPrint('[Streakly] pause_periods 서버 저장 오류: $e');
      }
    }
  }

  Future<void> addPause(String challengeId, DateTime startDate, DateTime endDate) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    final newPause = PausePeriod(start: startDate, end: endDate);
    final updatedPauses = List<PausePeriod>.from(challenge.pausePeriods)..add(newPause);

    _challenges[idx] = challenge.copyWith(pausePeriods: updatedPauses);
    notifyListeners();

    await _saveLocalChallenges();

    final user = _currentUser;
    if (user != null) {
      try {
        await _db.from('challenges').update({
          'pause_periods': updatedPauses.map((p) => p.toJson()).toList(),
        }).eq('id', challengeId).eq('user_id', user.id);
      } catch (e) {
        debugPrint('[Streakly] pause_periods 서버 저장 오류: $e');
      }
    }
  }

  Future<void> recoverStreak(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;
    final challenge = _challenges[idx];
    if (!canRecoverStreak(challenge)) return;

    final recoveredDay = challenge.previousScheduledDay!;
    final updatedCompleted = List<int>.from(challenge.completedDays)..add(recoveredDay);

    _challenges[idx] = challenge.copyWith(
      completedDays: updatedCompleted,
      lastRecoveryDate: DateTime.now(),
    );

    notifyListeners();
    await _saveLocalChallenges();

    final user = _currentUser;
    if (user != null) {
      await _db.from('challenges').update({
        'completed_days': updatedCompleted,
      }).eq('id', challengeId).eq('user_id', user.id);
    }
  }

  Future<void> _saveWillpowerSpent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_willpowerSpentKey, _willpowerSpent);

    final user = _currentUser;
    if (user != null) {
      try {
        await _db
            .from('users')
            .update({'willpower_spent': _willpowerSpent})
            .eq('id', user.id);
      } catch (e) {
        debugPrint('[Streakly] willpower_spent 서버 저장 오류: $e');
      }
    }
  }

  Future<void> _saveBestStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_bp}best_streak', _bestStreak);

    final user = _currentUser;
    if (user != null) {
      try {
        await _db
            .from('users')
            .update({'best_streak': _bestStreak})
            .eq('id', user.id);
      } catch (e) {
        debugPrint('[Streakly] best_streak 서버 저장 오류: $e');
      }
    }
  }

  double get overallSuccessRate {
    if (_challenges.isEmpty) return 0;
    final total = _challenges.fold<double>(0, (sum, c) => sum + c.successRate);
    return total / _challenges.length;
  }

  static SupabaseClient get _db => Supabase.instance.client;

  User? get _currentUser {
    final user = _db.auth.currentUser;
    if (user == null || (user.isAnonymous == true)) return null;
    return user;
  }

  bool get _isCloud => _currentUser != null;

  // ─────────────────────────────────────────
  // 로드
  // ─────────────────────────────────────────

  Future<void> loadChallenges() async {
    _isLoading = true;
    notifyListeners();

    // snapshot once to avoid race between _isCloud check and userId access
    final user = _currentUser;
    try {
      if (user != null) {
        await _loadFromServerById(user.id);
      } else {
        await _loadFromLocal();
      }
    } catch (e) {
      debugPrint('[Streakly] loadChallenges 오류: $e');
      _challenges = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_challengesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      _challenges = jsonList
          .map((j) => Challenge.fromJson(j as Map<String, dynamic>))
          .toList();
    } else {
      _challenges = [];
    }
    _willpowerSpent = prefs.getInt(_willpowerSpentKey) ?? 0;
    _bestStreak = prefs.getInt('${_bp}best_streak') ?? 0;
  }

  Future<void> _loadFromServerById(String userId) async {
    debugPrint('[Streakly] 서버에서 챌린지 로드 중 (userId: $userId)');
    final rows = await _db
        .from('challenges')
        .select('*, sub_routines!sub_routines_challenge_id_fkey(*), sub_routine_completions(*), daily_logs(*)')
        .eq('user_id', userId)
        .order('created_at');

    _challenges = (rows as List<dynamic>)
        .map((r) => Challenge.fromSupabase(r as Map<String, dynamic>))
        .toList();
    debugPrint('[Streakly] 서버에서 ${_challenges.length}개 챌린지 로드 완료');

    try {
      final userRow = await _db
          .from('users')
          .select('willpower_spent, best_streak')
          .eq('id', userId)
          .maybeSingle();
      _willpowerSpent = (userRow?['willpower_spent'] as int?) ?? 0;
      final serverBest = (userRow?['best_streak'] as int?) ?? 0;
      final localBest = _bestStreak;
      _bestStreak = serverBest > localBest ? serverBest : localBest;
    } catch (e) {
      debugPrint('[Streakly] users 서버 로드 오류: $e');
      _willpowerSpent = 0;
    }
  }

  // ─────────────────────────────────────────
  // 저장 (로컬)
  // ─────────────────────────────────────────

  Future<void> _saveLocalChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_challenges.map((c) => c.toJson()).toList());
    await prefs.setString(_challengesKey, jsonString);
  }

  // ─────────────────────────────────────────
  // 챌린지 추가
  // ─────────────────────────────────────────

  Future<void> addChallenge({
    required String name,
    required int targetDays,
    List<SubRoutine> subRoutines = const [],
    String reminderTime = '',
    List<int> repeatDays = const [],
    String notes = '',
  }) async {
    final challenge = Challenge(
      id: _uuid.v4(),
      name: name,
      targetDays: targetDays,
      startDate: DateTime.now(),
      completedDays: const [],
      subRoutines: subRoutines,
      logs: const [],
      reminderTime: reminderTime,
      repeatDays: repeatDays,
      notes: notes,
    );
    _challenges.add(challenge);
    notifyListeners();

    await NotificationService.scheduleChallenge(challenge);
    for (final sub in subRoutines) {
      await NotificationService.scheduleSubRoutine(sub, repeatDays, name);
    }

    if (_isCloud) {
      try {
        await _insertChallengeToServer(challenge);
        // 서버 저장 성공 후에도 로컬에 백업 (재로그인 시 마이그레이션 복구용)
        await _saveLocalChallenges();
      } catch (e) {
        debugPrint('[Streakly] 챌린지 서버 저장 실패 → 로컬 폴백: $e');
        await _saveLocalChallenges();
        rethrow;
      }
    } else {
      await _saveLocalChallenges();
    }
  }

  // 서브루틴 생성 배지 체크 — addChallenge() 호출자가 Navigator.pop() 이후에 실행해야 함
  Future<void> awardSubRoutineCreatedBadge() async {
    if (_badgeProvider == null) return;
    await _badgeProvider!.checkAndAward(
      BadgeEvent(
        type: BadgeEventType.subroutineCreated,
        timestamp: DateTime.now(),
      ),
      _challenges,
    );
  }

  Future<void> _insertChallengeToServer(Challenge challenge) async {
    final user = _currentUser;
    if (user == null) throw Exception('로그인 세션이 없습니다');

    await _db.from('challenges').insert(challenge.toSupabaseInsert(user.id));

    for (var i = 0; i < challenge.subRoutines.length; i++) {
      await _db
          .from('sub_routines')
          .insert(challenge.subRoutines[i].toSupabase(challenge.id, i));
    }
  }

  // ─────────────────────────────────────────
  // 완료 토글
  // ─────────────────────────────────────────

  Future<void> toggleSubRoutineComplete(
    String challengeId,
    String subRoutineId,
  ) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    // 배지 판정을 위해 체크인 전 상태 캡처
    final prevBestStreak = _challenges.fold<int>(0, (m, c) => c.streak > m ? c.streak : m);
    final prevStreak = challenge.streak;

    final today = challenge.currentDay;
    final updatedSubs = Map<int, List<String>>.from(
      challenge.completedSubRoutines
          .map((k, v) => MapEntry(k, List<String>.from(v))),
    );

    final todayList = List<String>.from(updatedSubs[today] ?? []);
    if (todayList.contains(subRoutineId)) {
      todayList.remove(subRoutineId);
    } else {
      todayList.add(subRoutineId);
    }
    updatedSubs[today] = todayList;

    final allDone =
        challenge.subRoutines.every((s) => todayList.contains(s.id));
    final wasAlreadyDoneToday = challenge.completedDays.contains(today);
    final updatedCompleted = List<int>.from(challenge.completedDays);
    if (allDone) {
      if (!updatedCompleted.contains(today)) updatedCompleted.add(today);
    } else {
      updatedCompleted.remove(today);
    }

    _challenges[idx] = challenge.copyWith(
      completedSubRoutines: updatedSubs,
      completedDays: updatedCompleted,
    );

    // 챌린지 완료 여부 판정 (toggleTodayComplete와 동일 로직)
    bool nowCompleted = false;
    final updatedChallenge = _challenges[idx];
    if (!challenge.isCompleted &&
        updatedChallenge.completedDays.length >= updatedChallenge.targetDays) {
      _challenges[idx] = updatedChallenge.copyWith(isCompleted: true);
      nowCompleted = true;
    }
    notifyListeners();

    if (_isCloud) {
      if (todayList.contains(subRoutineId)) {
        await _db.from('sub_routine_completions').upsert({
          'challenge_id': challengeId,
          'sub_routine_id': subRoutineId,
          'day_number': today,
        });
      } else {
        await _db.from('sub_routine_completions').delete().match({
          'challenge_id': challengeId,
          'sub_routine_id': subRoutineId,
          'day_number': today,
        });
      }
      await _db.from('challenges').update({
        'completed_days': updatedCompleted,
        if (nowCompleted) 'is_completed': true,
      }).eq('id', challengeId);
    } else {
      await _saveLocalChallenges();
    }

    // 모든 서브루틴이 오늘 처음으로 완료된 시점에만 배지 체크
    if (_badgeProvider != null && allDone && !wasAlreadyDoneToday) {
      final payload = await _buildCheckInPayload(challengeId, prevBestStreak, prevStreak);
      await _badgeProvider!.checkAndAward(
        BadgeEvent(
          type: BadgeEventType.checkIn,
          timestamp: DateTime.now(),
          payload: payload,
        ),
        _challenges,
      );
      if (nowCompleted) {
        await _badgeProvider!.checkAndAward(
          BadgeEvent(
            type: BadgeEventType.challengeCompleted,
            timestamp: DateTime.now(),
          ),
          _challenges,
        );
      }
    }
  }

  Future<void> toggleTodayComplete(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    // 배지 판정을 위해 체크인 전 상태 캡처
    final prevBestStreak = _challenges.fold<int>(0, (m, c) => c.streak > m ? c.streak : m);
    final prevStreak = challenge.streak;

    final today = challenge.currentDay;
    final updated = List<int>.from(challenge.completedDays);

    if (updated.contains(today)) {
      updated.remove(today);
    } else {
      updated.add(today);
    }

    _challenges[idx] = challenge.copyWith(completedDays: updated);

    final updatedChallenge = _challenges[idx];
    bool nowCompleted = false;
    if (updatedChallenge.completedDays.length >= updatedChallenge.targetDays) {
      _challenges[idx] = updatedChallenge.copyWith(isCompleted: true);
      nowCompleted = true;
    }
    notifyListeners();

    if (_isCloud) {
      await _db.from('challenges').update({
        'completed_days': updated,
        if (nowCompleted) 'is_completed': true,
      }).eq('id', challengeId);
    } else {
      await _saveLocalChallenges();
    }

    if (_badgeProvider != null && updated.contains(challenge.currentDay)) {
      final payload = await _buildCheckInPayload(challengeId, prevBestStreak, prevStreak);
      await _badgeProvider!.checkAndAward(
        BadgeEvent(
          type: BadgeEventType.checkIn,
          timestamp: DateTime.now(),
          payload: payload,
        ),
        _challenges,
      );
      if (nowCompleted) {
        await _badgeProvider!.checkAndAward(
          BadgeEvent(
            type: BadgeEventType.challengeCompleted,
            timestamp: DateTime.now(),
          ),
          _challenges,
        );
      }
    }
  }

  // ─────────────────────────────────────────
  // 데일리 로그
  // ─────────────────────────────────────────

  Future<void> addDailyLog(String challengeId, String content) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    final log = DailyLog(
      id: _uuid.v4(),
      challengeId: challengeId,
      day: challenge.currentDay,
      content: content,
      timestamp: DateTime.now(),
    );

    final updatedLogs = List<DailyLog>.from(challenge.logs)..add(log);
    _challenges[idx] = challenge.copyWith(logs: updatedLogs);
    notifyListeners();

    if (_isCloud) {
      await _db.from('daily_logs').insert(log.toSupabase());
    } else {
      await _saveLocalChallenges();
    }

    if (_badgeProvider != null) {
      final consecutiveDays = await _updateLogStreak();
      await _badgeProvider!.checkAndAward(
        BadgeEvent(
          type: BadgeEventType.logWritten,
          timestamp: DateTime.now(),
          payload: {
            'contentLength': content.length,
            'consecutiveLogDays': consecutiveDays,
          },
        ),
        _challenges,
      );
    }
  }

  Future<void> deleteDailyLog(String challengeId, String logId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
    final updatedLogs =
        challenge.logs.where((l) => l.id != logId).toList();
    _challenges[idx] = challenge.copyWith(logs: updatedLogs);
    notifyListeners();

    if (_isCloud) {
      await _db.from('daily_logs').delete().eq('id', logId);
    } else {
      await _saveLocalChallenges();
    }
  }

  // ─────────────────────────────────────────
  // 챌린지 삭제
  // ─────────────────────────────────────────

  Future<void> deleteChallenge(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx != -1) {
      for (final sub in _challenges[idx].subRoutines) {
        await NotificationService.cancelSubRoutine(sub.id);
      }
    }
    _challenges.removeWhere((c) => c.id == challengeId);
    notifyListeners();

    await NotificationService.cancelChallenge(challengeId);

    if (_isCloud) {
      await _db.from('challenges').delete().eq('id', challengeId);
    } else {
      await _saveLocalChallenges();
    }
  }

  void selectChallenge(int index) {
    _selectedChallengeIndex = index;
    notifyListeners();
  }

  /// 로그아웃 시 로컬 캐시와 인메모리 챌린지를 초기화.
  Future<void> clearLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_challengesKey);
    await prefs.remove(_willpowerSpentKey);
    _challenges = [];
    _willpowerSpent = 0;
    notifyListeners();
  }

  /// 로그인 유저의 Supabase 데이터 전체 삭제 (앱 초기화용).
  /// challenges 삭제 시 ON DELETE CASCADE로 sub_routines, daily_logs 등 자동 삭제.
  Future<void> deleteAllServerData() async {
    final user = _currentUser;
    if (user == null) return;
    try {
      await _db.from('challenges').delete().eq('user_id', user.id);
      await _db.from('user_badges').delete().eq('user_id', user.id);
    } catch (e) {
      debugPrint('[Streakly] 서버 데이터 삭제 오류: $e');
    }
    _challenges = [];
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // 게스트 → 클라우드 마이그레이션
  // ─────────────────────────────────────────

  /// 게스트 로컬 데이터를 클라우드로 동기화.
  ///
  /// [merge]가 null이면 충돌 감지 모드 — 양쪽에 데이터가 있으면
  /// [MigrationStatus.conflictDetected]를 반환하고 서버 로드를 하지 않음 (UI가 다이얼로그 표시).
  /// [merge]가 true이면 로컬 데이터를 서버에 병합, false이면 로컬 데이터를 버리고 서버 데이터 유지.
  Future<MigrationResult> syncLocalToCloud({String? userId, bool? merge}) async {
    final effectiveId = userId?.isNotEmpty == true ? userId! : _currentUser?.id;
    if (effectiveId == null || effectiveId.isEmpty) {
      return const MigrationResult(
          status: MigrationStatus.failed, error: '로그인 상태가 아닙니다');
    }

    // 유저가 "기존 데이터 유지"를 선택한 경우 — 로컬만 삭제 후 서버 로드
    if (merge == false) {
      await MigrationService.discardLocalData();
      _isLoading = true;
      notifyListeners();
      try {
        await _loadFromServerById(effectiveId);
      } catch (e) {
        debugPrint('[Streakly] 서버 로드 실패: $e');
        _challenges = [];
      }
      _isLoading = false;
      notifyListeners();
      return const MigrationResult(status: MigrationStatus.cloudDataExists);
    }

    debugPrint('[Streakly] syncLocalToCloud 시작 (userId: $effectiveId, merge: $merge)');
    final result = await MigrationService.migrate(effectiveId, forceUpload: merge == true);
    debugPrint('[Streakly] 마이그레이션 결과: ${result.status}, 이전 수: ${result.migratedCount}');

    // 충돌 감지 — 서버 로드 없이 반환 (UI가 다이얼로그 표시 후 재호출)
    if (result.status == MigrationStatus.conflictDetected) {
      return result;
    }

    // 로컬 데이터가 서버로 업로드된 경우 willpower_spent, best_streak도 함께 마이그레이션
    if (result.status == MigrationStatus.success) {
      try {
        await _db
            .from('users')
            .update({
              'willpower_spent': _willpowerSpent,
              'best_streak': _bestStreak,
            })
            .eq('id', effectiveId);
      } catch (e) {
        debugPrint('[Streakly] users 마이그레이션 오류: $e');
      }
    }

    // auth 상태 전환 타이밍과 무관하게 effectiveId로 서버에서 직접 로드
    _isLoading = true;
    notifyListeners();
    try {
      await _loadFromServerById(effectiveId);
    } catch (e) {
      debugPrint('[Streakly] 서버 로드 실패: $e');
      _challenges = [];
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  // ─────────────────────────────────────────
  // 통계
  // ─────────────────────────────────────────

  int getWeeklyCompletionRate() {
    if (activeChallenges.isEmpty) return 0;
    int completed = 0;
    int total = 0;
    final now = DateTime.now();
    for (final challenge in activeChallenges) {
      for (int i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: i));
        final diff = day.difference(challenge.startDate).inDays + 1;
        if (diff >= 1 && diff <= challenge.targetDays) {
          total++;
          if (challenge.completedDays.contains(diff)) {
            completed++;
          }
        }
      }
    }
    if (total == 0) return 0;
    return ((completed / total) * 100).round();
  }

  int getBadgesEarned() {
    int badges = 0;
    for (final challenge in _challenges) {
      if (challenge.completedDays.length >= 7) badges++;
      if (challenge.completedDays.length >= 14) badges++;
      if (challenge.isCompleted) badges++;
    }
    return badges;
  }

  // ─────────────────────────────────────────
  // 배지 payload 헬퍼
  // ─────────────────────────────────────────

  static const _bp = 'badge_counter_';

  Future<Map<String, dynamic>> _buildCheckInPayload(
    String challengeId,
    int prevBestStreak,
    int prevStreak,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    // 새벽 체크인 (6시 이전)
    if (now.hour < 6) {
      await prefs.setInt('${_bp}early', (prefs.getInt('${_bp}early') ?? 0) + 1);
    }

    // 야간 체크인 (자정 00시)
    if (now.hour == 0) {
      await prefs.setInt('${_bp}late_night', (prefs.getInt('${_bp}late_night') ?? 0) + 1);
    }

    // 23:59 체크인
    if (now.hour == 23 && now.minute == 59) {
      await prefs.setInt('${_bp}midnight', (prefs.getInt('${_bp}midnight') ?? 0) + 1);
    }

    // 아침 연속 체크인 (9시 이전)
    if (now.hour < 9) {
      final lastMorning = prefs.getString('${_bp}last_morning') ?? '';
      final yesterdayStr = () {
        final y = now.subtract(const Duration(days: 1));
        return '${y.year}-${y.month}-${y.day}';
      }();
      int morningStreak = prefs.getInt('${_bp}morning_streak') ?? 0;
      if (lastMorning == yesterdayStr) {
        morningStreak++;
      } else if (lastMorning != todayStr) {
        morningStreak = 1;
      }
      await prefs.setInt('${_bp}morning_streak', morningStreak);
      await prefs.setString('${_bp}last_morning', todayStr);
    }

    // 알림 시간 ±15분 이내 체크인
    final challenge = _challenges.firstWhere(
      (c) => c.id == challengeId,
      orElse: () => _challenges.first,
    );
    if (challenge.reminderTime.isNotEmpty) {
      try {
        final parts = challenge.reminderTime.replaceAll(' AM', '').replaceAll(' PM', '').split(':');
        int h = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        if (challenge.reminderTime.contains('PM') && h != 12) h += 12;
        if (challenge.reminderTime.contains('AM') && h == 12) h = 0;
        final reminderMinutes = h * 60 + m;
        final nowMinutes = now.hour * 60 + now.minute;
        if ((nowMinutes - reminderMinutes).abs() <= 15) {
          await prefs.setInt('${_bp}on_time', (prefs.getInt('${_bp}on_time') ?? 0) + 1);
        }
      } catch (_) {}
    }

    // 주말/평일 스트릭 (토=6, 일=7)
    final weekday = now.weekday;
    if (weekday == 6 || weekday == 7) {
      final lastWeekendWeek = prefs.getInt('${_bp}last_weekend_week') ?? -1;
      final currentWeek = _weekNumber(now);
      if (currentWeek != lastWeekendWeek) {
        final prevWeekend = prefs.getInt('${_bp}last_weekend_week') ?? -1;
        int weekendWeeks = prefs.getInt('${_bp}weekend_weeks') ?? 0;
        if (prevWeekend == currentWeek - 1) {
          weekendWeeks++;
        } else {
          weekendWeeks = 1;
        }
        await prefs.setInt('${_bp}weekend_weeks', weekendWeeks);
        await prefs.setInt('${_bp}last_weekend_week', currentWeek);
      }
    } else {
      final lastWeekdayWeek = prefs.getInt('${_bp}last_weekday_week') ?? -1;
      final currentWeek = _weekNumber(now);
      if (currentWeek != lastWeekdayWeek) {
        final prevWeekday = prefs.getInt('${_bp}last_weekday_week') ?? -1;
        int weekdayWeeks = prefs.getInt('${_bp}weekday_weeks') ?? 0;
        if (prevWeekday == currentWeek - 1) {
          weekdayWeeks++;
        } else {
          weekdayWeeks = 1;
        }
        await prefs.setInt('${_bp}weekday_weeks', weekdayWeeks);
        await prefs.setInt('${_bp}last_weekday_week', currentWeek);
      }
    }

    // 병렬 체크인 (2개 이상 동시 진행 챌린지 모두 체크인)
    int parallelDays = prefs.getInt('${_bp}parallel_days') ?? 0;
    final lastParallel = prefs.getString('${_bp}last_parallel') ?? '';
    if (lastParallel != todayStr) {
      final active = todaysChallenges;
      if (active.length >= 2 && active.every((c) => c.isTodayCompleted)) {
        parallelDays++;
        await prefs.setInt('${_bp}parallel_days', parallelDays);
        await prefs.setString('${_bp}last_parallel', todayStr);
      }
    }

    // 풀 스윕 (메인+서브 전부 완료)
    int fullSweep = prefs.getInt('${_bp}full_sweep') ?? 0;
    final lastSweep = prefs.getString('${_bp}last_sweep') ?? '';
    if (lastSweep != todayStr) {
      final hasSubs = challenge.subRoutines.isNotEmpty;
      final allSubsDone = hasSubs &&
          challenge.subRoutines.every((s) => challenge.isSubRoutineCompletedToday(s.id));
      if (challenge.isTodayCompleted && (!hasSubs || allSubsDone)) {
        fullSweep++;
        await prefs.setInt('${_bp}full_sweep', fullSweep);
        await prefs.setString('${_bp}last_sweep', todayStr);
      }
    }

    // 이전 최고 스트릭 갱신
    final currentBest = _challenges.fold<int>(0, (m, c) => c.streak > m ? c.streak : m);
    if (currentBest > _bestStreak) {
      _bestStreak = currentBest;
      await _saveBestStreak();
    }

    // streakBrokeRecently: 이전 스트릭이 0이었고 완료된 날이 있었으면 부활 중
    final streakBrokeRecently = prevStreak == 0 && challenge.completedDays.isNotEmpty;

    return {
      'prevBestStreak': prevBestStreak,
      'streakBrokeRecently': streakBrokeRecently,
      'earlyCheckinCount': prefs.getInt('${_bp}early') ?? 0,
      'morningCheckinStreak': prefs.getInt('${_bp}morning_streak') ?? 0,
      'lateNightCheckinCount': prefs.getInt('${_bp}late_night') ?? 0,
      'onTimeCheckinCount': prefs.getInt('${_bp}on_time') ?? 0,
      'weekendStreakWeeks': prefs.getInt('${_bp}weekend_weeks') ?? 0,
      'weekdayStreakWeeks': prefs.getInt('${_bp}weekday_weeks') ?? 0,
      'midnightCheckinCount': prefs.getInt('${_bp}midnight') ?? 0,
      'parallelCheckinDays': parallelDays,
      'fullSweepCount': fullSweep,
    };
  }

  Future<int> _updateLogStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    final lastLog = prefs.getString('${_bp}last_log_date') ?? '';
    int streak = prefs.getInt('${_bp}log_streak') ?? 0;
    if (lastLog == yesterdayStr) {
      streak++;
    } else if (lastLog != todayStr) {
      streak = 1;
    }
    await prefs.setInt('${_bp}log_streak', streak);
    await prefs.setString('${_bp}last_log_date', todayStr);
    return streak;
  }

  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    return ((date.difference(firstDayOfYear).inDays + firstDayOfYear.weekday) / 7).ceil();
  }
}
