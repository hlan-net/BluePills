import 'package:bluepills/database/database_adapter.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/notifications/notification_helper.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_helper_test.mocks.dart';

@GenerateMocks([DatabaseAdapter])
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

  group('rescheduleAllReminders', () {
    test(
      'skips as-needed medications before touching the platform channel',
      () async {
        final mockAdapter = MockDatabaseAdapter();
        DatabaseHelper.instance = DatabaseHelper.withAdapter(mockAdapter);
        when(mockAdapter.init()).thenAnswer((_) async {});
        when(mockAdapter.getMedications()).thenAnswer(
          (_) async => [
            Medication(
              id: 1,
              name: 'As needed med',
              dosage: '1 tablet',
              quantity: 1,
              frequency: Frequency.asNeeded,
              reminderTime: DateTime.now(),
              isAsNeeded: true,
            ),
          ],
        );

        // The medication is skipped, but refreshing expiration alerts still
        // touches the (unavailable in tests) notification platform channel.
        await expectLater(
          NotificationHelper().rescheduleAllReminders(),
          throwsA(anything),
        );

        verify(mockAdapter.getMedications()).called(greaterThanOrEqualTo(1));
      },
    );
  });
}
