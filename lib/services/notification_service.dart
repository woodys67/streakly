import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/challenge.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  static Future<void> scheduleChallenge(Challenge c) async {
    if (c.reminderTime.isEmpty) return;
    final tod = _parseTime(c.reminderTime);
    if (tod == null) return;

    final days = c.repeatDays.isEmpty
        ? List.generate(7, (i) => i)
        : c.repeatDays;

    for (final day in days) {
      // challenge repeatDays: 0=Mon..6=Sun → Dart weekday: 1=Mon..7=Sun
      final weekday = day + 1;
      await _plugin.zonedSchedule(
        _notifId(c.id, day),
        c.name,
        '',
        _nextWeekday(weekday, tod),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'streakly_reminders',
            'Challenge Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static Future<void> cancelChallenge(String challengeId) async {
    for (int day = 0; day < 7; day++) {
      await _plugin.cancel(_notifId(challengeId, day));
    }
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();

  static Future<void> rescheduleAll(List<Challenge> challenges) async {
    await cancelAll();
    for (final c in challenges) {
      await scheduleChallenge(c);
    }
  }

  static int _notifId(String challengeId, int day) =>
      (challengeId.hashCode.abs() % 100000) * 7 + day;

  static TimeOfDay? _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      if (parts.length > 1) {
        final isPM = parts[1].toUpperCase() == 'PM';
        if (isPM && hour != 12) hour += 12;
        if (!isPM && hour == 12) hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  static tz.TZDateTime _nextWeekday(int weekday, TimeOfDay tod) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, tod.hour, tod.minute,
    );
    while (scheduled.weekday != weekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
