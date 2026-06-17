import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String _cacheKey(String userId) => 'streak_race_cache_v3_$userId';
String _cacheAtKey(String userId) => 'streak_race_cached_at_v3_$userId';

class StreakRaceEntry {
  final String userId;
  final String displayName;
  final int monthlyPoints;
  final int rank;

  const StreakRaceEntry({
    required this.userId,
    required this.displayName,
    required this.monthlyPoints,
    required this.rank,
  });

  factory StreakRaceEntry.fromJson(Map<String, dynamic> j) => StreakRaceEntry(
        userId: j['user_id'] as String,
        displayName: j['display_name'] as String? ?? 'User',
        monthlyPoints: j['monthly_points'] as int? ?? 0,
        rank: j['rank'] as int,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'display_name': displayName,
        'monthly_points': monthlyPoints,
        'rank': rank,
      };
}

class StreakRaceProvider extends ChangeNotifier {
  StreamSubscription<AuthState>? _authSubscription;

  List<StreakRaceEntry> _leaderboard = [];
  int _myRank = 0;
  int _myMonthlyPoints = 0;
  bool _isLoading = false;
  DateTime? _cachedAt;

  int _lastSyncedMonthlyPoints = -1;
  int _currentMonthlyPoints = 0;
  String _currentDisplayName = '';

  List<StreakRaceEntry> get leaderboard => _leaderboard;
  int get myRank => _myRank;
  int get myMonthlyPoints => _myMonthlyPoints;
  bool get isLoading => _isLoading;
  DateTime? get cachedAt => _cachedAt;

  static SupabaseClient get _db => Supabase.instance.client;

  StreakRaceProvider() {
    _authSubscription = _db.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _reset();
        unawaited(load());
      } else if (data.event == AuthChangeEvent.signedOut) {
        _reset();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _reset() {
    _leaderboard = [];
    _myRank = 0;
    _myMonthlyPoints = 0;
    _cachedAt = null;
    _lastSyncedMonthlyPoints = -1;
    _currentMonthlyPoints = 0;
    _currentDisplayName = '';
    notifyListeners();
  }

  User? get _currentUser {
    final u = _db.auth.currentUser;
    if (u == null || u.isAnonymous == true) return null;
    return u;
  }

  String _currentYearMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  void syncFromDependencies({required int monthlyPoints, required String displayName}) {
    _currentMonthlyPoints = monthlyPoints;
    _currentDisplayName = displayName;
    debugPrint('[StreakRace] syncFromDependencies: monthlyPoints=$monthlyPoints displayName=$displayName');
    _maybeSyncUserFields(monthlyPoints: monthlyPoints);
  }

  Future<void> _maybeSyncUserFields({required int monthlyPoints}) async {
    final user = _currentUser;
    if (user == null) return;

    if (monthlyPoints == _lastSyncedMonthlyPoints) return;
    _lastSyncedMonthlyPoints = monthlyPoints;

    final yearMonth = _currentYearMonth();
    try {
      await _db.from('users').update({
        'monthly_points': monthlyPoints,
        'monthly_year_month': yearMonth,
      }).eq('id', user.id);
    } catch (e) {
      debugPrint('[StreakRace] sync user fields error: $e');
    }
  }

  bool _isCacheStale() {
    final cached = _cachedAt;
    if (cached == null) return true;
    final now = DateTime.now();
    final syncHours = [18, 12, 6, 0]; // descending
    DateTime? lastSync;
    for (final h in syncHours) {
      final candidate = DateTime(now.year, now.month, now.day, h);
      if (!candidate.isAfter(now)) {
        lastSync = candidate;
        break;
      }
    }
    lastSync ??= DateTime(now.year, now.month, now.day - 1, 18);
    return cached.isBefore(lastSync);
  }

  Future<void> load() async {
    final user = _currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cachedAtMs = prefs.getInt(_cacheAtKey(user.id));
    if (cachedAtMs != null) {
      _cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
    }
    final cached = prefs.getString(_cacheKey(user.id));
    if (cached != null) _loadFromCache(cached);

    if (_isCacheStale()) await refresh();
  }

  void _loadFromCache(String raw) {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _leaderboard = (data['leaderboard'] as List)
          .map((e) => StreakRaceEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _myRank = data['my_rank'] as int? ?? 0;
      _myMonthlyPoints = data['my_monthly_points'] as int? ?? 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> refresh() async {
    if (_isLoading) return;
    final user = _currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final yearMonth = _currentYearMonth();
      debugPrint('[StreakRace] refresh: userId=${user.id} yearMonth=$yearMonth _currentMonthlyPoints=$_currentMonthlyPoints');

      // Sync display_name to ensure leaderboard shows current name
      if (_currentDisplayName.isNotEmpty) {
        try {
          await _db.from('users').update({
            'display_name': _currentDisplayName,
          }).eq('id', user.id);
        } catch (e) {
          debugPrint('[StreakRace] display_name sync error: $e');
        }
      }

      // Compute ranking server-side from actual completed_days data
      final now = DateTime.now();
      final rows = await _db.rpc('get_monthly_leaderboard', params: {
        'p_year': now.year,
        'p_month': now.month,
      }) as List<dynamic>;
      debugPrint('[StreakRace] leaderboard rows: ${rows.length}');

      final entries = <StreakRaceEntry>[];
      int myRank = 0;
      int myTotal = 0;
      for (int i = 0; i < rows.length; i++) {
        final row = rows[i] as Map<String, dynamic>;
        final points = (row['monthly_points'] as num?)?.toInt() ?? 0;
        final uid = row['user_id'] as String;
        entries.add(StreakRaceEntry(
          userId: uid,
          displayName: row['display_name'] as String? ?? 'User',
          monthlyPoints: points,
          rank: i + 1,
        ));
        if (uid == user.id) {
          myRank = i + 1;
          myTotal = points;
        }
      }

      if (myRank == 0) {
        // Not in Supabase leaderboard: 0 verified check-ins this month (or outside top 50)
        myTotal = 0;
        myRank = entries.isNotEmpty ? entries.length + 1 : 0;
      }
      debugPrint('[StreakRace] result: myRank=$myRank myTotal=$myTotal entries=${entries.length}');

      _leaderboard = entries;
      _myRank = myRank;
      _myMonthlyPoints = myTotal;
      _cachedAt = DateTime.now();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cacheKey(user.id),
        jsonEncode({
          'leaderboard': entries.map((e) => e.toJson()).toList(),
          'my_rank': myRank,
          'my_monthly_points': myTotal,
        }),
      );
      await prefs.setInt(_cacheAtKey(user.id), _cachedAt!.millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('[StreakRace] refresh error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
