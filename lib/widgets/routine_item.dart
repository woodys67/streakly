import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';

class RoutineItem extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onToggle;
  final void Function(String subRoutineId)? onSubRoutineToggle;

  const RoutineItem({
    super.key,
    required this.challenge,
    required this.onToggle,
    this.onSubRoutineToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = challenge.isTodayCompleted;
    final hasSubs = challenge.subRoutines.isNotEmpty;

    // progress for the bar: if sub-routines exist, ratio of completed subs
    double progress;
    if (hasSubs) {
      final completedCount = challenge.subRoutines
          .where((s) => challenge.isSubRoutineCompletedToday(s.id))
          .length;
      progress = completedCount / challenge.subRoutines.length;
    } else {
      progress = isCompleted ? 1.0 : 0.0;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? AppColors.success : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main circle — tappable only when no sub-routines
          GestureDetector(
            onTap: hasSubs ? null : onToggle,
            child: Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.success : AppColors.white,
                border: Border.all(
                  color: isCompleted ? AppColors.success : AppColors.border,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: AppColors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
                if (challenge.reminderTime.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    challenge.reminderTime,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (hasSubs) ...[
                  const SizedBox(height: 10),
                  ...challenge.subRoutines.map((sub) {
                    final subDone = challenge.isSubRoutineCompletedToday(sub.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => onSubRoutineToggle?.call(sub.id),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: subDone
                                    ? AppColors.success
                                    : AppColors.white,
                                border: Border.all(
                                  color: subDone
                                      ? AppColors.success
                                      : AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              child: subDone
                                  ? const Icon(Icons.check,
                                      color: AppColors.white, size: 13)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sub.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subDone
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  decoration: subDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (sub.time.isNotEmpty)
                              Text(
                                sub.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 8),
                _ProgressBar(progress: progress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.border,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
        minHeight: 6,
      ),
    );
  }
}
