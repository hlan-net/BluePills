import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bluepills/database/database_adapter.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/screens/medication_form_screen.dart';
import 'package:bluepills/screens/medication_list_screen.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([DatabaseAdapter, ConfigService, SyncService])
void main() {
  late MockDatabaseAdapter mockDatabaseAdapter;
  late MockConfigService mockConfigService;
  late MockSyncService mockSyncService;

  setUp(() {
    mockDatabaseAdapter = MockDatabaseAdapter();
    mockConfigService = MockConfigService();
    mockSyncService = MockSyncService();

    DatabaseHelper.instance = DatabaseHelper.withAdapter(mockDatabaseAdapter);
    ConfigService.instance = mockConfigService;
    SyncService.instance = mockSyncService;

    when(mockDatabaseAdapter.init()).thenAnswer((_) async {});
    when(mockConfigService.config).thenReturn(const AppConfig());
    when(mockConfigService.isSyncEnabled).thenReturn(false);
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  testWidgets('Medication list screen loads with no medications', (
    WidgetTester tester,
  ) async {
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pump();
    await tester.pump();

    expect(find.text('My Medications'), findsOneWidget);
    expect(find.text('No medications added yet.'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Medication list screen shows medication with low stock and expiration', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final med = Medication(
      id: 1,
      name: 'Test Medication',
      dosage: '10mg',
      quantity: 2, // Low stock (< 3)
      frequency: Frequency.onceDaily,
      reminderTime: now,
      expirationDate: now.add(const Duration(days: 5)), // Expiring soon (< 7)
    );

    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => [med]);
    when(mockDatabaseAdapter.getMedicationLogsForToday()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pump();
    await tester.pump();

    // Found in both "Today's Medications" and "All Medications"
    expect(find.text('Test Medication'), findsAtLeastNWidgets(1));
    
    // Check for warning icons
    expect(find.byIcon(Icons.error), findsAtLeastNWidgets(1)); // Critically low stock
    expect(find.byIcon(Icons.event), findsAtLeastNWidgets(1)); // Expiration icon
  });

  testWidgets('Expiring soon filter works', (WidgetTester tester) async {
    final now = DateTime.now();
    final med1 = Medication(
      id: 1,
      name: 'Expiring Soon',
      dosage: '10mg',
      quantity: 10,
      frequency: Frequency.onceDaily,
      reminderTime: now,
      expirationDate: now.add(const Duration(days: 5)),
    );
    final med2 = Medication(
      id: 2,
      name: 'Not Expiring',
      dosage: '10mg',
      quantity: 10,
      frequency: Frequency.asNeeded,
      reminderTime: now,
      expirationDate: now.add(const Duration(days: 100)),
    );

    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => [med1, med2]);
    when(mockDatabaseAdapter.getMedicationLogsForToday()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Expiring Soon'), findsAtLeastNWidgets(1));
    expect(find.text('Not Expiring'), findsOneWidget);

    // Tap "Expiring Soon" filter button
    await tester.tap(find.byIcon(Icons.event_available));
    await tester.pumpAndSettle();

    expect(find.text('Expiring Soon'), findsAtLeastNWidgets(1));
    expect(find.text('Not Expiring'), findsNothing);
  });

  testWidgets('Low stock filter works', (WidgetTester tester) async {
    final now = DateTime.now();
    final med1 = Medication(
      id: 1,
      name: 'Low Stock',
      dosage: '10mg',
      quantity: 1,
      frequency: Frequency.onceDaily,
      reminderTime: now,
    );
    final med2 = Medication(
      id: 2,
      name: 'Full Stock',
      dosage: '10mg',
      quantity: 100,
      frequency: Frequency.asNeeded,
      reminderTime: now,
    );

    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => [med1, med2]);
    when(mockDatabaseAdapter.getMedicationLogsForToday()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Low Stock'), findsAtLeastNWidgets(1));
    expect(find.text('Full Stock'), findsOneWidget);

    // Tap "Low Stock" filter button
    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Low Stock'), findsAtLeastNWidgets(1));
    expect(find.text('Full Stock'), findsNothing);
  });

  testWidgets('Speed dial expands and shows options', (WidgetTester tester) async {
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pumpAndSettle();

    // Tap main FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify labels are shown
    expect(find.text('New Medication'), findsOneWidget);
    expect(find.text('Log Dose'), findsOneWidget);
    expect(find.text('Set Reminder'), findsOneWidget);
  });

  testWidgets('Medication form saves correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const MedicationFormScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'New Med');
    await tester.enterText(find.byType(TextFormField).at(1), '50mg');
    await tester.enterText(find.byType(TextFormField).at(2), '30');

    when(mockDatabaseAdapter.insertMedication(any)).thenAnswer((_) async => 1);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    verify(mockDatabaseAdapter.insertMedication(any)).called(1);
  });

  testWidgets('Delete medication shows confirmation dialog', (WidgetTester tester) async {
    final now = DateTime.now();
    final med = Medication(
      id: 1,
      name: 'To Delete',
      dosage: '10mg',
      quantity: 10,
      frequency: Frequency.onceDaily,
      reminderTime: now,
    );

    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => [med]);
    when(mockDatabaseAdapter.getMedicationLogsForToday()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pumpAndSettle();

    // Find and tap delete button
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.text('Are you sure you want to delete this medication?'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget); // The button

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify dialog is closed and medication still there
    expect(find.text('To Delete'), findsAtLeastNWidgets(1));
    verifyNever(mockDatabaseAdapter.deleteMedication(any));
  });

  testWidgets('Sync button is shown and can be tapped when enabled', (WidgetTester tester) async {
    when(mockConfigService.isSyncEnabled).thenReturn(true);
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(const MedicationListScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sync), findsOneWidget);

    when(mockSyncService.performFullSync()).thenAnswer((_) async => true);
    when(mockSyncService.syncStatus).thenReturn(SyncStatus.success);

    await tester.tap(find.byIcon(Icons.sync));
    await tester.pumpAndSettle();

    verify(mockSyncService.performFullSync()).called(1);
    expect(find.text('Sync completed successfully'), findsOneWidget);
  });
}
