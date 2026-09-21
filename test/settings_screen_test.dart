import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/notifications/notification_helper.dart';
import 'package:bluepills/screens/settings_screen.dart';
import 'package:bluepills/services/backup_service.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/export_service.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/import_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_screen_test.mocks.dart';

@GenerateMocks([
  ConfigService,
  SyncService,
  BackupService,
  GoogleDriveService,
  ExportService,
  ImportService,
  NotificationHelper,
])
void main() {
  late MockConfigService mockConfigService;
  late MockSyncService mockSyncService;
  late MockGoogleDriveService mockGoogleDriveService;
  late MockExportService mockExportService;
  late MockImportService mockImportService;
  late MockNotificationHelper mockNotificationHelper;

  setUp(() {
    mockConfigService = MockConfigService();
    mockSyncService = MockSyncService();
    mockGoogleDriveService = MockGoogleDriveService();
    mockExportService = MockExportService();
    mockImportService = MockImportService();
    mockNotificationHelper = MockNotificationHelper();

    // Use dependency injection through static instances
    ConfigService.instance = mockConfigService;
    SyncService.instance = mockSyncService;
    GoogleDriveService.instance = mockGoogleDriveService;
    ExportService.instance = mockExportService;
    ImportService.instance = mockImportService;
    NotificationHelper.instance = mockNotificationHelper;

    when(mockConfigService.config).thenReturn(const AppConfig());
    when(
      mockGoogleDriveService.isAuthenticated(),
    ).thenAnswer((_) async => false);
    when(mockGoogleDriveService.getUserEmail()).thenAnswer((_) async => null);
    when(mockNotificationHelper.checkPermissionStatus()).thenAnswer(
      (_) async => const NotificationPermissionStatus(
        notificationsGranted: true,
        exactAlarmsGranted: true,
      ),
    );
    when(
      mockNotificationHelper.requestNotificationPermission(),
    ).thenAnswer((_) async => true);
    when(
      mockNotificationHelper.requestExactAlarmPermission(),
    ).thenAnswer((_) async => true);
    when(
      mockNotificationHelper.rescheduleAllReminders(),
    ).thenAnswer((_) async {});
    when(
      mockNotificationHelper.cancelAllNotifications(),
    ).thenAnswer((_) async {});
    when(
      mockNotificationHelper.openNotificationSettings(),
    ).thenAnswer((_) async {});
    when(
      mockConfigService.updateNotificationsEnabled(any),
    ).thenAnswer((_) async {});
  });

  Widget createSettingsScreen() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    );
  }

  testWidgets('Settings screen displays correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('BlueSky Synchronization'), findsOneWidget);
    expect(find.text('Google Drive Backup'), findsOneWidget);
  });

  testWidgets('Language selection works', (WidgetTester tester) async {
    // Set a larger surface size to ensure everything is visible
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createSettingsScreen());
    await tester.pumpAndSettle();

    // Find the language dropdown
    final dropdown = find.byWidgetPredicate(
      (widget) => widget is DropdownButtonFormField,
    );
    await tester.ensureVisible(dropdown);
    expect(dropdown, findsOneWidget);

    // Tap the dropdown to open it
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    // Select Finnish
    await tester.tap(find.text('Finnish').last);
    await tester.pumpAndSettle();

    // Verify that the config service is called
    verify(mockConfigService.updateLanguage('fi')).called(1);
  });

  testWidgets('Google Drive connect works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    final connectButton = find.text('Connect to Google Drive');
    await tester.ensureVisible(connectButton);
    await tester.tap(connectButton);
    await tester.pump();

    verify(mockGoogleDriveService.authenticate()).called(1);
  });

  testWidgets('Export data works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    final exportButton = find.text('Export Data');
    await tester.ensureVisible(exportButton);
    await tester.tap(exportButton);
    await tester.pump();

    verify(mockExportService.exportMedications()).called(1);
  });

  testWidgets('Import data works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    final importButton = find.text('Import Data');
    await tester.ensureVisible(importButton);
    await tester.tap(importButton);
    await tester.pump();

    verify(mockImportService.importMedications()).called(1);
  });

  testWidgets('Disabling reminders cancels all notifications', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    final toggle = find.byType(SwitchListTile);
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    verify(mockConfigService.updateNotificationsEnabled(false)).called(1);
    verify(mockNotificationHelper.cancelAllNotifications()).called(1);
    verifyNever(mockNotificationHelper.rescheduleAllReminders());
  });

  testWidgets('Enabling reminders requests permissions and reschedules', (
    WidgetTester tester,
  ) async {
    when(
      mockConfigService.config,
    ).thenReturn(const AppConfig(notificationsEnabled: false));

    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    final toggle = find.byType(SwitchListTile);
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    verify(mockConfigService.updateNotificationsEnabled(true)).called(1);
    verify(mockNotificationHelper.requestNotificationPermission()).called(1);
    verify(mockNotificationHelper.requestExactAlarmPermission()).called(1);
    verify(mockNotificationHelper.rescheduleAllReminders()).called(1);
    verifyNever(mockNotificationHelper.cancelAllNotifications());
  });

  testWidgets(
    'Missing notification permission shows an enable action that opens settings',
    (WidgetTester tester) async {
      when(mockNotificationHelper.checkPermissionStatus()).thenAnswer(
        (_) async => const NotificationPermissionStatus(
          notificationsGranted: false,
          exactAlarmsGranted: true,
        ),
      );
      when(
        mockNotificationHelper.requestNotificationPermission(),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(createSettingsScreen());
      await tester.pump();
      await tester.pump();

      final enableButton = find.widgetWithText(TextButton, 'Enable');
      await tester.ensureVisible(enableButton);
      await tester.tap(enableButton);
      await tester.pump();

      verify(mockNotificationHelper.requestNotificationPermission()).called(1);
      verify(mockNotificationHelper.openNotificationSettings()).called(1);
    },
  );
}
