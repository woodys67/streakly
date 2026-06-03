import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/challenge.dart';

const _challengesKey = 'challenges';

enum MigrationStatus {
  /// 마이그레이션 성공
  success,

  /// 로컬에 데이터 없음 — 마이그레이션 불필요
  noLocalData,

  /// 클라우드에 이미 데이터가 있음 — 로컬 데이터 삭제 후 클라우드 유지
  cloudDataExists,

  /// 로컬과 클라우드 모두 데이터 있음 — 유저가 처리 방식을 선택해야 함
  conflictDetected,

  /// 마이그레이션 실패 (롤백 완료)
  failed,
}

class MigrationResult {
  final MigrationStatus status;
  final int migratedCount;
  final String? error;

  const MigrationResult({
    required this.status,
    this.migratedCount = 0,
    this.error,
  });

  bool get isSuccess =>
      status == MigrationStatus.success ||
      status == MigrationStatus.cloudDataExists;
}

class MigrationService {
  static SupabaseClient get _db => Supabase.instance.client;

  /// 로컬 게스트 데이터를 삭제.
  static Future<void> discardLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_challengesKey);
  }

  /// 게스트 로컬 데이터를 Supabase 계정으로 마이그레이션.
  ///
  /// - [forceUpload]가 false일 때 클라우드에 데이터가 있으면 [MigrationStatus.conflictDetected] 반환
  ///   (로컬 데이터는 삭제하지 않음 — 유저 선택 대기).
  /// - [forceUpload]가 true이면 클라우드 존재 여부와 무관하게 업로드.
  /// - 삽입 도중 오류 발생 시 삽입한 데이터를 롤백하고 [MigrationStatus.failed] 반환.
  /// - 로컬 데이터 없으면 [MigrationStatus.noLocalData] 반환.
  static Future<MigrationResult> migrate(String userId, {bool forceUpload = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_challengesKey);

    debugPrint('[Migration] SharedPreferences challenges: ${jsonString == null ? 'null (없음)' : '${jsonString.length}자'}');

    if (jsonString == null) {
      debugPrint('[Migration] → noLocalData (key 없음)');
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    late List<Challenge> localChallenges;
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      localChallenges = jsonList
          .map((j) => Challenge.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[Migration] → noLocalData (파싱 실패: $e)');
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    debugPrint('[Migration] 로컬 챌린지 수: ${localChallenges.length}, forceUpload: $forceUpload');

    if (localChallenges.isEmpty) {
      debugPrint('[Migration] → noLocalData (빈 리스트)');
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    // 클라우드 충돌 확인 (forceUpload이면 건너뜀)
    if (!forceUpload) {
      try {
        final existing = await _db
            .from('challenges')
            .select('id')
            .eq('user_id', userId)
            .limit(1);
        debugPrint('[Migration] 서버 기존 데이터: ${(existing as List).length}건');
        if ((existing as List).isNotEmpty) {
          // 로컬 데이터를 삭제하지 않고 충돌 상태 반환 — 유저가 처리 방식을 선택
          debugPrint('[Migration] → conflictDetected (로컬 ${localChallenges.length}개, 서버 있음)');
          return MigrationResult(
            status: MigrationStatus.conflictDetected,
            migratedCount: localChallenges.length,
          );
        }
      } catch (e) {
        debugPrint('[Migration] → failed (클라우드 확인 오류: $e)');
        return MigrationResult(
          status: MigrationStatus.failed,
          error: '클라우드 중복 확인 실패: $e',
        );
      }
    }

    // 삽입된 challenge ID 목록 (롤백용)
    final insertedIds = <String>[];

    try {
      for (final challenge in localChallenges) {
        await _db
            .from('challenges')
            .insert(challenge.toSupabaseInsert(userId));
        insertedIds.add(challenge.id);

        // 서브루틴
        for (var i = 0; i < challenge.subRoutines.length; i++) {
          await _db.from('sub_routines').insert(
              challenge.subRoutines[i].toSupabase(challenge.id, i));
        }

        // 서브루틴 완료 기록
        for (final entry in challenge.completedSubRoutines.entries) {
          for (final subId in entry.value) {
            await _db.from('sub_routine_completions').upsert({
              'challenge_id': challenge.id,
              'sub_routine_id': subId,
              'day_number': entry.key,
            });
          }
        }

        // 데일리 로그
        for (final log in challenge.logs) {
          await _db.from('daily_logs').insert(log.toSupabase());
        }
      }

      // 전체 성공 → 로컬 삭제
      await prefs.remove(_challengesKey);
      return MigrationResult(
        status: MigrationStatus.success,
        migratedCount: localChallenges.length,
      );
    } catch (e) {
      // 롤백: 삽입한 챌린지 삭제 (cascade로 연관 데이터도 삭제됨)
      await _rollback(insertedIds);
      return MigrationResult(
        status: MigrationStatus.failed,
        error: '마이그레이션 실패: $e',
      );
    }
  }

  static Future<void> _rollback(List<String> insertedIds) async {
    for (final id in insertedIds) {
      try {
        await _db.from('challenges').delete().eq('id', id);
      } catch (_) {
        // 롤백 실패는 무시 — 다음 로그인 시 중복 확인으로 처리됨
      }
    }
  }
}
