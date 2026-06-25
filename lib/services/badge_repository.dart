import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_badge.dart';

class BadgeRepository {
  static const _localKey = 'user_badges';

  static Future<List<UserBadge>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final local = _loadLocal(prefs);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.isAnonymous == true) return local;

    try {
      debugPrint('[Badge] Supabase 로드 시도 user=${user.id}');
      final rows = await Supabase.instance.client
          .from('user_badges')
          .select('badge_id, earned_at')
          .eq('user_id', user.id);
      final cloud = (rows as List)
          .map((r) => UserBadge.fromJson(r as Map<String, dynamic>))
          .toList();
      debugPrint('[Badge] 클라우드 배지 ${cloud.length}개: ${cloud.map((b) => b.badgeId).toList()}');
      debugPrint('[Badge] 로컬 배지 ${local.length}개: ${local.map((b) => b.badgeId).toList()}');
      return _merge(local, cloud);
    } catch (e) {
      debugPrint('[Badge] Supabase 로드 실패: $e');
      return local;
    }
  }

  static Future<List<UserBadge>> loadLocalOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadLocal(prefs);
  }

  static Future<void> save(UserBadge badge) async {
    final prefs = await SharedPreferences.getInstance();
    final current = _loadLocal(prefs);
    if (current.any((b) => b.badgeId == badge.badgeId)) return;
    current.add(badge);
    await prefs.setString(
      _localKey,
      jsonEncode(current.map((b) => b.toJson()).toList()),
    );

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.isAnonymous == true) return;
    try {
      await saveToCloud(badge, user.id);
    } catch (_) {
      // 클라우드 실패 시 로컬에는 저장돼 있으므로 무시
    }
  }

  static Future<void> saveToCloud(UserBadge badge, String userId) async {
    await Supabase.instance.client.from('user_badges').upsert(
      {
        'user_id': userId,
        'badge_id': badge.badgeId,
        'earned_at': badge.earnedAt.toIso8601String(),
      },
      onConflict: 'user_id,badge_id',
    );
  }

  static List<UserBadge> _loadLocal(SharedPreferences prefs) {
    final raw = prefs.getString(_localKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => UserBadge.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<UserBadge> _merge(List<UserBadge> local, List<UserBadge> cloud) {
    final map = <String, UserBadge>{};
    for (final b in [...local, ...cloud]) {
      map[b.badgeId] = b;
    }
    return map.values.toList();
  }
}
