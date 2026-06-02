import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/badge_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../services/notification_service.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: Consumer2<SettingsProvider, AuthProvider>(
        builder: (context, settings, auth, _) {
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
                const SizedBox(height: 24),
                _SettingsCard(
                  settings: settings,
                  auth: auth,
                  s: s,
                  onReset: () => _confirmReset(context, settings, s),
                ),
                const SizedBox(height: 24),
                if (!auth.isGuest) ...[
                  _SignOutButton(
                    label: s.signOut,
                    onSignOut: () => _confirmSignOut(context, settings, auth, s),
                  ),
                  const SizedBox(height: 8),
                  _DeleteAccountButton(
                    label: s.deleteAccount,
                    onDelete: () => _confirmDeleteAccount(context, auth, settings, s),
                  ),
                ],
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
    final controller = TextEditingController(text: settings.userName);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.editName),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: s.nameHint),
          onSubmitted: (_) => Navigator.of(dialogContext).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) settings.setUserName(name);
              Navigator.of(dialogContext).pop();
            },
            child: Text(s.save),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
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

    if (confirmed == true && context.mounted) {
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
      await auth.deleteAccount();
      await settings.resetApp();
      await challengeProvider.loadChallenges();
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
      await challengeProvider.clearLocalCache();
      await auth.signOut();
      await settings.signOut();
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
    final displayName = isGuest && userName == 'Streakly User' ? '게스트' : userName;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
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
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    memberLabel,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onNameTap,
            child: const Icon(Icons.edit_outlined,
                color: AppColors.textSecondary, size: 20),
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
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle bar
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              settings.strings.selectProfileImage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(s.appSettings,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          _LanguageSetting(settings: settings, label: s.languages),
          const _Divider(),
          _ToggleSetting(
            icon: Icons.notifications_outlined,
            title: s.notificationSettings,
            value: settings.notificationsEnabled,
            onChanged: (_) async {
              await settings.toggleNotifications();
              if (settings.notificationsEnabled) {
                await NotificationService.rescheduleAll(
                  context.read<ChallengeProvider>().challenges,
                );
              }
            },
          ),
          const _Divider(),
          _NavigationSetting(
            icon: Icons.workspace_premium_outlined,
            title: s.teamChallengeSubscribe,
            onTap: () => _onSubscribeTap(context),
          ),
          const _Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(Icons.restart_alt,
                color: AppColors.textSecondary, size: 22),
            title: Text(
              s.resetApp,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary),
            ),
            onTap: onReset,
          ),
        ],
      ),
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
          const Icon(Icons.language, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
          ),
          DropdownButton<String>(
            value: settings.language,
            underline: const SizedBox(),
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
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
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
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
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary))
          : null,
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 56, color: AppColors.border);
  }
}

class _SignOutButton extends StatelessWidget {
  final String label;
  final VoidCallback onSignOut;

  const _SignOutButton({required this.label, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onSignOut,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const _DeleteAccountButton({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onDelete,
        style: TextButton.styleFrom(foregroundColor: AppColors.error),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.error.withValues(alpha: 0.6),
            decoration: TextDecoration.underline,
            decorationColor: AppColors.error.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
