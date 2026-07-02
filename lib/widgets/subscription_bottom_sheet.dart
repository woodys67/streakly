import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SubscriptionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s    = context.read<SettingsProvider>().strings;
    final sub  = context.watch<SubscriptionProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 20, 24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium,
                color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 14),

          Text(s.subscribeProTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(s.subscribeProSubtitle,
              style: TextStyle(fontSize: 14, color: context.colorTextSecondary)),
          const SizedBox(height: 20),

          _BenefitRow(icon: Icons.flag_outlined,
              label: s.subscribeBenefitUnlimitedChallenges),
          const SizedBox(height: 10),
          _BenefitRow(icon: Icons.refresh,
              label: s.subscribeBenefitInstantRecovery),
          const SizedBox(height: 10),
          _BenefitRow(icon: Icons.pause_circle_outline,
              label: s.subscribeBenefitPause),
          const SizedBox(height: 24),

          // 스토어 연결 불가
          if (!sub.isStoreAvailable) ...[
            Text(s.subscribeStoreUnavailable,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colorTextSecondary, fontSize: 14)),
            const SizedBox(height: 12),
          ]

          // 구매 처리 중
          else if (sub.isLoading) ...[
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 12),
          ]

          // 에러
          else if (sub.purchaseError != null) ...[
            Text(sub.purchaseError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 13)),
            const SizedBox(height: 12),
            _planButtons(context, sub, s),
          ]

          // 정상
          else
            _planButtons(context, sub, s),

          const SizedBox(height: 12),

          // 복원 버튼
          TextButton(
            onPressed: sub.isLoading
                ? null
                : () async {
                    final wasEmpty = !sub.isPremium;
                    await sub.restorePurchases();
                    if (!context.mounted) return;
                    final msg = sub.isPremium && wasEmpty
                        ? s.subscribeRestoreSuccess
                        : s.subscribeRestoreEmpty;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  },
            child: Text(s.subscribeRestore,
                style: TextStyle(fontSize: 14, color: context.colorTextSecondary)),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.subscribeLater,
                style: TextStyle(fontSize: 14, color: context.colorTextSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _planButtons(
      BuildContext context, SubscriptionProvider sub, dynamic s) {
    return Column(
      children: [
        _PlanButton(
          label: s.subscribeMonthly,
          price: sub.monthlyProduct?.price ?? '\$2.99',
          plan: 'monthly',
          isPrimary: false,
        ),
        const SizedBox(height: 10),
        _PlanButton(
          label: s.subscribeAnnual,
          price: sub.annualProduct?.price ?? '\$14.99',
          plan: 'annual',
          isPrimary: true,
          badge: s.subscribeAnnualBadge,
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BenefitRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class _PlanButton extends StatelessWidget {
  final String label;
  final String price;
  final String plan;
  final bool isPrimary;
  final String? badge;

  const _PlanButton({
    required this.label,
    required this.price,
    required this.plan,
    required this.isPrimary,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final sub = context.read<SubscriptionProvider>();

    final button = isPrimary
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await sub.subscribe(plan);
                if (context.mounted && sub.isPremium) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('$label  $price',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await sub.subscribe(plan);
                if (context.mounted && sub.isPremium) {
                  Navigator.of(context).pop();
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('$label  $price',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
          );

    if (badge == null) return button;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: 8, right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.darkAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(badge!,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
