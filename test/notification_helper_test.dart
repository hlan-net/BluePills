import 'package:bluepills/notifications/notification_helper.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
