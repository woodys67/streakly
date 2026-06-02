import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/challenge.dart';
import '../models/routine.dart';
import '../models/daily_log.dart';
import '../services/migration_service.dart';
import '../services/notification_service.dart';

const String _challengesKey = 'challenges';
const _uuid = Uuid();

class ChallengeProvider extends ChangeNotifier {
  List<Challenge> _challenges = [];
  int _selectedChallengeIndex = 0;
  bool _isLoading = false;

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
      await _db
          .from('challenges')
          .update({'completed_days': updatedCompleted})
          .eq('id', challengeId);
    } else {
      await _saveLocalChallenges();
    }
  }

  Future<void> toggleTodayComplete(String challengeId) async {
    final idx = _challenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;

    final challenge = _challenges[idx];
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
    _challenges = [];
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // 게스트 → 클라우드 마이그레이션
  // ─────────────────────────────────────────

  /// MigrationService에 위임한 뒤 인메모리 챌린지를 새로 로드.
  /// [userId]를 명시하면 Supabase 세션 없이도 동작 (이메일 미인증 직후 등).
  Future<MigrationResult> syncLocalToCloud({String? userId}) async {
    final effectiveId = userId?.isNotEmpty == true ? userId! : _currentUser?.id;
    if (effectiveId == null || effectiveId.isEmpty) {
      return const MigrationResult(
          status: MigrationStatus.failed, error: '로그인 상태가 아닙니다');
    }
    debugPrint('[Streakly] syncLocalToCloud 시작 (userId: $effectiveId)');
    final result = await MigrationService.migrate(effectiveId);
    debugPrint('[Streakly] 마이그레이션 결과: ${result.status}, 이전 수: ${result.migratedCount}');

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
}
