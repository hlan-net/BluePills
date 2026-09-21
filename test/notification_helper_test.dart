import 'package:bluepills/notifications/notification_helper.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationHelper permission helpers', () {
    test('checkPermissionStatus reports granted when the platform channel '
        'is unavailable', () async {
      final status = await NotificationHelper().checkPermissionStatus();

      expect(status.notificationsGranted, isTrue);
      expect(status.exactAlarmsGranted, isTrue);
    });

    test('requestNotificationPermission does not throw when the platform '
        'channel is unavailable', () async {
      await expectLater(
        NotificationHelper().requestNotificationPermission(),
        completes,
      );
    });

    test('requestExactAlarmPermission does not throw when the platform '
        'channel is unavailable', () async {
      await expectLater(
        NotificationHelper().requestExactAlarmPermission(),
        completes,
      );
    });

    test('openNotificationSettings does not throw when the platform channel '
        'is unavailable', () async {
      await expectLater(
        NotificationHelper().openNotificationSettings(),
        completes,
      );
    });
  });

  group('requestPermissionsIfEnabled', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await ConfigService().init();
    });

    test('requests permissions when reminders are enabled', () async {
      await ConfigService().updateNotificationsEnabled(true);

      await expectLater(
        NotificationHelper().requestPermissionsIfEnabled(),
        completes,
      );
    });

    test('does nothing when reminders are disabled', () async {
      await ConfigService().updateNotificationsEnabled(false);

      await expectLater(
        NotificationHelper().requestPermissionsIfEnabled(),
        completes,
      );
    });
  });
}
