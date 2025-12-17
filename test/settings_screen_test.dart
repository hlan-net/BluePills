import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/screens/settings_screen.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/export_service.dart';
import 'package:bluepills/services/import_service.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'settings_screen_test.mocks.dart';

@GenerateMocks([ConfigService, ExportService, ImportService, GoogleDriveService, BackupService])
void main() {
  late MockConfigService mockConfigService;
  late MockExportService mockExportService;
  late MockImportService mockImportService;
  late MockGoogleDriveService mockDriveService;
  late MockBackupService mockBackupService;

  setUp(() {
    mockConfigService = MockConfigService();
    mockExportService = MockExportService();
    mockImportService = MockImportService();
    mockDriveService = MockGoogleDriveService();
    mockBackupService = MockBackupService();

    when(
      mockConfigService.config,
    ).thenReturn(AppConfig(syncEnabled: false, syncMode: SyncMode.localOnly));

    when(mockDriveService.onCurrentUserChanged).thenAnswer((_) => Stream.value(null));
    when(mockDriveService.signInSilently()).thenAnswer((_) async => null);
  });

  testWidgets(
    'Settings screen shows import and export buttons and they can be tapped',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: SettingsScreen(
            configService: mockConfigService,
            exportService: mockExportService,
            importService: mockImportService,
            driveService: mockDriveService,
            backupService: mockBackupService,
          ),
        ),
      );

      // Verify that the import and export buttons are displayed.
      // Note: They might be off-screen, so we need to scroll to them.
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump();

      expect(find.text('Import Data'), findsOneWidget);
      expect(find.text('Export Data'), findsOneWidget);

      // Tap the export button.
      when(mockExportService.exportMedications()).thenAnswer((_) async {});
      await tester.tap(find.text('Export Data'));
      await tester.pump();

      // Verify that the export service is called.
      verify(mockExportService.exportMedications()).called(1);

      // Tap the import button.
      when(mockImportService.importMedications()).thenAnswer((_) async {});
      await tester.tap(find.text('Import Data'));
      await tester.pump();

      // Verify that the import service is called.
      verify(mockImportService.importMedications()).called(1);
    },
  );
}
