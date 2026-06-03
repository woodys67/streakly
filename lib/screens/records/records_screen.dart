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
import 'badge_collection_screen.dart';
import 'completed_challenge_detail_screen.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(context.watch<SettingsProvider>().strings.recordsTitle)),
      body: Consumer3<ChallengeProvider, SettingsProvider, BadgeProvider>(
        builder: (context, challengeProvider, settingsProvider, badgeProvider, _) {
          final s = settingsProvider.strings;
          final userName = settingsProvider.userName;
          final successRate = challengeProvider.overallSuccessRate;
          final totalStreak = challengeProvider.totalStreak;
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
                const SizedBox(height: 20),
                _SuccessRateChart(successRate: successRate),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: s.totalStreaks,
                        value: '$totalStreak',
                        bgColor: AppColors.darkAccent,
                        icon: Icons.local_fire_department,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: s.completed,
                        value: '${completed.length}',
                        bgColor: AppColors.success,
                        icon: Icons.emoji_events,
                        showInfo: true,
                        infoMessage: s.completedInfo,
                        okLabel: s.ok,
                      ),
                    ),
                  ],
                ),
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
                        style: const TextStyle(color: AppColors.textSecondary),
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
                        style: const TextStyle(color: AppColors.textSecondary),
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.read<SettingsProvider>().strings.badgeCollectionTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${earned.length} / $total',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
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
                      child: Text(def.icon,
                          style: const TextStyle(fontSize: 28)),
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

class _SuccessRateChart extends StatelessWidget {
  final double successRate;

  const _SuccessRateChart({required this.successRate});

  @override
  Widget build(BuildContext context) {
    final percent = (successRate * 100).round();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          CircularProgressWidget(
            progress: successRate,
            size: 100,
            strokeWidth: 10,
            progressColor: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Builder(
              builder: (context) {
                final s = context.watch<SettingsProvider>().strings;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.successLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.overallRate,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.keepItUp,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;
  final IconData icon;
  final bool showInfo;
  final String? infoMessage;
  final String okLabel;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.bgColor,
    required this.icon,
    this.showInfo = false,
    this.infoMessage,
    this.okLabel = 'OK',
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
              if (showInfo && infoMessage != null)
                GestureDetector(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(infoMessage!),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(okLabel),
                          ),
                        ],
                      ),
                    );
                  },
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
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
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
