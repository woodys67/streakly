import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/migration_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/social_login_buttons.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onAuthSuccess(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final challengeProvider = context.read<ChallengeProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    // userId와 displayName을 await 이전에 캡처 — 이후 onAuthStateChange 이벤트로
    // _user가 바뀌어도 올바른 값을 유지.
    final userId = auth.userId;
    final displayName = auth.displayName;

    if (userId.isEmpty) {
      if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // public.users 행 확보 (challenges FK 삽입을 위해 먼저 실행)
    await settingsProvider.loadSettings(
      fallbackDisplayName: displayName,
      userId: userId,
    );

    final result = await challengeProvider.syncLocalToCloud(userId: userId);

    if (!context.mounted) return;

    if (result.status == MigrationStatus.failed &&
        result.error != null &&
        result.error != '로그인 상태가 아닙니다') {
      final s = context.read<SettingsProvider>().strings;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${s.migrationError} ${result.error}'),
          backgroundColor: AppColors.error,
        ),
      );
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _signInWithEmail(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await auth.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (ok && mounted) await _onAuthSuccess(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final s = context.read<SettingsProvider>().strings;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    s.signInWelcome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.signInSubtitle,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  _EmailField(controller: _emailController),
                  const SizedBox(height: 14),
                  _PasswordField(
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    label: s.passwordLabel,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()),
                      ),
                      child: Text(
                        s.forgotPassword,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (auth.error != null) ...[
                    _ErrorBox(message: auth.error!),
                    if (auth.isEmailNotConfirmed)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: auth.isLoading
                              ? null
                              : () => auth.resendConfirmationEmail(
                                    _emailController.text.trim(),
                                  ),
                          child: Text(
                            s.resendConfirmEmail,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 4),
                  _PrimaryButton(
                    label: s.signIn,
                    isLoading: auth.isLoading,
                    onPressed: () => _signInWithEmail(auth),
                  ),
                  const SizedBox(height: 20),
                  const SocialLoginDivider(),
                  const SizedBox(height: 16),
                  SocialLoginButtons(
                    onSuccess: () => _onAuthSuccess(context),
                  ),
                  const SizedBox(height: 28),
                  _AuthLinkRow(
                    question: s.noAccountQuestion,
                    linkText: s.signUp,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Sign Up Screen
// ─────────────────────────────────────────────────────────

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onAuthSuccess(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final challengeProvider = context.read<ChallengeProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    final userId = auth.userId;
    final displayName = auth.displayName;

    if (userId.isEmpty) {
      if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    await settingsProvider.loadSettings(
      fallbackDisplayName: displayName,
      userId: userId,
    );

    final result = await challengeProvider.syncLocalToCloud(userId: userId);

    if (!context.mounted) return;

    if (result.status == MigrationStatus.failed &&
        result.error != null &&
        result.error != '로그인 상태가 아닙니다') {
      final s = context.read<SettingsProvider>().strings;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${s.migrationError} ${result.error}'),
          backgroundColor: AppColors.error,
        ),
      );
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _signUp(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await auth.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );
    if (ok && mounted) await _onAuthSuccess(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final s = context.read<SettingsProvider>().strings;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    s.signUpTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.signUpSubtitle,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  _TextField(
                    controller: _nameController,
                    label: s.nicknameLabel,
                    hint: s.nicknameHint,
                    icon: Icons.person_outline,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? s.nicknameRequired : null,
                  ),
                  const SizedBox(height: 14),
                  _EmailField(controller: _emailController),
                  const SizedBox(height: 14),
                  _PasswordField(
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    label: s.passwordWithMin,
                    validator: (v) =>
                        (v == null || v.length < 8) ? s.passwordMinLength : null,
                  ),
                  const SizedBox(height: 14),
                  _PasswordField(
                    controller: _confirmController,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    label: s.confirmPasswordLabel,
                    validator: (v) => v != _passwordController.text
                        ? s.passwordMismatch
                        : null,
                  ),
                  const SizedBox(height: 20),
                  if (auth.error != null)
                    _ErrorBox(message: auth.error!),
                  const SizedBox(height: 4),
                  _PrimaryButton(
                    label: s.signUp,
                    isLoading: auth.isLoading,
                    onPressed: () => _signUp(auth),
                  ),
                  const SizedBox(height: 20),
                  const SocialLoginDivider(),
                  const SizedBox(height: 16),
                  SocialLoginButtons(
                    onSuccess: () => _onAuthSuccess(context),
                  ),
                  const SizedBox(height: 28),
                  _AuthLinkRow(
                    question: s.alreadyHaveAccount,
                    linkText: s.signIn,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return _TextField(
      controller: controller,
      label: s.emailLabel,
      hint: 'example@email.com',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return s.emailRequired;
        if (!v.contains('@')) return s.emailInvalid;
        return null;
      },
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String label;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator ??
          (v) => (v == null || v.isEmpty)
              ? context.read<SettingsProvider>().strings.passwordRequired
              : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: '••••••••',
        prefixIcon:
            const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;

  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.error, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthLinkRow extends StatelessWidget {
  final String question;
  final String linkText;
  final VoidCallback onTap;

  const _AuthLinkRow({
    required this.question,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
