import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/main.dart';
import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/notifications/notification_helper.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

void main() {
  late MockDatabaseAdapter mockDatabaseAdapter;
  late MockConfigService mockConfigService;
  late MockSyncService mockSyncService;
  late MockNotificationHelper mockNotificationHelper;

  setUp(() {
    mockDatabaseAdapter = MockDatabaseAdapter();
    mockConfigService = MockConfigService();
    mockSyncService = MockSyncService();
    mockNotificationHelper = MockNotificationHelper();

    DatabaseHelper.instance = DatabaseHelper.withAdapter(mockDatabaseAdapter);
    ConfigService.instance = mockConfigService;
    SyncService.instance = mockSyncService;
    NotificationHelper.instance = mockNotificationHelper;

    when(mockDatabaseAdapter.init()).thenAnswer((_) async {});
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => []);
    when(
      mockDatabaseAdapter.getMedicationLogsForToday(),
    ).thenAnswer((_) async => []);
    when(
      mockDatabaseAdapter.getMedicationLogs(any),
    ).thenAnswer((_) async => []);
    when(mockConfigService.config).thenReturn(const AppConfig());
    when(mockConfigService.isSyncEnabled).thenReturn(false);
    when(mockNotificationHelper.init()).thenAnswer((_) async {});
  });

  tearDown(() async {
    // Flush the periodic locale-refresh timer created by MyApp so it
    // doesn't leak into the next test.
    await Future<void>.delayed(Duration.zero);
  });

  testWidgets(
    'Prompts to open settings when reminders are on but permission is denied',
    (WidgetTester tester) async {
      when(mockNotificationHelper.checkPermissionStatus()).thenAnswer(
        (_) async => const NotificationPermissionStatus(
          notificationsGranted: false,
          exactAlarmsGranted: true,
        ),
      );
      when(
        mockNotificationHelper.openNotificationSettings(),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Notifications are off'), findsOneWidget);

      await tester.tap(find.text('Open Settings'));
      await tester.pump();

      verify(mockNotificationHelper.openNotificationSettings()).called(1);
    },
  );

  testWidgets('Does not prompt when the notification permission is granted', (
    WidgetTester tester,
  ) async {
    when(mockNotificationHelper.checkPermissionStatus()).thenAnswer(
      (_) async => const NotificationPermissionStatus(
        notificationsGranted: true,
        exactAlarmsGranted: true,
      ),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('Notifications are off'), findsNothing);
  });

  testWidgets('Does not prompt when reminders are disabled in settings', (
    WidgetTester tester,
  ) async {
    when(
      mockConfigService.config,
    ).thenReturn(const AppConfig(notificationsEnabled: false));
    when(mockNotificationHelper.checkPermissionStatus()).thenAnswer(
      (_) async => const NotificationPermissionStatus(
        notificationsGranted: false,
        exactAlarmsGranted: true,
      ),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('Notifications are off'), findsNothing);
    verifyNever(mockNotificationHelper.checkPermissionStatus());
  });
}
