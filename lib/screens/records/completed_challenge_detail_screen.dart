import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/challenge.dart';
import '../../models/daily_log.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/challenge_calendar.dart';
import '../../widgets/circular_progress.dart';

class CompletedChallengeDetailScreen extends StatelessWidget {
  final Challenge challenge;

  const CompletedChallengeDetailScreen({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    final endDate = challenge.startDate.add(Duration(days: challenge.targetDays - 1));
    final startStr = DateFormat('MMM d').format(challenge.startDate);
    final endStr = DateFormat('MMM d, yyyy').format(endDate);
    final successRate = challenge.successRate;
    final successPercent = (successRate * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text(challenge.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colorSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colorOutline, width: 1.5),
              ),
              child: Row(
                children: [
                  CircularProgressWidget(
                    progress: successRate,
                    size: 72,
                    strokeWidth: 7,
                    progressColor: AppColors.success,
                    child: Text(
                      '$successPercent%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$startStr – $endStr',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.challengeSummary(
                            challenge.targetDays,
                            challenge.completedDays.length,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              s.daysChallenge(challenge.targetDays),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colorOutline, width: 1.5),
              ),
              child: ChallengeCalendar(challenge: challenge),
            ),
            if (challenge.logs.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                s.dailyLogs,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...challenge.logs.map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ReadOnlyLogCard(log: log),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyLogCard extends StatelessWidget {
  final DailyLog log;

  const _ReadOnlyLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d · h:mm a').format(log.timestamp);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${log.day} · $formattedDate',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            log.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
