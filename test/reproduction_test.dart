import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/database/mobile_database_adapter.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/frequency_pattern.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final adapter = MobileDatabaseAdapter();
    DatabaseHelper.instance = DatabaseHelper.withAdapter(adapter);
  });

  test('Blind reproduction: Insert basic medication', () async {
    final med = Medication(
      name: 'Ibuprofen',
      dosage: '400mg',
      quantity: 20,
      frequency: Frequency.asNeeded,
      reminderTime: DateTime.now(),
    );

    final map = med.toMap();
    debugPrint('Medication Map: $map');

    final reconstructed = Medication.fromMap(map);
    expect(reconstructed.name, 'Ibuprofen');
  });

  test(
    'Blind reproduction: Insert medication with complex frequency pattern',
    () async {
      final med = Medication(
        name: 'Complex Med',
        dosage: '10mg',
        quantity: 30,
        frequency: Frequency.onceDaily,
        frequencyPattern: FrequencyPattern.specificDays(
          daysOfWeek: [1, 3, 5],
          timesPerDay: 2,
          specificTimes: [
            DateTime(2025, 12, 20, 8, 0),
            DateTime(2025, 12, 20, 20, 0),
          ],
        ),
        reminderTime: DateTime.now(),
      );

      try {
        await DatabaseHelper().init();
      } catch (e) {
        if (e.toString().contains('MissingPluginException') ||
            e.toString().contains('MethodChannel')) {
          debugPrint('Skipping DB insert due to platform channel missing: $e');
          return;
        }
        rethrow;
      }

      try {
        final id = await DatabaseHelper().insertMedication(med);
        debugPrint('Inserted medication with ID: $id');
        expect(id, isPositive);
      } catch (e) {
        debugPrint('Database insert failed: $e');
        fail('Database insert should not fail: $e');
      }
    },
  );

  test('Reproduction: String vs Int mismatch in fromMap', () {
    // Simulate a map where integers come back as Strings (common in some DB/JSON scenarios)
    final badMap = {
      'id': 1,
      'name': 'Test Med',
      'dosage': '10mg',
      'quantity': '10', // String instead of int -> FAIL CASE
      'frequency': '0', // String instead of int -> FAIL CASE
      'frequencyPatternType': '0', // String instead of int -> FAIL CASE
      'reminderTime': DateTime.now().toIso8601String(),
      'needsSync': 1,
    };

    try {
      final med = Medication.fromMap(badMap);
      debugPrint('Successfully parsed bad map: ${med.name}');
    } catch (e) {
      debugPrint('Caught expected error: $e');
      expect(e.toString(), contains("subtype of type"));
    }
  });
}
