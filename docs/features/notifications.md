# User Story: Medication Reminders (Notifications)

## Description
As a user, I want to receive notifications when it is time to take my medication so that I don't forget.

## Acceptance Criteria
1.  **Schedule Reminder**:
    *   When adding/editing a medication, user can set a reminder time.
    *   App schedules a local notification for that time.
2.  **Receive Notification**:
    *   Device displays a notification at the scheduled time.
    *   Notification title/body identifies the medication.
3.  **Platform Support**:
    *   Works on Android.
    *   Works on Linux (desktop notifications).

## Technical Notes
*   **Package**: `flutter_local_notifications`.
*   **Service**: `NotificationHelper`.
*   **Implementation Details**:
    *   `init()`: Sets up platform-specific settings (icons, channels).
    *   `scheduleNotification()`: Schedules the notification.
    *   *Current Limitation*: The implementation in `NotificationHelper` currently shows notifications immediately for testing/demo purposes. Future work is needed to properly schedule recurring notifications based on the medication's frequency pattern.
