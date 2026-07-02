import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/badge_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/subscription_bottom_sheet.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import 'guide_detail_screen.dart';
import 'guide_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/flame.png', width: 22, height: 22),
            const SizedBox(width: 8),
            Text(
              'Streakly',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: const [],
      ),
      body: Consumer3<SettingsProvider, AuthProvider, SubscriptionProvider>(
        builder: (context, settings, auth, subscription, _) {
          final s = settings.strings;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _ProfileCard(
                  userName: settings.userName,
                  profileImage: settings.profileImage,
                  email: auth.userEmail,
                  isGuest: auth.isGuest,
                  memberLabel: s.streaklyMember,
                  loginLabel: s.loginOrSignUp,
                  onAvatarTap: () => _selectProfileImage(context, settings),
                  onNameTap: () => _editName(context, settings, s),
                  onLoginTap: () => _goToSignIn(context),
                ),
                const SizedBox(height: 12),
                _SubscriptionCard(
                  subscription: subscription,
                  s: s,
                  onSubscribe: () => SubscriptionBottomSheet.show(context),
                  onCancel: () => _confirmCancelSubscription(context, subscription, s),
                ),
                const SizedBox(height: 12),
                _SettingsCard(
                  settings: settings,
                  auth: auth,
                  s: s,
                  onReset: () => _confirmReset(context, settings, s),
                ),
                const SizedBox(height: 12),
                _AppGuideCard(s: s),
                const SizedBox(height: 12),
                _LegalCard(s: s),
                const SizedBox(height: 12),
                if (!auth.isGuest) ...[
                  _AccountCard(
                    signOutLabel: s.signOut,
                    deleteAccountLabel: s.deleteAccount,
                    onSignOut: () => _confirmSignOut(context, settings, auth, s),
                    onDelete: () => _confirmDeleteAccount(context, auth, settings, s),
                  ),
                ],
                const SizedBox(height: 8),
                _AppVersionText(versionLabel: s.appVersion),
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToSignIn(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SignInScreen()));
  }

  Future<void> _selectProfileImage(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileImagePicker(settings: settings),
    );
  }

  Future<void> _editName(
    BuildContext context,
    SettingsProvider settings,
    dynamic s,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _EditNameDialog(settings: settings, s: s),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    SettingsProvider settings,
    dynamic s,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.resetApp),
        content: Text(s.resetAppConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(s.resetApp),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final doubleConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.resetApp),
        content: Text(s.resetAppConfirm2),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(s.resetAppFinal),
          ),
        ],
      ),
    );

    if (doubleConfirmed == true && context.mounted) {
      final challengeProvider = context.read<ChallengeProvider>();
      final auth = context.read<AuthProvider>();

      // 로그인 유저는 서버 데이터도 삭제
      if (auth.isAuthenticated) {
        await challengeProvider.deleteAllServerData();
      }

      await settings.resetApp();
      await challengeProvider.clearLocalCache();
      if (context.mounted) {
        context.read<BadgeProvider>().resetLocal();
      }
    }
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    AuthProvider auth,
    SettingsProvider settings,
    dynamic s,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.deleteAccount),
        content: Text(s.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(s.deleteAccount),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final challengeProvider = context.read<ChallengeProvider>();
      final badgeProvider = context.read<BadgeProvider>();

      final success = await auth.deleteAccount();
      if (success) {
        await settings.resetApp();
        await challengeProvider.clearLocalCache();
        await badgeProvider.resetLocal();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.error ?? context.read<SettingsProvider>().strings.deleteAccountFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    SettingsProvider settings,
    AuthProvider auth,
    dynamic s,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.signOut),
        content: Text(s.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(s.signOut),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final challengeProvider = context.read<ChallengeProvider>();
      final badgeProvider = context.read<BadgeProvider>();
      await challengeProvider.clearLocalCache();
      await badgeProvider.resetLocal();
      await auth.signOut();
      await settings.signOut();
    }
  }

  Future<void> _confirmCancelSubscription(
    BuildContext context,
    SubscriptionProvider subscription,
    dynamic s,
  ) async {
    // 테스트 계정은 구독 관리 불필요
    if (subscription.planType == 'test') return;

    // 실제 구독 → OS 구독 관리 페이지로 이동
    final url = Uri.parse(subscription.manageSubscriptionUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// ─────────────────────────────────────────────────────────
// Profile Card
// ─────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final String userName;
  final String profileImage;
  final String email;
  final bool isGuest;
  final String memberLabel;
  final String loginLabel;
  final VoidCallback onAvatarTap;
  final VoidCallback? onNameTap;
  final VoidCallback onLoginTap;

  const _ProfileCard({
    required this.userName,
    required this.profileImage,
    required this.email,
    required this.isGuest,
    required this.memberLabel,
    required this.loginLabel,
    required this.onAvatarTap,
    required this.onNameTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final displayName = isGuest && userName == 'Streakly User' ? s.guestDisplayName : userName;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      child: Row(
        children: [
          // 아바타 (탭하면 이미지 선택)
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isGuest
                        ? AppColors.textSecondary.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: isGuest ? AppColors.textSecondary : AppColors.primary,
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(
                    child: profileImage.isNotEmpty
                        ? Image.asset(profileImage, fit: BoxFit.cover)
                        : Icon(
                            Icons.person,
                            color: isGuest ? AppColors.textSecondary : AppColors.primary,
                            size: 32,
                          ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(Icons.add, color: AppColors.white, size: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 3),
                if (isGuest)
                  GestureDetector(
                    onTap: onLoginTap,
                    child: Text(
                      loginLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else ...[
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyle(
                        color: context.colorTextSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    memberLabel,
                    style: TextStyle(
                        color: context.colorTextSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onNameTap,
            child: Icon(Icons.edit_outlined,
                color: context.colorTextSecondary, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Profile Image Picker Bottom Sheet
// ─────────────────────────────────────────────────────────

class _ProfileImagePicker extends StatelessWidget {
  final SettingsProvider settings;

  const _ProfileImagePicker({required this.settings});

  @override
  Widget build(BuildContext context) {
    const images = SettingsProvider.profileImages;
    final labels = context.watch<SettingsProvider>().strings.profileImageLabels;

    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle bar
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: context.colorOutline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              settings.strings.selectProfileImage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.colorTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final path = images[index];
              final isSelected = settings.profileImage == path;
              final label = index < labels.length ? labels[index] : '';
              return GestureDetector(
                onTap: () {
                  settings.setProfileImage(path);
                  Navigator.of(context).pop();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                )]
                              : null,
                        ),
                        child: ClipOval(
                          child: Image.asset(path, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : context.colorTextSecondary,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Settings Card
// ─────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final SettingsProvider settings;
  final AuthProvider auth;
  final dynamic s;
  final VoidCallback onReset;

  const _SettingsCard(
      {required this.settings, required this.auth, required this.s, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return _CollapsibleCard(
      title: s.appSettings,
      children: [
        _LanguageSetting(settings: settings, label: s.languages),
        const _Divider(),
        _ToggleSetting(
          icon: Icons.notifications_outlined,
          title: s.notificationSettings,
          value: settings.notificationsEnabled,
          onChanged: (_) async {
            final challenges = context.read<ChallengeProvider>().challenges;
            await settings.toggleNotifications();
            if (settings.notificationsEnabled) {
              final granted = await NotificationService.requestPermission();
              if (!granted) {
                await settings.toggleNotifications();
                if (context.mounted) {
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(s.notificationPermissionDeniedTitle),
                      content: Text(s.notificationPermissionDeniedBody),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(s.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            if (Platform.isIOS) {
                              final uri = Uri.parse('app-settings:');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                AppSettings.openAppSettings(
                                  type: AppSettingsType.settings,
                                );
                              }
                            } else {
                              AppSettings.openAppSettings(
                                type: AppSettingsType.notification,
                              );
                            }
                          },
                          child: Text(s.goToSettings),
                        ),
                      ],
                    ),
                  );
                }
                return;
              }
              await NotificationService.rescheduleAll(challenges);
            }
          },
        ),
        const _Divider(),
        _ToggleSetting(
          icon: Icons.dark_mode_outlined,
          title: s.darkMode,
          value: settings.darkMode,
          onChanged: (_) => settings.toggleDarkMode(),
        ),
        const _Divider(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(Icons.restart_alt,
              color: context.colorTextSecondary, size: 22),
          title: Text(
            s.resetApp,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: context.colorTextSecondary),
          ),
          onTap: onReset,
        ),
      ],
    );
  }

  void _onSubscribeTap(BuildContext context) {
    if (auth.isGuest) {
      _showLoginPromptSheet(context);
    } else {
      _showSubscriptionSheet(context);
    }
  }

  void _showLoginPromptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium,
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              s.teamChallengeSubscribe,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              s.teamChallengeLoginRequired,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  s.signUpAction,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  s.alreadyHaveAccountAction,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.darkAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium,
                  color: AppColors.darkAccent, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              s.teamChallengeSubscribe,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              s.teamChallengeSubscribeDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  s.subscribeNow,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionProvider subscription;
  final dynamic s;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  const _SubscriptionCard({
    required this.subscription,
    required this.s,
    required this.onSubscribe,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = subscription.isPremium;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  s.subscribeProTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.premiumLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (isPremium) ...[
              Text(
                subscription.planType == 'annual'
                    ? s.subscribeCurrentPlanAnnual
                    : subscription.planType == 'test'
                        ? s.subscribeCurrentPlanTest
                        : s.subscribeCurrentPlanMonthly,
                style: TextStyle(fontSize: 14, color: context.colorTextSecondary),
              ),
              const SizedBox(height: 12),
              // 테스트 계정은 구독 관리 버튼 숨김
              if (subscription.planType != 'test')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      s.subscribeManage,
                      style: const TextStyle(color: AppColors.error, fontSize: 14),
                    ),
                  ),
                ),
            ] else ...[
              Text(
                s.subscribeProSubtitle,
                style: TextStyle(fontSize: 13, color: context.colorTextSecondary),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: subscription.isLoading ? null : onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: subscription.isLoading
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.white))
                      : Text(
                          s.subscribeNow,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              // iOS App Store 가이드라인 필수: 구매 복원 버튼
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: subscription.isLoading
                      ? null
                      : () async {
                          final wasEmpty = !subscription.isPremium;
                          await subscription.restorePurchases();
                          if (!context.mounted) return;
                          final msg = subscription.isPremium && wasEmpty
                              ? s.subscribeRestoreSuccess
                              : s.subscribeRestoreEmpty;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(msg)));
                        },
                  child: Text(s.subscribeRestore,
                      style: TextStyle(
                          fontSize: 13, color: context.colorTextSecondary)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  final SettingsProvider settings;
  final String label;

  const _LanguageSetting({required this.settings, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.language, color: context.colorTextSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: context.colorTextPrimary),
            ),
          ),
          DropdownButton<String>(
            value: settings.language,
            underline: const SizedBox(),
            style: TextStyle(
                color: context.colorTextSecondary, fontSize: 13),
            items: SettingsProvider.availableLanguages
                .map((lang) => DropdownMenuItem<String>(
                      value: lang['code'],
                      child: Text(lang['label']!),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) settings.setLanguage(value);
            },
          ),
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSetting({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: context.colorTextSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: context.colorTextPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _NavigationSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _NavigationSetting({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorTextSecondary, size: 22),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: context.colorTextPrimary),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(
                  fontSize: 12, color: context.colorTextSecondary))
          : null,
      trailing:
          Icon(Icons.chevron_right, color: context.colorTextSecondary),
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 56, color: context.colorOutline);
  }
}

class _CollapsibleCard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const _CollapsibleCard({required this.title, required this.children});

  @override
  State<_CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<_CollapsibleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: context.colorTextSecondary, size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(children: widget.children)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _AppGuideCard extends StatelessWidget {
  final dynamic s;

  const _AppGuideCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return _CollapsibleCard(
      title: s.appGuide,
      children: [
        _GuideItem(icon: Icons.lightbulb_outline,              title: s.guideHowToUse,        content: GuideContent.howToUse(s)),
        const _Divider(),
        _GuideItem(icon: Icons.add_circle_outline,             title: s.guideCreateChallenge, content: GuideContent.createChallenge(s)),
        const _Divider(),
        _GuideItem(icon: Icons.local_fire_department_outlined, title: s.guideStreakSystem,    content: GuideContent.streakSystem(s)),
        const _Divider(),
        _GuideItem(icon: Icons.replay_outlined,                title: s.guideStreakRecovery,  content: GuideContent.streakRecovery(s)),
        const _Divider(),
        _GuideItem(icon: Icons.pause_circle_outline,           title: s.guidePauseTicket,     content: GuideContent.pauseTicket(s)),
        const _Divider(),
        _GuideItem(icon: Icons.bolt_outlined,                  title: s.guideWillpower,       content: GuideContent.willpower(s)),
        const _Divider(),
        _GuideItem(icon: Icons.military_tech_outlined,         title: s.guideBadge,           content: GuideContent.badge(s)),
      ],
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _GuideItem({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: context.colorTextSecondary, size: 22),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: context.colorTextPrimary),
      ),
      trailing: Icon(Icons.chevron_right, color: context.colorTextSecondary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GuideDetailScreen(icon: icon, title: title, content: content),
        ),
      ),
    );
  }
}

class _LegalCard extends StatelessWidget {
  final dynamic s;

  const _LegalCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return _CollapsibleCard(
      title: s.legalInfo,
      children: [
        _NavigationSetting(
          icon: Icons.privacy_tip_outlined,
          title: s.privacyPolicy,
          onTap: () => _launchLegalUrl(context, _legalUrl(context, 'privacy_policy')),
        ),
        const _Divider(),
        _NavigationSetting(
          icon: Icons.description_outlined,
          title: s.termsOfService,
          onTap: () => _launchLegalUrl(context, _legalUrl(context, 'terms_of_service')),
        ),
      ],
    );
  }
}

String _legalUrl(BuildContext context, String page) {
  final lang = context.read<SettingsProvider>().language;
  final suffix = switch (lang) {
    'Korean'   => '',
    'Japanese' => '_ja',
    'Spanish'  => '_es',
    _          => '_en',
  };
  return 'https://dotone.kr/$page$suffix.html';
}

Future<void> _launchLegalUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('페이지를 열 수 없습니다.')),
      );
    }
  }
}

