import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/challenge.dart';
import '../../providers/badge_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/badge_catalog.dart';
import '../../theme/app_theme.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/native_ad_card.dart';
import 'badge_collection_screen.dart';
import 'completed_challenge_detail_screen.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<SettingsProvider>().strings.recordsTitle)),
      body: Consumer3<ChallengeProvider, SettingsProvider, BadgeProvider>(
        builder: (context, challengeProvider, settingsProvider, badgeProvider, _) {
          final s = settingsProvider.strings;
          final userName = settingsProvider.userName;
          final totalStreak = challengeProvider.totalStreak;
          final longestStreak = challengeProvider.longestStreak;
          final totalRecoveries = challengeProvider.totalRecoveries;
          final completed = challengeProvider.completedChallenges;
          final allChallenges = challengeProvider.challenges;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileHeader(userName: userName),
                const SizedBox(height: 20),
                _BadgeSummaryCard(badgeProvider: badgeProvider),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: s.totalStreaks,
                        value: '$totalStreak',
                        bgColor: AppColors.darkAccent,
                        icon: Icons.local_fire_department,
                        tooltip: s.totalStreaksInfo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: s.completed,
                        value: '${completed.length}',
                        bgColor: AppColors.success,
                        icon: Icons.emoji_events,
                        tooltip: s.completedInfo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: s.longestStreakLabel,
                        value: '$longestStreak',
                        bgColor: const Color(0xFF9C27B0),
                        icon: Icons.military_tech,
                        tooltip: s.longestStreakInfo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: s.streakRecoveryLabel,
                        value: '$totalRecoveries',
                        bgColor: const Color(0xFF0288D1),
                        icon: Icons.refresh,
                        tooltip: s.streakRecoveryInfo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const NativeAdCard(),
                const SizedBox(height: 24),
                Text(
                  s.completedChallenges,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (allChallenges.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        s.noRecordsYet,
                        style: TextStyle(color: context.colorTextSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (completed.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        s.keepGoingRecords,
                        style: TextStyle(color: context.colorTextSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...completed.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CompletedChallengeDetailScreen(challenge: c),
                          ),
                        ),
                        child: _CompletedChallengeCard(challenge: c),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BadgeSummaryCard extends StatelessWidget {
  final BadgeProvider badgeProvider;

  const _BadgeSummaryCard({required this.badgeProvider});

  @override
  Widget build(BuildContext context) {
    final earned = badgeProvider.earned;
    final total = BadgeCatalog.all.length;
    final recentBadges = earned.toList()
      ..sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    final displayBadges = recentBadges.take(5).toList();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BadgeCollectionScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorOutline, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.read<SettingsProvider>().strings.badgeCollectionTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.colorTextPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Tooltip(
                  message: context.read<SettingsProvider>().strings.badgeCollectionInfo,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                  preferBelow: false,
                  child: Icon(Icons.info_outline, size: 16, color: context.colorTextSecondary),
                ),
                const Spacer(),
                Text(
                  '${earned.length} / $total',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: context.colorTextSecondary,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? earned.length / total : 0,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            if (displayBadges.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: displayBadges.map((ub) {
                  final def = BadgeCatalog.findById(ub.badgeId);
                  if (def == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Tooltip(
                      message: def.nameKo,
                      child: Image.asset(def.imagePath, width: 36, height: 36),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                context.read<SettingsProvider>().strings.badgeEarnedEmpty,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String userName;

  const _ProfileHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 28),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                context.watch<SettingsProvider>().strings.habitBuilder,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;
  final IconData icon;
  final String tooltip;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.bgColor,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.white, size: 24),
              Tooltip(
                message: tooltip,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                preferBelow: false,
                child: const Icon(Icons.info_outline, color: AppColors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const _CompletedChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    final successRate = challenge.successRate;
    final successPercent = (successRate * 100).round();
    final startStr = DateFormat('MMM d').format(challenge.startDate);
    final endDate = challenge.startDate
        .add(Duration(days: challenge.targetDays - 1));
    final endStr = DateFormat('MMM d, yyyy').format(endDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      child: Row(
        children: [
          CircularProgressWidget(
            progress: successRate,
            size: 56,
            strokeWidth: 6,
            progressColor: AppColors.success,
            child: Text(
              '$successPercent%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('$startStr - $endStr', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  context.watch<SettingsProvider>().strings.challengeSummary(
                        challenge.targetDays,
                        challenge.completedDays.length,
                      ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: context.colorTextSecondary,
          ),
        ],
      ),
    );
  }
}
