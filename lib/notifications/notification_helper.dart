/// Helper service for managing local notifications.
///
/// This library provides functionality for scheduling and displaying
/// medication reminder notifications using flutter_local_notifications.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show
        FlutterLocalNotificationsPlugin,
        NotificationDetails,
        AndroidInitializationSettings,
        LinuxInitializationSettings,
        InitializationSettings,
        DateTimeComponents,
        AndroidNotificationDetails,
        AndroidNotificationChannel,
        AndroidScheduleMode,
        Importance,
        Priority,
        UILocalNotificationDateInterpretation,
        AndroidFlutterLocalNotificationsPlugin;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:bluepills/models/frequency_pattern.dart'; // Import FrequencyPattern

/// Singleton service for managing local notifications.
///
/// This library provides functionality for scheduling and displaying
/// medication reminder notifications using flutter_local_notifications.
class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();

  /// Returns the singleton instance of the NotificationHelper.
  factory NotificationHelper() => _instance;

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification system with platform-specific settings.
  ///
  /// This method must be called before any other operations.
  /// Sets up notification icons and action names for Android and Linux.
  /// Also requests notification permissions on Android 13+.
  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open');
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          linux: initializationSettingsLinux,
        );
    await _notificationsPlugin.initialize(initializationSettings);
    
    // Request notification permissions for Android 13+ (API level 33+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    // Request exact alarm permissions for Android 12+ (API level 31+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// Schedules a notification to be displayed.
  ///
  /// Note: Currently displays the notification immediately rather than
  /// scheduling it for the future. This is a known limitation.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for this notification
  /// - [title]: The notification title
  /// - [body]: The notification message body
  /// - [scheduledTime]: The intended time for the notification (currently unused)
  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime, {
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

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_reminders',
          'Medication Reminders',
          channelDescription: 'Reminders to take your medication',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchDateTimeComponents,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
