// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bluepills/database/database_adapter.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/main.dart';
import 'package:bluepills/models/medication.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([DatabaseAdapter])
void main() {
  late MockDatabaseAdapter mockDatabaseAdapter;

  setUp(() {
    mockDatabaseAdapter = MockDatabaseAdapter();
    DatabaseHelper.instance = DatabaseHelper.withAdapter(mockDatabaseAdapter);
    when(mockDatabaseAdapter.init()).thenAnswer((_) async {});
  });

  testWidgets('Medication list screen loads with no medications', (WidgetTester tester) async {
    // Stub the getMedications method to return an empty list.
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // The first frame is a loading state.
    await tester.pump();

    // Now the real UI is built.
    await tester.pump();

    // Verify that the app title is displayed.
    expect(find.text('My Medications'), findsOneWidget);

    // Verify that no medications message is shown initially.
    expect(find.text('No medications added yet.'), findsOneWidget);

    // Verify the add button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Medication list screen loads with medications', (WidgetTester tester) async {
    // Stub the getMedications method to return a list with one medication.
    when(mockDatabaseAdapter.getMedications()).thenAnswer((_) async => [
      Medication(
        id: 1,
        name: 'Test Medication',
        dosage: '10mg',
        frequency: 'Daily',
        reminderTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // The first frame is a loading state.
    await tester.pump();

    // Now the real UI is built.
    await tester.pump();

    // Verify that the medication is displayed.
    expect(find.text('Test Medication'), findsOneWidget);
  });
}