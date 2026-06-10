import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/challenge.dart';
import '../../models/routine.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/challenge_calendar.dart';
import '../../widgets/daily_log_card.dart';
import 'new_challenge_screen.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChallengeProvider, SettingsProvider>(
      builder: (context, provider, settings, _) {
        final s = settings.strings;
        final challenge = provider.selectedChallenge;

        if (challenge == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: Text(s.challengeTab)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    s.noActiveChallenge,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.noActiveChallengeDesc,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NewChallengeScreen()),
                    ),
                    child: Text(s.createChallenge),
                  ),
                ],
              ),
            ),
          );
        }

        final progress = challenge.completedDays.length / challenge.targetDays;
        final streak = challenge.streak;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(challenge.name),
            centerTitle: true,
            actions: [
              if (provider.activeChallenges.length > 1)
                PopupMenuButton<int>(
                  icon: const Icon(Icons.list),
                  onSelected: provider.selectChallenge,
                  itemBuilder: (_) => provider.activeChallenges
                      .asMap()
                      .entries
                      .map((e) => PopupMenuItem(value: e.key, child: Text(e.value.name)))
                      .toList(),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _ProgressSection(
                  progress: progress,
                  completedDays: challenge.completedDays.length,
                  targetDays: challenge.targetDays,
                  streak: streak,
                  s: s,
                ),
                const SizedBox(height: 16),
                _ScheduleInfoSection(
                  reminderTime: challenge.reminderTime,
                  repeatDays: challenge.repeatDays,
                  s: s,
                ),
                const SizedBox(height: 16),
                _PauseSection(
                  challenge: challenge,
                  s: s,
                  onUsePause: () => _showPauseFlow(context, provider, challenge, s),
                  onCancelPause: () => _showPauseCancelDialog(context, provider, challenge, s),
                ),
                if (challenge.subRoutines.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SubRoutinesSection(subRoutines: challenge.subRoutines, s: s),
                ],
                if (challenge.notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _NotesSection(notes: challenge.notes, s: s),
                ],
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    s.daysChallenge(challenge.targetDays),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                ChallengeCalendar(challenge: challenge),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.dailyLogs, style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      s.entriesCount(challenge.logs.length),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (challenge.logs.isEmpty) ...[
                  _EmptyLogsPlaceholder(
                    onShareTap: () => _showAddLogDialog(context, provider, challenge.id, s),
                    s: s,
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: () => _showAddLogDialog(context, provider, challenge.id, s),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(s.shareThoughtButton),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...challenge.logs.reversed.map(
                    (log) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DailyLogCard(
                        log: log,
                        onDelete: () => provider.deleteDailyLog(challenge.id, log.id),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context, provider, challenge.id, s),
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                    label: Text(
                      s.deleteChallenge,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPauseFlow(
    BuildContext context,
    ChallengeProvider provider,
    Challenge challenge,
    dynamic s,
  ) async {
    if (provider.challenges.firstWhere((c) => c.id == challenge.id).isCurrentlyPaused) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.pauseAlreadyActive), duration: const Duration(seconds: 2)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.pauseTicketTitle),
        content: Text(s.pauseTicketDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(s.pauseTicketBuy, style: const TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: now,
        end: now.add(const Duration(days: 2)),
      ),
      helpText: s.pauseSelectPeriod,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );

    if (range == null || !context.mounted) return;

    await provider.addPause(challenge.id, range.start, range.end);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.pauseActivated),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showPauseCancelDialog(
    BuildContext context,
    ChallengeProvider provider,
    Challenge challenge,
    dynamic s,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.pauseCancelConfirmTitle),
        content: Text(s.pauseCancelConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(s.pauseCancel, style: const TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await provider.removePause(challenge.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.pauseCancelled), duration: const Duration(seconds: 2)),
      );
    }
  }

  Future<void> _showAddLogDialog(
    BuildContext context,
    ChallengeProvider provider,
    String challengeId,
    dynamic s,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _AddLogDialog(challengeId: challengeId, provider: provider, s: s),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ChallengeProvider provider,
    String challengeId,
    dynamic s,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.deleteChallenge),
        content: Text(s.deleteChallengeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(s.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      provider.deleteChallenge(challengeId);
    }
  }
}

class _AddLogDialog extends StatefulWidget {
  final String challengeId;
  final ChallengeProvider provider;
  final dynamic s;

  const _AddLogDialog({required this.challengeId, required this.provider, required this.s});

  @override
  State<_AddLogDialog> createState() => _AddLogDialogState();
}

class _AddLogDialogState extends State<_AddLogDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return AlertDialog(
      title: Text(s.shareThoughtTitle),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        decoration: InputDecoration(hintText: s.shareThoughtHint),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final content = _controller.text.trim();
            if (content.isNotEmpty) {
              widget.provider.addDailyLog(widget.challengeId, content);
            }
            Navigator.of(context).pop();
          },
          child: Text(s.save),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final int completedDays;
  final int targetDays;
  final int streak;
  final dynamic s;

  const _ProgressSection({
    required this.progress,
    required this.completedDays,
    required this.targetDays,
    required this.streak,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          CircularProgressWidget(
            progress: progress,
            size: 100,
            strokeWidth: 10,
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
                Text(
                  '$completedDays/$targetDays',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.progress, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(s.daysProgress(completedDays, targetDays),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    s.dayStreak(streak),
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLogsPlaceholder extends StatelessWidget {
  final VoidCallback onShareTap;
  final dynamic s;

  const _EmptyLogsPlaceholder({required this.onShareTap, required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onShareTap,
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: Text(s.shareThoughtButton),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        const SizedBox(height: 24),
        const Icon(Icons.book_outlined, size: 48, color: AppColors.textSecondary),
        const SizedBox(height: 8),
        Text(s.noLogsYet, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SubRoutinesSection extends StatelessWidget {
  final List<SubRoutine> subRoutines;
  final dynamic s;

  const _SubRoutinesSection({required this.subRoutines, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.subRoutines,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...subRoutines.map(
            (sub) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      sub.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (sub.time.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          sub.time,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleInfoSection extends StatelessWidget {
  final String reminderTime;
  final List<int> repeatDays;
  final dynamic s;

  const _ScheduleInfoSection({
    required this.reminderTime,
    required this.repeatDays,
    required this.s,
  });

  static const List<List<String>> _dayAbbr = [
    ['Mon', '월', '月', '一', '一', 'L', 'Mo', 'Seg', 'Пн'],
    ['Tue', '화', '火', '二', '二', 'M', 'Di', 'Ter', 'Вт'],
    ['Wed', '수', '水', '三', '三', 'X', 'Mi', 'Qua', 'Ср'],
    ['Thu', '목', '木', '四', '四', 'J', 'Do', 'Qui', 'Чт'],
    ['Fri', '금', '金', '五', '五', 'V', 'Fr', 'Sex', 'Пт'],
    ['Sat', '토', '土', '六', '六', 'S', 'Sa', 'Sáb', 'Сб'],
    ['Sun', '일', '日', '日', '日', 'D', 'So', 'Dom', 'Вс'],
  ];

  static const List<String> _langOrder = [
    'English', 'Korean', 'Japanese', 'ChineseSimplified', 'ChineseTraditional',
    'Spanish', 'German', 'Portuguese', 'Russian',
  ];

  String _dayLabel(int dayIndex, String language) {
    final langIdx = _langOrder.indexOf(language);
    final idx = langIdx < 0 ? 0 : langIdx;
    return _dayAbbr[dayIndex][idx];
  }

  @override
  Widget build(BuildContext context) {
    final language = context.read<SettingsProvider>().language;
    final rawDays = repeatDays.isEmpty ? List.generate(7, (i) => i) : repeatDays;
    // sort Sun-first: Sun(6)→0, Mon(0)→1, ..., Sat(5)→6
    final days = [...rawDays]..sort((a, b) => (a + 1) % 7 - (b + 1) % 7);
    final isEveryDay = repeatDays.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          if (repeatDays.isNotEmpty || isEveryDay) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.repetitionLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: days.map((d) {
                      return Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _dayLabel(d, language),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          if (reminderTime.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  s.reminderTimeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.notifications_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      reminderTime,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PauseSection extends StatelessWidget {
  final Challenge challenge;
  final dynamic s;
  final VoidCallback onUsePause;
  final VoidCallback onCancelPause;

  const _PauseSection({
    required this.challenge,
    required this.s,
    required this.onUsePause,
    required this.onCancelPause,
  });

  String _formatDate(DateTime d) => '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final pause = challenge.activePause;

    if (pause != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.pause_circle_outline, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.pauseActive,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    s.pauseActiveUntil(_formatDate(pause.end)),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onCancelPause,
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(s.pauseCancel, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onUsePause,
        icon: const Icon(Icons.pause_circle_outline, size: 18),
        label: Text(s.pauseTicketButton),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;
  final dynamic s;

  const _NotesSection({required this.notes, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                s.notesMotivation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(notes, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
        ],
      ),
    );
  }
}
