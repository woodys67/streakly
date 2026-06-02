import 'routine.dart';
import 'daily_log.dart';

class Challenge {
  final String id;
  final String name;
  final int targetDays;
  final DateTime startDate;
  final List<int> completedDays;
  final List<SubRoutine> subRoutines;
  final List<DailyLog> logs;
  final String reminderTime;
  final List<int> repeatDays;
  final String notes;
  final bool isCompleted;
  // day → completed sub-routine IDs
  final Map<int, List<String>> completedSubRoutines;

  Challenge({
    required this.id,
    required this.name,
    required this.targetDays,
    required this.startDate,
    this.completedDays = const [],
    this.subRoutines = const [],
    this.logs = const [],
    this.reminderTime = '',
    this.repeatDays = const [],
    this.notes = '',
    this.isCompleted = false,
    this.completedSubRoutines = const {},
  });

  int get currentDay {
    final now = DateTime.now();
    final diff = now.difference(startDate).inDays + 1;
    return diff.clamp(1, targetDays);
  }

  int get streak {
    if (completedDays.isEmpty) return 0;
    final today = currentDay;
    int count = 0;
    for (int d = today; d >= 1; d--) {
      if (completedDays.contains(d)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  double get successRate {
    if (targetDays == 0) return 0;
    return completedDays.length / targetDays;
  }

  bool get isTodayCompleted {
    return completedDays.contains(currentDay);
  }

  bool isSubRoutineCompletedToday(String subRoutineId) {
    return completedSubRoutines[currentDay]?.contains(subRoutineId) ?? false;
  }

  Challenge copyWith({
    String? id,
    String? name,
    int? targetDays,
    DateTime? startDate,
    List<int>? completedDays,
    List<SubRoutine>? subRoutines,
    List<DailyLog>? logs,
    String? reminderTime,
    List<int>? repeatDays,
    String? notes,
    bool? isCompleted,
    Map<int, List<String>>? completedSubRoutines,
  }) {
    return Challenge(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDays: targetDays ?? this.targetDays,
      startDate: startDate ?? this.startDate,
      completedDays: completedDays ?? this.completedDays,
      subRoutines: subRoutines ?? this.subRoutines,
      logs: logs ?? this.logs,
      reminderTime: reminderTime ?? this.reminderTime,
      repeatDays: repeatDays ?? this.repeatDays,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedSubRoutines: completedSubRoutines ?? this.completedSubRoutines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetDays': targetDays,
      'startDate': startDate.toIso8601String(),
      'completedDays': completedDays,
      'subRoutines': subRoutines.map((s) => s.toJson()).toList(),
      'logs': logs.map((l) => l.toJson()).toList(),
      'reminderTime': reminderTime,
      'repeatDays': repeatDays,
      'notes': notes,
      'isCompleted': isCompleted,
      'completedSubRoutines': completedSubRoutines.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['completedSubRoutines'] as Map<String, dynamic>? ?? {};
    final parsedSubs = rawSubs.map(
      (k, v) => MapEntry(int.parse(k), List<String>.from(v as List)),
    );
    return Challenge(
      id: json['id'] as String,
      name: json['name'] as String,
      targetDays: json['targetDays'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      completedDays: List<int>.from(json['completedDays'] as List),
      subRoutines: (json['subRoutines'] as List)
          .map((s) => SubRoutine.fromJson(s as Map<String, dynamic>))
          .toList(),
      logs: (json['logs'] as List)
          .map((l) => DailyLog.fromJson(l as Map<String, dynamic>))
          .toList(),
      reminderTime: json['reminderTime'] as String? ?? '',
      repeatDays: List<int>.from(json['repeatDays'] as List? ?? []),
      notes: json['notes'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedSubRoutines: parsedSubs,
    );
  }

  /// Supabase 쿼리 결과(sub_routines, sub_routine_completions, daily_logs 조인)로부터 생성
  factory Challenge.fromSupabase(Map<String, dynamic> row) {
    final subRoutineRows =
        (row['sub_routines'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final completionRows =
        (row['sub_routine_completions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final logRows =
        (row['daily_logs'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    final subRoutines = subRoutineRows
        .map((r) => SubRoutine.fromSupabase(r))
        .toList();

    final completedSubRoutines = <int, List<String>>{};
    for (final comp in completionRows) {
      final day = comp['day_number'] as int;
      final subId = comp['sub_routine_id'] as String;
      completedSubRoutines.putIfAbsent(day, () => []).add(subId);
    }

    final completedDays = (row['completed_days'] as List<dynamic>? ?? [])
        .map((d) => d as int)
        .toList();

    return Challenge(
      id: row['id'] as String,
      name: row['name'] as String,
      targetDays: row['target_days'] as int,
      startDate: DateTime.parse(row['start_date'] as String),
      completedDays: completedDays,
      subRoutines: subRoutines,
      logs: logRows.map((r) => DailyLog.fromSupabase(r)).toList(),
      reminderTime: row['reminder_time'] as String? ?? '',
      repeatDays: (row['repeat_days'] as List<dynamic>? ?? [])
          .map((d) => d as int)
          .toList(),
      notes: row['notes'] as String? ?? '',
      isCompleted: row['is_completed'] as bool? ?? false,
      completedSubRoutines: completedSubRoutines,
    );
  }

  Map<String, dynamic> toSupabaseInsert(String userId) {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'target_days': targetDays,
      'start_date': startDate.toIso8601String().split('T').first,
      'completed_days': completedDays,
      'reminder_time': reminderTime,
      'repeat_days': repeatDays,
      'notes': notes,
      'is_completed': isCompleted,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Challenge && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
