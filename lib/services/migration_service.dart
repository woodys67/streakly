import 'dart:convert';
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

  /// 게스트 로컬 데이터를 Supabase 계정으로 마이그레이션.
  ///
  /// - 클라우드에 이미 데이터가 있으면 로컬만 삭제하고 [MigrationStatus.cloudDataExists] 반환.
  /// - 삽입 도중 오류 발생 시 삽입한 데이터를 롤백하고 [MigrationStatus.failed] 반환.
  /// - 로컬 데이터 없으면 [MigrationStatus.noLocalData] 반환.
  static Future<MigrationResult> migrate(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_challengesKey);

    if (jsonString == null) {
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    late List<Challenge> localChallenges;
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      localChallenges = jsonList
          .map((j) => Challenge.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    if (localChallenges.isEmpty) {
      return const MigrationResult(status: MigrationStatus.noLocalData);
    }

    // 클라우드에 이미 데이터가 있으면 덮어쓰지 않음
    try {
      final existing = await _db
          .from('challenges')
          .select('id')
          .eq('user_id', userId)
          .limit(1);
      if ((existing as List).isNotEmpty) {
        await prefs.remove(_challengesKey);
        return const MigrationResult(status: MigrationStatus.cloudDataExists);
      }
    } catch (e) {
      return MigrationResult(
        status: MigrationStatus.failed,
        error: '클라우드 중복 확인 실패: $e',
      );
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
