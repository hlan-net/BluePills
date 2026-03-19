import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/widgets/today_medications_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithLocalization(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  Medication buildMedication({
    required int id,
    required String name,
    bool isAsNeeded = false,
  }) {
    return Medication(
      id: id,
      name: name,
      dosage: '10mg',
      quantity: 10,
      frequency: isAsNeeded ? Frequency.asNeeded : Frequency.onceDaily,
      reminderTime: DateTime.now(),
      isAsNeeded: isAsNeeded,
    );
  }

  testWidgets('shows pending scheduled medications and take all action', (
    tester,
  ) async {
    final scheduled = buildMedication(id: 1, name: 'Morning Dose');
    final asNeeded = buildMedication(
      id: 2,
      name: 'Pain Relief',
      isAsNeeded: true,
    );

    Medication? tappedMedication;
    var takeAllPressed = false;

    await tester.pumpWidget(
      wrapWithLocalization(
        TodayMedicationsWidget(
          medications: [scheduled, asNeeded],
          logs: const [],
          onTakeMedication: (medication) => tappedMedication = medication,
          onTakeAll: () => takeAllPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Today's Medications"), findsOneWidget);
    expect(find.text('Take All'), findsOneWidget);
    expect(find.text('Pain Relief'), findsOneWidget);
    expect(find.text('As needed'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check).first);
    await tester.pumpAndSettle();

    expect(tappedMedication, equals(scheduled));

    await tester.tap(find.text('Take All'));
    await tester.pump();

    expect(takeAllPressed, isTrue);
  });

  testWidgets('hides take all when all scheduled doses are logged', (
    tester,
  ) async {
    final scheduled = buildMedication(id: 1, name: 'Evening Dose');
    final log = MedicationLog(medicationId: 1, timestamp: DateTime.now());

    await tester.pumpWidget(
      wrapWithLocalization(
        TodayMedicationsWidget(
          medications: [scheduled],
          logs: [log],
          onTakeMedication: (_) {},
          onTakeAll: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Take All'), findsNothing);
    expect(find.text('Taken 1 of 1'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
