import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';
import '../providers/settings_provider.dart';

class StreakCard extends StatelessWidget {
  final Challenge challenge;

  const StreakCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final streak = challenge.streak;
    final currentDay = challenge.currentDay;
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
            children: [
              Image.asset('assets/images/flame.png', width: 32, height: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.daysOnFire(streak),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    s.currentStreak,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DayDots(
            targetDays: challenge.targetDays,
            completedDays: challenge.completedDays,
            currentDay: currentDay,
          ),
        ],
      ),
    );
  }
}

class _DayDots extends StatelessWidget {
  final int targetDays;
  final List<int> completedDays;
  final int currentDay;

  const _DayDots({
    required this.targetDays,
    required this.completedDays,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    const dotsToShow = 7;
    final startDay = (currentDay - dotsToShow + 1).clamp(1, currentDay);
    final days = List.generate(
      dotsToShow,
      (i) => startDay + i,
    ).where((d) => d <= targetDays).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isCompleted = completedDays.contains(day);
        final isToday = day == currentDay;
        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primary
                    : isToday
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.border,
                border: isToday
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              'D$day',
              style: TextStyle(
                fontSize: 10,
                color: isToday ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
