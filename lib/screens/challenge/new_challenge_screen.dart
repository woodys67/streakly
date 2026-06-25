import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/routine.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/add_subroutine_modal.dart';
import '../../widgets/subscription_bottom_sheet.dart';

class NewChallengeScreen extends StatefulWidget {
  const NewChallengeScreen({super.key});

  @override
  State<NewChallengeScreen> createState() => _NewChallengeScreenState();
}

class _NewChallengeScreenState extends State<NewChallengeScreen> {
  final _mainRoutineController = TextEditingController();
  final _notesController = TextEditingController();
  final _customDaysController = TextEditingController();

  int _targetDays = 21;
  bool _isCustom = false;
  final List<SubRoutine> _subRoutines = [];
  final List<bool> _selectedDays = List.filled(7, false);
  TimeOfDay? _reminderTime;

  static const List<String> _dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  // display order: Sun=index6, Mon=0, Tue=1, Wed=2, Thu=3, Fri=4, Sat=5
  static const List<int> _sunFirstOrder = [6, 0, 1, 2, 3, 4, 5];

  String get _formattedReminderTime {
    if (_reminderTime == null) return '';
    final hour = _reminderTime!.hourOfPeriod == 0 ? 12 : _reminderTime!.hourOfPeriod;
    final minute = _reminderTime!.minute.toString().padLeft(2, '0');
    final period = _reminderTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool get _subRoutinesHaveTime =>
      _subRoutines.any((sr) => sr.time.isNotEmpty && sr.alertEnabled);

  Future<void> _pickReminderTime() async {
    if (_subRoutinesHaveTime) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  void dispose() {
    _mainRoutineController.dispose();
    _notesController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  void _showAddSubroutineModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSubroutineModal(
        onSave: (subroutine) {
          setState(() {
            _subRoutines.add(subroutine);
            if (subroutine.time.isNotEmpty && subroutine.alertEnabled) {
              _reminderTime = null;
            }
          });
        },
      ),
    );
  }

  Future<void> _startChallenge() async {
    final s = context.read<SettingsProvider>().strings;

    final isPremium = context.read<SubscriptionProvider>().isPremium;
    final activeCount = context.read<ChallengeProvider>().activeChallenges.length;
    if (!isPremium && activeCount >= 3) {
      await SubscriptionBottomSheet.show(context);
      return;
    }

    final name = _mainRoutineController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.mainRoutineEmpty)),
      );
      return;
    }

    int days = _targetDays;
    if (_isCustom) {
      final custom = int.tryParse(_customDaysController.text.trim());
      if (custom == null || custom < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.invalidDays)),
        );
        return;
      }
      days = custom;
    }

    final repeatDays = <int>[];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) repeatDays.add(i);
    }

    if (!mounted) return;
    final hadSubRoutines = _subRoutines.isNotEmpty;
    // pop() 전에 provider 참조를 캡처 — pop 이후 context가 해제될 수 있으므로
    final cp = context.read<ChallengeProvider>();

    await cp.addChallenge(
      name: name,
      targetDays: days,
      subRoutines: _subRoutines,
      reminderTime: _subRoutinesHaveTime ? '' : _formattedReminderTime,
      repeatDays: repeatDays,
      notes: _notesController.text.trim(),
    );

    if (!mounted) return;
    Navigator.of(context).pop();

    // Navigator.pop() 이후 배지 체크: addChallenge() 내부에서 실행하면
    // showDialog()가 스택에 쌓인 뒤 pop()이 다이얼로그를 닫아버리는 문제 방지
    if (hadSubRoutines) {
      cp.awardSubRoutineCreatedBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.newChallenge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: s.mainRoutineLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _mainRoutineController,
              decoration: const InputDecoration(hintText: 'e.g., Morning Exercise'),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: s.subRoutineLabel),
            const SizedBox(height: 8),
            ..._subRoutines.map(
              (sr) => _SubRoutineTile(
                subroutine: sr,
                onDelete: () => setState(() => _subRoutines.remove(sr)),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _showAddSubroutineModal,
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.addSubRoutine),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: s.targetDaysLabel),
            const SizedBox(height: 12),
            _TargetDaysChips(
              selectedDays: _targetDays,
              isCustom: _isCustom,
              labels: [s.sevenDays, s.fourteenDays, s.twentyOneDays, s.custom],
              onSelect: (days, isCustom) {
                setState(() {
                  _targetDays = days;
                  _isCustom = isCustom;
                });
              },
            ),
            if (_isCustom) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customDaysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: s.enterDaysHint),
              ),
            ],
            const SizedBox(height: 24),
            _SectionLabel(label: s.reminderTimeLabel),
            const SizedBox(height: 8),
            Opacity(
              opacity: _subRoutinesHaveTime ? 0.4 : 1.0,
              child: GestureDetector(
                onTap: _subRoutinesHaveTime ? null : _pickReminderTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: _subRoutinesHaveTime ? AppColors.border : AppColors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _subRoutinesHaveTime ? Icons.notifications_off_outlined : Icons.access_time,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _subRoutinesHaveTime
                            ? s.reminderDisabledHint
                            : (_reminderTime != null ? _formattedReminderTime : '08:00 AM'),
                        style: TextStyle(
                          fontSize: _subRoutinesHaveTime ? 13 : 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: s.repetitionLabel),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final dayIdx = _sunFirstOrder[i];
                final selected = _selectedDays[dayIdx];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDays[dayIdx] = !_selectedDays[dayIdx]);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : AppColors.white,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dayLabels[i],
                        style: TextStyle(
                          color: selected
                              ? AppColors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: s.notesLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: s.notesHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startChallenge,
                child: Text(s.startChallenge),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SubRoutineTile extends StatelessWidget {
  final SubRoutine subroutine;
  final VoidCallback onDelete;

  const _SubRoutineTile({
    required this.subroutine,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_handle, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subroutine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subroutine.time.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        subroutine.alertEnabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        size: 12,
                        color: subroutine.alertEnabled
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subroutine.time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subroutine.alertEnabled
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _TargetDaysChips extends StatelessWidget {
  final int selectedDays;
  final bool isCustom;
  final List<String> labels;
  final void Function(int days, bool isCustom) onSelect;

  const _TargetDaysChips({
    required this.selectedDays,
    required this.isCustom,
    required this.labels,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(label: labels[0], isSelected: !isCustom && selectedDays == 7, onTap: () => onSelect(7, false)),
        const SizedBox(width: 8),
        _Chip(label: labels[1], isSelected: !isCustom && selectedDays == 14, onTap: () => onSelect(14, false)),
        const SizedBox(width: 8),
        _Chip(label: labels[2], isSelected: !isCustom && selectedDays == 21, onTap: () => onSelect(21, false)),
        const SizedBox(width: 8),
        _Chip(label: labels[3], isSelected: isCustom, onTap: () => onSelect(selectedDays, true)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
