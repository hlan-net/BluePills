import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/screens/settings_screen.dart';
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
  GoogleDriveService,
  ExportService,
  ImportService,
])
void main() {
  late MockConfigService mockConfigService;
  late MockSyncService mockSyncService;
  late MockGoogleDriveService mockGoogleDriveService;
  late MockExportService mockExportService;
  late MockImportService mockImportService;

  setUp(() {
    mockConfigService = MockConfigService();
    mockSyncService = MockSyncService();
    mockGoogleDriveService = MockGoogleDriveService();
    mockExportService = MockExportService();
    mockImportService = MockImportService();

    // Use dependency injection through static instances
    ConfigService.instance = mockConfigService;
    SyncService.instance = mockSyncService;

    when(mockConfigService.config).thenReturn(const AppConfig());
    when(mockGoogleDriveService.isAuthenticated()).thenAnswer((_) async => false);
    when(mockGoogleDriveService.getUserEmail()).thenAnswer((_) async => null);
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

  testWidgets('Settings screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('BlueSky Synchronization'), findsOneWidget);
    expect(find.text('Google Drive Backup'), findsOneWidget);
  });

  testWidgets('Language selection works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    // Find the language dropdown
    final dropdown = find.byType(DropdownButtonFormField<String>);
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

    await tester.tap(find.text('Connect to Google Drive'));
    await tester.pump();

    verify(mockGoogleDriveService.authenticate()).called(1);
  });

  testWidgets('Export data works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    await tester.tap(find.text('Export Data'));
    await tester.pump();

    verify(mockExportService.exportMedications()).called(1);
  });

  testWidgets('Import data works', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    await tester.pump();

    await tester.tap(find.text('Import Data'));
    await tester.pump();

    verify(mockImportService.importMedications()).called(1);
  });
}
