import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/challenge_provider.dart';
import '../providers/settings_provider.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChallengeProvider>();
    final willpower = provider.effectiveWillpower;
    final todayWillpower = provider.todayWillpower;
    final s = context.watch<SettingsProvider>().strings;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.myWillpower} $willpower',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      s.willpowerSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (todayWillpower > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+$todayWillpower',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _LevelGauge(willpower: willpower, s: s),
        ],
      ),
    );
  }
}

class _LevelGauge extends StatelessWidget {
  final int willpower;
  final dynamic s;

  const _LevelGauge({required this.willpower, required this.s});

  // 레벨 진입 점수 테이블 (인덱스 0 = Lv.1 진입, 인덱스 25 = 만렙 완성)
  static const List<int> _thresholds = [
       0,  10,  22,  37,  54,   // Lv.1–5  🌱 씨앗
      74,  96, 121, 148, 178,   // Lv.6–10 🌿 새싹
     210, 245, 282, 322, 365,   // Lv.11–15 🌳 성장
     410, 458, 508, 561, 616,   // Lv.16–20 🌸 결실
     674, 734, 797, 862, 930,   // Lv.21–25 ⚡ 전설
    1000,
  ];

  int get _level {
    final capped = willpower.clamp(0, 1000);
    for (int i = _thresholds.length - 2; i >= 0; i--) {
      if (capped >= _thresholds[i]) return i + 1;
    }
    return 1;
  }

  double get _progress {
    if (willpower >= 1000) return 1.0;
    final lv = _level;
    final current = _thresholds[lv - 1];
    final next = _thresholds[lv];
    return (willpower - current) / (next - current);
  }

  String get _tierEmoji {
    final lv = _level;
    if (lv <= 5) return '🌱';
    if (lv <= 10) return '🌿';
    if (lv <= 15) return '🌳';
    if (lv <= 20) return '🌸';
    return '⚡';
  }

  String _tierName() {
    final lv = _level;
    if (lv <= 5) return s.tierSeed;
    if (lv <= 10) return s.tierSprout;
    if (lv <= 15) return s.tierGrowth;
    if (lv <= 20) return s.tierFruition;
    return s.tierLegend;
  }

  @override
  Widget build(BuildContext context) {
    final lv = _level;
    final isMax = willpower >= 1000;
    final nextThreshold = isMax ? 1000 : _thresholds[lv];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$_tierEmoji ${_tierName()}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lv.$lv',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              isMax ? 'MAX ✨' : '$willpower / $nextThreshold',
              style: TextStyle(
                fontSize: 12,
                color: isMax ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isMax ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
