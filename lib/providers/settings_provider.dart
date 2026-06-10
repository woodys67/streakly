import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_strings.dart';
import '../services/notification_service.dart';

const String _languageKey = 'language';
const String _notificationsKey = 'notifications';
const String _darkModeKey = 'darkMode';
const String _userNameKey = 'userName';
const String _profileImageKey = 'profileImage';

class SettingsProvider extends ChangeNotifier {
  String _language = 'English';
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _userName = 'Streakly User';
  String _profileImage = '';

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkMode => _darkMode;
  String get userName => _userName;
  String get profileImage => _profileImage;
  AppStrings get strings => AppStrings.of(_language);

  static const List<String> profileImages = [
    'assets/images/avatar_bolt.png',
    'assets/images/avatar_trophy.png',
    'assets/images/avatar_target.png',
    'assets/images/avatar_diamond.png',
    'assets/images/avatar_rocket.png',
    'assets/images/avatar_leaf.png',
    'assets/images/avatar_star.png',
    'assets/images/avatar_mountain.png',
  ];


  static const List<Map<String, String>> availableLanguages = [
    {'code': 'English',  'label': 'English'},
    {'code': 'Korean',   'label': '한국어 - Korean'},
    {'code': 'Japanese', 'label': '日本語 - Japanese'},
    {'code': 'Spanish',  'label': 'Español - Spanish'},
  ];

  static String _detectDeviceLanguage() {
    final lang = PlatformDispatcher.instance.locale.languageCode;

    if (lang == 'ko') return 'Korean';
    if (lang == 'ja') return 'Japanese';
    if (lang == 'es') return 'Spanish';
    return 'English';
  }

  static SupabaseClient get _db => Supabase.instance.client;

  User? get _currentUser {
    final user = _db.auth.currentUser;
    if (user == null || (user.isAnonymous == true)) return null;
    return user;
  }

  /// [fallbackDisplayName] : 회원가입 폼에서 입력한 닉네임 폴백.
  /// [userId] : `_currentUser`가 null인 경우(세션 타이밍 이슈)에 사용할 명시적 userId.
  /// 반환값: 서버에서 public.users 행 확보에 성공하면 true, 실패하면 false (local 폴백).
  Future<bool> loadSettings({String? fallbackDisplayName, String? userId}) async {
    final user = _currentUser;
    final effectiveId = user?.id ?? userId;
    bool profileReady = false;

    if (effectiveId != null) {
      profileReady = await _loadFromServer(effectiveId);
    } else {
      await _loadFromLocal();
    }

    // 서버/로컬 모두 기본값인 경우 회원가입 시 입력한 닉네임으로 덮어씀
    if (fallbackDisplayName != null &&
        fallbackDisplayName.isNotEmpty &&
        fallbackDisplayName != 'Streakly User' &&
        _userName == 'Streakly User') {
      _userName = fallbackDisplayName;
      notifyListeners();
      await _saveToLocal();
      if (profileReady && effectiveId != null) {
        try {
          await _db.from('users').update({'display_name': _userName}).eq('id', effectiveId);
        } catch (_) {}
      }
    }

    return profileReady;
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(_languageKey) ?? _detectDeviceLanguage();
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _darkMode = prefs.getBool(_darkModeKey) ?? false;
    _userName = prefs.getString(_userNameKey) ?? 'Streakly User';
    _profileImage = prefs.getString(_profileImageKey) ?? '';
    notifyListeners();
  }

  /// 서버에서 사용자 프로필 로드. 행이 없으면 신규 생성.
  /// 반환값: 서버 행 확보 성공 시 true, 실패 시 false.
  Future<bool> _loadFromServer(String userId) async {
    // 1단계: 기존 행 조회
    Map<String, dynamic>? row;
    try {
      row = await _db
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
    } catch (e) {
      debugPrint('[Streakly] users 조회 실패: $e');
      await _loadFromLocal();
      return false;
    }

    if (row != null) {
      _language = row['language'] as String? ?? _detectDeviceLanguage();
      _notificationsEnabled = row['notifications_enabled'] as bool? ?? true;
      _darkMode = row['dark_mode'] as bool? ?? false;
      _userName = row['display_name'] as String? ?? 'Streakly User';
      _profileImage = row['profile_image'] as String? ?? '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileImageKey, _profileImage);
      notifyListeners();
      return true;
    }

    // 2단계: 행 없음 → 신규 생성 (최초 로그인/회원가입)
    try {
      await _db.from('users').insert({
        'id': userId,
        'display_name': _userName,
        'language': _language,
        'notifications_enabled': _notificationsEnabled,
        'dark_mode': _darkMode,
      });
      notifyListeners();
      return true;
    } catch (e) {
      // 트리거가 먼저 행을 생성한 경우(중복 키) → 재조회로 처리
      try {
        final retryRow = await _db
            .from('users')
            .select()
            .eq('id', userId)
            .maybeSingle();
        if (retryRow != null) {
          _language = retryRow['language'] as String? ?? _detectDeviceLanguage();
          _notificationsEnabled = retryRow['notifications_enabled'] as bool? ?? true;
          _darkMode = retryRow['dark_mode'] as bool? ?? false;
          _userName = retryRow['display_name'] as String? ?? 'Streakly User';
          _profileImage = retryRow['profile_image'] as String? ?? '';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_profileImageKey, _profileImage);
          notifyListeners();
          return true;
        }
      } catch (_) {}
      debugPrint('[Streakly] users 생성 실패: $e');
      await _loadFromLocal();
      return false;
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _language);
    await prefs.setBool(_notificationsKey, _notificationsEnabled);
    await prefs.setBool(_darkModeKey, _darkMode);
    await prefs.setString(_userNameKey, _userName);
    await prefs.setString(_profileImageKey, _profileImage);
  }

  Future<void> _saveToServer(String userId) async {
    try {
      await _db.from('users').upsert({
        'id': userId,
        'display_name': _userName,
        'language': _language,
        'notifications_enabled': _notificationsEnabled,
        'dark_mode': _darkMode,
        'profile_image': _profileImage,
      });
    } catch (_) {}
  }

  Future<void> _persist() async {
    await _saveToLocal();
    final user = _currentUser;
    if (user != null) await _saveToServer(user.id);
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    notifyListeners();
    await _persist();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
    await _persist();
    if (!_notificationsEnabled) {
      await NotificationService.cancelAll();
    }
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    await _persist();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    notifyListeners();
    await _persist();
  }

  Future<void> setProfileImage(String assetPath) async {
    _profileImage = assetPath;
    notifyListeners();
    await _persist();
  }

  /// Supabase 세션 종료는 AuthProvider.signOut()이 담당.
  /// 프로필 이미지는 계정 연결 데이터이므로 로그아웃 시 초기화.
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImageKey);
    await _loadFromLocal();
  }

  Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _language = _detectDeviceLanguage();
    _notificationsEnabled = true;
    _darkMode = false;
    _userName = 'Streakly User';
    _profileImage = '';
    notifyListeners();
  }
}
