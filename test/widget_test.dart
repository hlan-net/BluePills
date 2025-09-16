// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bluepills/main.dart';

void main() {
  testWidgets('Medication list screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('My Medications'), findsOneWidget);
    
    // Verify that no medications message is shown initially
    expect(find.text('No medications added yet.'), findsOneWidget);

    // Verify the add button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