class _AccountCard extends StatelessWidget {
  final String signOutLabel;
  final String deleteAccountLabel;
  final VoidCallback onSignOut;
  final VoidCallback onDelete;

  const _AccountCard({
    required this.signOutLabel,
    required this.deleteAccountLabel,
    required this.onSignOut,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return _CollapsibleCard(
      title: s.accountSection,
      children: [
        _AccountRow(
          icon: Icons.logout,
          iconBgColor: AppColors.primary.withValues(alpha: 0.12),
          iconColor: AppColors.primary,
          label: signOutLabel,
          labelColor: context.colorTextPrimary,
          chevronColor: context.colorTextSecondary,
          onTap: onSignOut,
        ),
        Divider(height: 1, indent: 72, color: context.colorOutline),
        _AccountRow(
          icon: Icons.person_remove_outlined,
          iconBgColor: AppColors.error.withValues(alpha: 0.10),
          iconColor: AppColors.error,
          label: deleteAccountLabel,
          labelColor: AppColors.error,
          chevronColor: AppColors.error,
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final Color chevronColor;
  final VoidCallback onTap;

  const _AccountRow({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.chevronColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: chevronColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AppVersionText extends StatefulWidget {
  final String versionLabel;

  const _AppVersionText({required this.versionLabel});

  @override
  State<_AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<_AppVersionText> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_version.isEmpty) return const SizedBox.shrink();
    return Text(
      '${widget.versionLabel} $_version',
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _EditNameDialog extends StatefulWidget {
  final dynamic settings;
  final dynamic s;
  const _EditNameDialog({required this.settings, required this.s});

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.settings.userName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) widget.settings.setUserName(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return AlertDialog(
      title: Text(s.editName),
      content: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(hintText: s.nameHint),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        TextButton(
          onPressed: _save,
          child: Text(s.save),
        ),
      ],
    );
  }
}
