import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';
import '../providers/settings_provider.dart';

class RoutineItem extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onToggle;
  final void Function(String subRoutineId)? onSubRoutineToggle;
  final bool canRecover;
  final VoidCallback? onRecover;

  const RoutineItem({
    super.key,
    required this.challenge,
    required this.onToggle,
    this.onSubRoutineToggle,
    this.canRecover = false,
    this.onRecover,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = challenge.isTodayCompleted;
    final hasSubs = challenge.subRoutines.isNotEmpty;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                    color: subDone ? AppColors.success : AppColors.white,
                                    border: Border.all(
                                      color: subDone ? AppColors.success : AppColors.border,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: subDone
                                      ? const Icon(Icons.check, color: AppColors.white, size: 13)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    sub.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: subDone ? AppColors.textSecondary : AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      decoration: subDone ? TextDecoration.lineThrough : TextDecoration.none,
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
          if (challenge.isCurrentlyPaused) ...[
            const SizedBox(height: 8),
            _PauseBadge(pauseEnd: challenge.activePause!.end),
          ] else if (canRecover) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.watch<SettingsProvider>().strings.recoverStreakHint,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _RecoveryButton(onRecover: onRecover),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RecoveryButton extends StatelessWidget {
  final VoidCallback? onRecover;

  const _RecoveryButton({this.onRecover});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    return GestureDetector(
      onTap: onRecover,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withAlpha(80), width: 1),
        ),
        child: Text(
          s.recoverStreak,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PauseBadge extends StatelessWidget {
  final DateTime pauseEnd;

  const _PauseBadge({required this.pauseEnd});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    final dateStr = '${pauseEnd.year}.${pauseEnd.month.toString().padLeft(2, '0')}.${pauseEnd.day.toString().padLeft(2, '0')}';
    return Row(
      children: [
        const Icon(Icons.pause_circle_outline, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          '${s.pauseActive} · ${s.pauseActiveUntil(dateStr)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
