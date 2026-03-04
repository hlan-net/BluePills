/// Helper service for managing local notifications.
///
/// This library provides functionality for scheduling and displaying
/// medication reminder notifications using flutter_local_notifications.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:bluepills/models/frequency_pattern.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/database/database_helper.dart';

/// Singleton service for managing local notifications.
class NotificationHelper {
  static NotificationHelper _instance = NotificationHelper._internal();

  /// Returns the singleton instance of the NotificationHelper.
  factory NotificationHelper() => _instance;

  /// Sets the singleton instance of the NotificationHelper (used for testing).
  @visibleForTesting
  static set instance(NotificationHelper helper) => _instance = helper;

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Action identifier for marking medication as taken.
  static const String actionTake = 'TAKE_ACTION';

  /// Action identifier for snoozing a reminder.
  static const String actionSnooze = 'SNOOZE_ACTION';

  /// Base ID offset for expiration notifications to avoid collision with reminders.
  static const int expirationIdOffset = 1000000;

  /// Initializes the notification system with platform-specific settings.
  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open');
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          linux: initializationSettingsLinux,
        );
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request notification permissions for Android 13+ (API level 33+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Request exact alarm permissions for Android 12+ (API level 31+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload == null) return;

    final int medicationId = int.tryParse(details.payload!) ?? -1;
    if (medicationId == -1) return;

    if (details.actionId == actionTake) {
      _handleTakeAction(medicationId);
    } else if (details.actionId == actionSnooze) {
      _handleSnoozeAction(medicationId);
    }
  }

  Future<void> _handleTakeAction(int medicationId) async {
    final db = DatabaseHelper();
    final med = await db.getMedication(medicationId);
    if (med != null && med.quantity > 0) {
      final updatedMed = med.copyWith(quantity: med.quantity - 1);
      await db.updateMedication(updatedMed);
      await db.insertMedicationLog(
        MedicationLog(medicationId: med.id!, timestamp: DateTime.now()),
      );
      debugPrint('Logged dose for ${med.name} from notification action');
    }
  }

  Future<void> _handleSnoozeAction(int medicationId) async {
    final db = DatabaseHelper();
    final med = await db.getMedication(medicationId);
    if (med != null) {
      // Snooze for 15 minutes
      final snoozeTime = DateTime.now().add(const Duration(minutes: 15));
      await scheduleNotification(
        id: med.id!,
        title: 'Snoozed: ${med.name}',
        body: 'Time to take your ${med.dosage}!',
        scheduledTime: snoozeTime,
      );
      debugPrint('Snoozed ${med.name} for 15 minutes');
    }
  }

  /// Schedules a notification to be displayed.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    FrequencyPattern? frequencyPattern,
  }) async {
    DateTimeComponents? matchDateTimeComponents;
    if (frequencyPattern != null) {
      switch (frequencyPattern.type) {
        case FrequencyType.daily:
          matchDateTimeComponents = DateTimeComponents.time;
          break;
        case FrequencyType.specificDays:
          matchDateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
          break;
        default:
          break;
      }
    }

    // Ensure the scheduled time is in the future
    var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (tzScheduledTime.isBefore(now) && matchDateTimeComponents == null) {
      tzScheduledTime = tzScheduledTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_reminders',
          'Medication Reminders',
          channelDescription: 'Reminders to take your medication',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'action_take',
              'Take',
              showsUserInterface: false,
            ),
            AndroidNotificationAction(
              'action_snooze',
              'Snooze (15m)',
              showsUserInterface: false,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: id.toString(),
    );
  }

  /// Schedules expiration notifications for a medication.
  Future<void> scheduleExpirationNotifications(Medication med) async {
    if (med.expirationDate == null || med.id == null) return;

    final expDate = med.expirationDate!;
    final now = DateTime.now();

    // 30 days before
    final thirtyDaysBefore = expDate.subtract(const Duration(days: 30));
    if (thirtyDaysBefore.isAfter(now)) {
      await _scheduleExpirationAlert(
        id: med.id! * 10 + 1,
        title: 'Medication Expiring Soon',
        body: '${med.name} will expire in 30 days.',
        scheduledTime: thirtyDaysBefore,
      );
    }

    // 7 days before
    final sevenDaysBefore = expDate.subtract(const Duration(days: 7));
    if (sevenDaysBefore.isAfter(now)) {
      await _scheduleExpirationAlert(
        id: med.id! * 10 + 2,
        title: 'Medication Expiring Soon',
        body: '${med.name} will expire in 7 days.',
        scheduledTime: sevenDaysBefore,
      );
    }

    // Day of expiration
    if (expDate.isAfter(now)) {
      await _scheduleExpirationAlert(
        id: med.id! * 10 + 3,
        title: 'Medication Expired',
        body: '${med.name} expires today!',
        scheduledTime: expDate,
      );
    }
  }

  Future<void> _scheduleExpirationAlert({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Offset ID to avoid reminder collisions
    final finalId = expirationIdOffset + id;

    // Set to 9 AM on the alert day
    final alertTime = DateTime(
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      9,
      0,
    );

    var tzAlertTime = tz.TZDateTime.from(alertTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (tzAlertTime.isBefore(now)) return;

    await _notificationsPlugin.zonedSchedule(
      id: finalId,
      title: title,
      body: body,
      scheduledDate: tzAlertTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_expiration',
          'Expiration Alerts',
          channelDescription: 'Alerts when your medication is about to expire',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Cancels a scheduled notification.
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancels expiration notifications for a medication.
  Future<void> cancelExpirationNotifications(int medicationId) async {
    await _notificationsPlugin.cancel(
      id: expirationIdOffset + medicationId * 10 + 1,
    );
    await _notificationsPlugin.cancel(
      id: expirationIdOffset + medicationId * 10 + 2,
    );
    await _notificationsPlugin.cancel(
      id: expirationIdOffset + medicationId * 10 + 3,
    );
  }
}
