import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Apple — 검정 원 안에 로고 패딩으로 Google과 시각적 크기 통일
        GestureDetector(
          onTap: isLoading ? null : () => _handleApple(context),
          child: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/logo_apple.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Google — 흰 배경 이미지를 원형으로 clip
        GestureDetector(
          onTap: isLoading ? null : () => _handleGoogle(context),
          child: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo_google.png',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
