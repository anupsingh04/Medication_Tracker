import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import '../model/medication.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Android Init
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Init
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Generate a unique int ID from medId string + index
  int _generateId(String medId, int index) {
    // Combine hash of medId with index to create distinct IDs for each time slot
    // Use bitwise AND to ensure positive integer (required by some platforms)
    return (medId.hashCode ^ index) & 0x7FFFFFFF;
  }

  Duration _parseOffset(String? notifStr) {
    if (notifStr == null) return const Duration(minutes: 5);
    if (notifStr.contains('5 minutes')) return const Duration(minutes: 5);
    if (notifStr.contains('10 minutes')) return const Duration(minutes: 10);
    if (notifStr.contains('15 minutes')) return const Duration(minutes: 15);
    if (notifStr.contains('20 minutes')) return const Duration(minutes: 20);
    if (notifStr.contains('30 minutes')) return const Duration(minutes: 30);
    if (notifStr.contains('45 minutes')) return const Duration(minutes: 45);
    if (notifStr.contains('1 hour')) return const Duration(hours: 1);
    return const Duration(minutes: 5); // Default
  }

  Future<void> scheduleMedicationReminders(Medication med) async {
    // Cancel existing first to avoid duplicates or stale times
    await cancelMedicationReminders(med);

    Duration offset = _parseOffset(med.medicineIntakeNotif);

    for (int i = 0; i < med.intakeTimes.length; i++) {
      String timeStr = med.intakeTimes[i];
      try {
        List<String> parts = timeStr.split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        final now = tz.TZDateTime.now(tz.local);

        // Target time for notification (Intake time - offset)
        var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute)
            .subtract(offset);

        // Ensure we schedule in the future
        if (scheduledDate.isBefore(now)) {
           scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        int id = _generateId(med.id, i);

        await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            'Medication Reminder',
            'Time to take ${med.medName} (${med.dosage} ${med.dosageUnit})',
            scheduledDate,
            const NotificationDetails(
                android: AndroidNotificationDetails(
                    'medication_channel', 'Medication Reminders',
                    channelDescription: 'Reminders to take your medication',
                    importance: Importance.max,
                    priority: Priority.high,
                    showWhen: true)),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time); // Repeat daily

      } catch (e) {
        print("Error scheduling notification for ${med.medName} at $timeStr: $e");
      }
    }
  }

  Future<void> cancelMedicationReminders(Medication med) async {
     // Cancel a range of potential indices (0-19) to cover changes in schedule length
     for (int i = 0; i < 20; i++) {
        int id = _generateId(med.id, i);
        await flutterLocalNotificationsPlugin.cancel(id);
     }
  }
}
