import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/daily_log.dart';

class DailyLogCard extends StatelessWidget {
  final DailyLog log;
  final VoidCallback onDelete;

  const DailyLogCard({
    super.key,
    required this.log,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM d · h:mm a').format(log.timestamp);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day ${log.day} · $formattedDate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
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
