import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as siwa;

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class SocialLoginDivider extends StatelessWidget {
  const SocialLoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            s.orDivider,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

class SocialLoginButtons extends StatelessWidget {
  final Future<void> Function() onSuccess;

  const SocialLoginButtons({super.key, required this.onSuccess});

  Future<void> _handleApple(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithApple();
    if (ok && context.mounted) await onSuccess();
  }

  Future<void> _handleGoogle(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (ok && context.mounted) await onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final s = context.read<SettingsProvider>().strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (Platform.isIOS) ...[
          // Apple Sign In — Apple HIG 준수 커스텀 버튼 (AppleLogoPainter 사용)
          _AppleSignInButton(
            onPressed: isLoading ? null : () => _handleApple(context),
            label: s.continueWithApple,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
        ],
        // Google Sign In — Google 브랜딩 가이드라인 준수 버튼
        _GoogleSignInButton(
          onPressed: isLoading ? null : () => _handleGoogle(context),
          label: s.continueWithGoogle,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isDark;

  const _AppleSignInButton({
    required this.onPressed,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? Colors.white : Colors.black;
    final foregroundColor = isDark ? Colors.black : Colors.white;
    // Apple HIG 기준 폰트 크기: height * 0.43
    const double height = 44;
    const double fontSize = height * 0.43;
    // Apple 로고 비율 (패키지 원본과 동일)
    const double logoWidth = fontSize * (25 / 31);
    const double logoHeight = fontSize;

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: SizedBox(
        height: height,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.zero,
          color: backgroundColor,
          // 로딩 중에는 no-op으로 CupertinoButton 자체 비활성 스타일 방지
          onPressed: onPressed ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: logoWidth,
                  height: logoHeight,
                  child: CustomPaint(
                    painter: siwa.AppleLogoPainter(color: foregroundColor),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    inherit: false,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                    fontFamily: '.SF Pro Text',
                    letterSpacing: -0.41,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isDark;

  const _GoogleSignInButton({
    required this.onPressed,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Google 브랜딩 가이드라인 공식 색상
    final backgroundColor =
        isDark ? const Color(0xFF131314) : const Color(0xFFFFFFFF);
    final borderColor =
        isDark ? const Color(0xFF8E918F) : const Color(0xFF747775);
    final textColor =
        isDark ? const Color(0xFFE3E3E3) : const Color(0xFF1F1F1F);

    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_google.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: onPressed == null
                    ? textColor.withValues(alpha: 0.5)
                    : textColor,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
