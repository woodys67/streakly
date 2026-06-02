import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
            _error = '이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.';
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
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded['message'] as String? ?? raw;
    } catch (_) {
      return raw;
    }
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
        _error = '이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.';
      } else {
        _error = e.message;
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
      _error = e.message;
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
      _error = e.message;
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
      _error = e.message;
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
        _error = 'Apple 로그인에 실패했습니다.';
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
        _error = 'Apple 로그인 중 오류가 발생했습니다.';
      }
      return false;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _error = null;
    try {
      final googleSignIn = GoogleSignIn(
        clientId: SupabaseConfig.googleIosClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false; // user cancelled

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        _error = 'Google 로그인에 실패했습니다.';
        return false;
      }

      final res = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      _user = res.user;
      return _user != null;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      return false;
    } finally {
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
      _error = e.message;
      return false;
    } catch (e) {
      _error = e.toString();
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
