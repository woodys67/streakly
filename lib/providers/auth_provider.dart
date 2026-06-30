import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isEmailNotConfirmed = false;

  User? get currentUser => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmailNotConfirmed => _isEmailNotConfirmed;

  /// 인증된 사용자가 있고 익명이 아닌 경우 true
  bool get isAuthenticated =>
      _user != null && (_user!.isAnonymous == false);

  /// 미로그인 또는 익명 세션이면 게스트
  bool get isGuest => _user == null || (_user!.isAnonymous == true);

  String get userId => _user?.id ?? '';
  String get userEmail => _user?.email ?? '';
  String get displayName =>
      _user?.userMetadata?['display_name'] as String? ??
      _user?.userMetadata?['full_name'] as String? ??
      _user?.userMetadata?['name'] as String? ??
      'Streakly User';

  static SupabaseClient get _client => Supabase.instance.client;

  AuthProvider() {
    _user = _client.auth.currentUser;
    _client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    _isEmailNotConfirmed = false;
    notifyListeners();
  }

  Future<bool> signUpWithEmail(
      String email, String password, String displayName) async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );
      _user = res.user;
      return _user != null;
    } on AuthException catch (e) {
      final isEmailSendFailure = e.message.contains('Error sending confirmation email') ||
          e.message.contains('unexpected_failure');

      if (isEmailSendFailure) {
        try {
          final signInRes = await _client.auth.signInWithPassword(
            email: email,
            password: password,
          );
          if (signInRes.user != null) {
            _user = signInRes.user;
            return true;
          }
        } on AuthException catch (signInErr) {
          if (signInErr.message.toLowerCase().contains('email not confirmed')) {
            _isEmailNotConfirmed = true;
            _error = 'email_not_confirmed';
            return false;
          }
        } catch (_) {}
      }

      _error = _parseAuthError(e.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  String _parseAuthError(String raw) {
    String msg = raw;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      msg = decoded['message'] as String? ?? raw;
    } catch (_) {}

    final lower = msg.toLowerCase();
    if (lower.contains('invalid login credentials') || lower.contains('invalid credentials')) {
      return 'invalid_credentials';
    }
    if (lower.contains('user already registered') || lower.contains('already registered')) {
      return 'user_already_registered';
    }
    if (lower.contains('password should be') || lower.contains('password must be') || lower.contains('at least')) {
      return 'password_too_short';
    }
    if (lower.contains('rate limit') || lower.contains('too many requests') || lower.contains('email rate')) {
      return 'rate_limit_exceeded';
    }
    if (lower.contains('email not confirmed')) {
      return 'email_not_confirmed';
    }
    return 'unknown_error';
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _error = null;
    _isEmailNotConfirmed = false;
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _user = res.user;
      return _user != null;
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email not confirmed')) {
        _isEmailNotConfirmed = true;
        _error = 'email_not_confirmed';
      } else {
        _error = _parseAuthError(e.message);
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInAnonymously() async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _client.auth.signInAnonymously();
      _user = res.user;
      return _user != null;
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithApple() async {
    _setLoading(true);
    _error = null;
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null) {
        _error = 'apple_login_failed';
        return false;
      }

      final res = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      _user = res.user;
      return _user != null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        _error = 'apple_login_error';
      }
      return false;
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
      return false;
    } catch (_) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Google 로그인 — Supabase OAuth 웹 플로우 사용.
  Future<bool> signInWithGoogle() =>
      _signInWithOAuthWebFlow(OAuthProvider.google, 'google_login_failed');

  /// Supabase OAuth 웹 플로우 공통 처리.
  ///
  /// 네이티브 SDK(google_sign_in 등)는 idToken에 임의의 nonce를 삽입하는데 그 원본을
  /// 알 수 없어 signInWithIdToken의 nonce 검증을 통과할 수 없다. 따라서 OAuth 웹
  /// 플로우를 사용한다(서버가 nonce 관리). 실제 세션은 딥링크 콜백 후
  /// onAuthStateChange(signedIn)로 완료되므로 Completer로 이벤트를 기다려
  /// 기존 호출부와 동일하게 bool을 반환한다.
  Future<bool> _signInWithOAuthWebFlow(
      OAuthProvider provider, String failKey) async {
    _setLoading(true);
    _error = null;
    StreamSubscription<AuthState>? sub;
    try {
      final completer = Completer<bool>();
      sub = _client.auth.onAuthStateChange.listen((data) {
        if (data.event == AuthChangeEvent.signedIn && !completer.isCompleted) {
          completer.complete(true);
        }
      });

      final launched = await _client.auth.signInWithOAuth(
        provider,
        redirectTo: SupabaseConfig.oauthRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _error = failKey;
        return false;
      }

      final ok = await completer.future
          .timeout(const Duration(minutes: 3), onTimeout: () => false);
      _user = _client.auth.currentUser;
      return ok && isAuthenticated;
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
      return false;
    } catch (_) {
      _error = failKey;
      return false;
    } finally {
      await sub?.cancel();
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _client.auth.signOut();
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    _setLoading(true);
    _error = null;
    try {
      // delete_user() PostgreSQL 함수로 auth.users에서 본인 계정 삭제
      // ON DELETE CASCADE → public.users → challenges → sub_routines, daily_logs 자동 삭제
      await _client.rpc('delete_user');
      await _client.auth.signOut();
      _user = null;
      return true;
    } on AuthException catch (e) {
      _error = _parseAuthError(e.message);
      return false;
    } catch (e) {
      _error = 'unknown_error';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
