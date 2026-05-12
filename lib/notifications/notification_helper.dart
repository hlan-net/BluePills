/// Helper service for managing local notifications.
///
/// This library provides functionality for scheduling and displaying
/// medication reminder notifications using flutter_local_notifications.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/frequency_pattern.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  static const String actionTake = 'action_take';

  /// Action identifier for snoozing a reminder.
  static const String actionSnooze = 'action_snooze';

  /// Base ID offset for expiration notifications to avoid collision.
  static const int expirationIdOffset = 1000000;

  /// Base ID offset for snoozed reminder notifications.
  static const int snoozeIdOffset = 2000000;

  /// Base ID offset for grouped expiration notifications.
  static const int groupedExpirationIdOffset = 3000000;

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

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload == null) {
      return;
    }

    final medicationId = int.tryParse(details.payload!);
    if (medicationId == null) {
      return;
    }

    if (details.actionId == actionTake) {
      _handleTakeAction(medicationId);
      return;
    }

    if (details.actionId == actionSnooze) {
      _handleSnoozeAction(medicationId);
    }
  }

  Future<void> _handleTakeAction(int medicationId) async {
    final db = DatabaseHelper();
    final med = await db.getMedication(medicationId);
    if (med == null || med.quantity <= 0) {
      return;
    }

    final updatedMed = med.copyWith(quantity: med.quantity - 1);
    await db.updateMedication(updatedMed);
    await db.insertMedicationLog(
      MedicationLog(medicationId: med.id!, timestamp: DateTime.now()),
    );
    await _scheduleNextOccurrenceIfNeeded(updatedMed);
    debugPrint('Logged dose for ${med.name} from notification action');
  }

  Future<void> _handleSnoozeAction(int medicationId) async {
    final db = DatabaseHelper();
    final med = await db.getMedication(medicationId);
    if (med == null) {
      return;
    }

    final snoozeTime = DateTime.now().add(const Duration(minutes: 15));
    await scheduleNotification(
      id: snoozeIdOffset + med.id!,
      title: 'Snoozed: ${med.name}',
      body: 'Time to take your ${med.dosage}!',
      scheduledTime: snoozeTime,
      repeat: false,
    );
    debugPrint('Snoozed ${med.name} for 15 minutes');
  }

  Future<void> _scheduleNextOccurrenceIfNeeded(Medication med) async {
    if (med.isAsNeeded) {
      return;
    }

    final pattern = med.frequencyPattern;
    if (pattern == null || pattern.type != FrequencyType.everyNDays) {
      return;
    }

    final next = _nextReminderDateTime(
      med,
      from: DateTime.now().add(const Duration(minutes: 1)),
    );
    if (next == null) {
      return;
    }

    await scheduleMedicationReminder(
      med.copyWith(reminderTime: next),
      repeat: false,
    );
  }

  /// Schedules a medication reminder using medication data.
  Future<void> scheduleMedicationReminder(
    Medication medication, {
    DateTime? from,
    bool repeat = true,
  }) async {
    if (medication.id == null || medication.isAsNeeded) {
      return;
    }

    final nextTime = _nextReminderDateTime(medication, from: from);
    if (nextTime == null) {
      return;
    }

    final pattern = medication.frequencyPattern;
    final supportsPlatformRepeat =
        pattern == null ||
        pattern.type == FrequencyType.daily ||
        pattern.type == FrequencyType.specificDays;

    await scheduleNotification(
      id: medication.id!,
      title: medication.name,
      body: 'Time to take your ${medication.dosage}!',
      scheduledTime: nextTime,
      frequencyPattern: pattern,
      repeat: repeat && supportsPlatformRepeat,
    );
  }

  DateTime? _nextReminderDateTime(Medication med, {DateTime? from}) {
    if (med.isAsNeeded) {
      return null;
    }

    final now = from ?? DateTime.now();
    final reminder = med.reminderTime;
    final pattern = med.frequencyPattern;

    DateTime dateWithReminder(DateTime date) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        reminder.hour,
        reminder.minute,
      );
    }

    bool isScheduledOnDate(DateTime date) {
      if (pattern != null) {
        return pattern.shouldTakeOnDate(date, med.createdAt);
      }

      switch (med.frequency) {
        case Frequency.onceDaily:
        case Frequency.twiceDaily:
        case Frequency.threeTimesDaily:
          return true;
        case Frequency.asNeeded:
          return false;
      }
    }

    for (var offset = 0; offset <= 366; offset++) {
      final candidateDate = now.add(Duration(days: offset));
      if (!isScheduledOnDate(candidateDate)) {
        continue;
      }

      final candidate = dateWithReminder(candidateDate);
      if (candidate.isAfter(now)) {
        return candidate;
      }
    }

    return null;
  }

  /// Schedules a notification to be displayed.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    FrequencyPattern? frequencyPattern,
    bool repeat = true,
  }) async {
    DateTimeComponents? matchDateTimeComponents;
    if (!repeat) {
      matchDateTimeComponents = null;
    } else if (frequencyPattern != null) {
      switch (frequencyPattern.type) {
        case FrequencyType.daily:
          matchDateTimeComponents = DateTimeComponents.time;
          break;
        case FrequencyType.specificDays:
          matchDateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
          break;
        case FrequencyType.everyNDays:
        case FrequencyType.asNeeded:
          matchDateTimeComponents = null;
          break;
      }
    } else {
      matchDateTimeComponents = DateTimeComponents.time;
    }

    DateTime effectiveScheduledTime = scheduledTime;
    if (repeat && matchDateTimeComponents != null) {
      final reminderTime = DateTime(
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
      if (!reminderTime.isAfter(DateTime.now())) {
        effectiveScheduledTime = reminderTime.add(const Duration(days: 1));
      }
    }

    var tzScheduledTime = tz.TZDateTime.from(effectiveScheduledTime, tz.local);
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
              actionTake,
              'Take',
              showsUserInterface: false,
            ),
            AndroidNotificationAction(
              actionSnooze,
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
    if (med.expirationDate == null || med.id == null) {
      return;
    }

    await _cancelAllLegacyExpirationNotifications();
    await refreshGroupedExpirationNotifications();
  }

  /// Rebuilds grouped expiration notifications for all medications.
  Future<void> refreshGroupedExpirationNotifications() async {
    await _cancelGroupedExpirationNotifications();

    final medications = await DatabaseHelper().getMedications();
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final grouped = <_GroupedExpirationKey, List<Medication>>{};

    for (final med in medications) {
      if (med.id == null || med.expirationDate == null) {
        continue;
      }

      final expirationDate = DateTime(
        med.expirationDate!.year,
        med.expirationDate!.month,
        med.expirationDate!.day,
      );

      for (final daysBefore in const [30, 7, 0]) {
        final alertDate = expirationDate.subtract(Duration(days: daysBefore));
        if (alertDate.isBefore(startOfToday)) {
          continue;
        }

        final key = _GroupedExpirationKey(
          alertDate: alertDate,
          daysBefore: daysBefore,
        );
        grouped.putIfAbsent(key, () => []).add(med);
      }
    }

    for (final entry in grouped.entries) {
      await _scheduleGroupedExpirationAlert(entry.key, entry.value);
    }
  }

  Future<void> _scheduleGroupedExpirationAlert(
    _GroupedExpirationKey key,
    List<Medication> medications,
  ) async {
    if (medications.isEmpty) {
      return;
    }

    final sortedNames = medications.map((m) => m.name).toList()..sort();
    final title = key.daysBefore == 0
        ? (sortedNames.length > 1
              ? 'Medications Expire Today'
              : 'Medication Expires Today')
        : (sortedNames.length > 1
              ? 'Medications Expiring Soon'
              : 'Medication Expiring Soon');

    final body = _buildGroupedExpirationBody(
      daysBefore: key.daysBefore,
      medicationNames: sortedNames,
    );

    final dayCode = key.alertDate.difference(DateTime(2020, 1, 1)).inDays;
    final notificationId =
        groupedExpirationIdOffset + (key.daysBefore * 100000) + dayCode;

    await _scheduleExpirationAlert(
      id: notificationId,
      title: title,
      body: body,
      scheduledTime: key.alertDate,
      useIdOffset: false,
    );
  }

  String _buildGroupedExpirationBody({
    required int daysBefore,
    required List<String> medicationNames,
  }) {
    final count = medicationNames.length;
    final preview = medicationNames.take(3).join(', ');
    final hasMore = count > 3;
    final suffix = hasMore ? ' +${count - 3} more' : '';

    if (daysBefore == 0) {
      if (count == 1) {
        return '${medicationNames.first} expires today!';
      }
      return '$count medications expire today: $preview$suffix';
    }

    if (count == 1) {
      return '${medicationNames.first} will expire in $daysBefore days.';
    }
    return '$count medications will expire in $daysBefore days: $preview$suffix';
  }

  Future<void> _cancelAllLegacyExpirationNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    for (final notification in pending) {
      final id = notification.id;
      if (id >= expirationIdOffset && id < groupedExpirationIdOffset) {
        await _notificationsPlugin.cancel(id: id);
      }
    }
  }

  Future<void> _cancelGroupedExpirationNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    for (final notification in pending) {
      final id = notification.id;
      if (id >= groupedExpirationIdOffset &&
          id < groupedExpirationIdOffset + 10000000) {
        await _notificationsPlugin.cancel(id: id);
      }
    }
  }

  Future<void> _scheduleExpirationAlert({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool useIdOffset = true,
  }) async {
    final finalId = useIdOffset ? expirationIdOffset + id : id;

    final alertTime = DateTime(
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      9,
    );

    var tzAlertTime = tz.TZDateTime.from(alertTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (tzAlertTime.isBefore(now)) {
      return;
    }

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
    await refreshGroupedExpirationNotifications();
  }
}

class _GroupedExpirationKey {
  final DateTime alertDate;
  final int daysBefore;

  const _GroupedExpirationKey({
    required this.alertDate,
    required this.daysBefore,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _GroupedExpirationKey &&
        other.daysBefore == daysBefore &&
        other.alertDate.year == alertDate.year &&
        other.alertDate.month == alertDate.month &&
        other.alertDate.day == alertDate.day;
  }

  @override
  int get hashCode {
    return Object.hash(
      alertDate.year,
      alertDate.month,
      alertDate.day,
      daysBefore,
    );
  }
}
