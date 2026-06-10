import 'package:flutter/material.dart';
import '../../utils/ascii_only_formatter.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.sendPasswordResetEmail(_emailController.text.trim());
    if (auth.error == null && mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _emailSent
                ? _SuccessView(
                    email: _emailController.text.trim(),
                    onBack: () => Navigator.of(context).pop(),
                  )
                : _FormView(
                    formKey: _formKey,
                    emailController: _emailController,
                    auth: auth,
                    onSend: () => _sendResetEmail(auth),
                  ),
          );
        },
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final AuthProvider auth;
  final VoidCallback onSend;

  const _FormView({
    required this.formKey,
    required this.emailController,
    required this.auth,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            s.forgotPasswordTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            s.forgotPasswordSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              AsciiOnlyFormatter(
                onBlocked: () {
                  final s = context.read<SettingsProvider>().strings;
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(
                      content: Text(s.emailEnglishOnly),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ));
                },
              ),
            ],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return s.emailRequired;
              if (!v.contains('@')) return s.emailInvalid;
              return null;
            },
            decoration: InputDecoration(
              labelText: s.emailLabel,
              hintText: 'example@email.com',
              prefixIcon: const Icon(Icons.email_outlined,
                  color: AppColors.textSecondary, size: 20),
            ),
          ),
          const SizedBox(height: 20),
          if (auth.error != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      auth.error!,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.error, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: auth.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      s.sendResetEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onBack;

  const _SuccessView({required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: AppColors.success,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          s.emailSentTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          s.emailSentDesc(email),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              s.backToSignIn,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
