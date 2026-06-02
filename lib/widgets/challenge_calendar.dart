import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';

class ChallengeCalendar extends StatelessWidget {
  final Challenge challenge;

  const ChallengeCalendar({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final currentDay = challenge.currentDay;
    final targetDays = challenge.targetDays;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: targetDays,
      itemBuilder: (context, index) {
        final day = index + 1;
        final isCompleted = challenge.completedDays.contains(day);
        final isToday = day == currentDay;
        final isFuture = day > currentDay;

        return _DayCell(
          day: day,
          isCompleted: isCompleted,
          isToday: isToday,
          isFuture: isFuture,
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isCompleted;
  final bool isToday;
  final bool isFuture;

  const _DayCell({
    required this.day,
    required this.isCompleted,
    required this.isToday,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BoxBorder? border;

    if (isCompleted) {
      bgColor = AppColors.success;
      textColor = AppColors.white;
      border = null;
    } else if (isToday) {
      bgColor = Colors.transparent;
      textColor = AppColors.primary;
      border = Border.all(
        color: AppColors.primary,
        width: 2,
        style: BorderStyle.solid,
      );
    } else if (isFuture) {
      bgColor = AppColors.background;
      textColor = AppColors.textSecondary;
      border = Border.all(color: AppColors.border, width: 1);
    } else {
      bgColor = AppColors.border;
      textColor = AppColors.textSecondary;
      border = null;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: AppColors.white, size: 14)
            : Text(
                '$day',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
