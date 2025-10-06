/// Helper service for managing local notifications.
///
/// This library provides functionality for scheduling and displaying
/// medication reminder notifications using flutter_local_notifications.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Singleton service for managing medication reminder notifications.
///
/// This service handles initialization of the notification system and
/// scheduling of medication reminders. It uses the flutter_local_notifications
/// plugin to display platform-specific notifications.
///
/// Example usage:
/// ```dart
/// final notificationHelper = NotificationHelper();
/// await notificationHelper.init();
/// await notificationHelper.scheduleNotification(
///   1,
///   'Medication Reminder',
///   'Time to take your medication!',
///   DateTime.now().add(Duration(hours: 1)),
/// );
/// ```
class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  
  /// Returns the singleton instance of the NotificationHelper.
  factory NotificationHelper() => _instance;
  
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification system with platform-specific settings.
  ///
  /// This method must be called before scheduling any notifications.
  /// Sets up notification icons and action names for Android and Linux.
  Future<void> init() async {
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
    DateTime scheduledTime,
  ) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_reminders',
          'Medication Reminders',
          channelDescription: 'Reminders to take your medication',
        ),
      ),
    );
  }
}
