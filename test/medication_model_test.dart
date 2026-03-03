import 'package:flutter_test/flutter_test.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/frequency_pattern.dart';

void main() {
  Medication _createMedication({
    int id = 1,
    Frequency frequency = Frequency.onceDaily,
    FrequencyPattern? frequencyPattern,
    int quantity = 30,
  }) {
    return Medication(
      id: id,
      name: 'Test Med',
      dosage: '100mg',
      quantity: quantity,
      frequency: frequency,
      frequencyPattern: frequencyPattern,
      reminderTime: DateTime.now(),
    );
  }

  List<MedicationLog> _createLogsForToday(int medId, int count) {
    final now = DateTime.now();
    return List.generate(
      count,
      (i) => MedicationLog(
        medicationId: medId,
        timestamp: now.subtract(Duration(minutes: i * 30)),
      ),
    );
  }

  group('requiredDosesPerDay', () {
    test('returns 1 for onceDaily', () {
      final med = _createMedication(frequency: Frequency.onceDaily);
      expect(med.requiredDosesPerDay, 1);
    });

    test('returns 2 for twiceDaily', () {
      final med = _createMedication(frequency: Frequency.twiceDaily);
      expect(med.requiredDosesPerDay, 2);
    });

    test('returns 3 for threeTimesDaily', () {
      final med = _createMedication(frequency: Frequency.threeTimesDaily);
      expect(med.requiredDosesPerDay, 3);
    });

    test('returns 0 for asNeeded', () {
      final med = _createMedication(frequency: Frequency.asNeeded);
      expect(med.requiredDosesPerDay, 0);
    });

    test('uses frequencyPattern timesPerDay when set', () {
      final med = _createMedication(
        frequencyPattern: FrequencyPattern.daily(timesPerDay: 4),
      );
      expect(med.requiredDosesPerDay, 4);
    });
  });

  group('isTakenToday', () {
    test('returns false when no logs', () {
      final med = _createMedication(frequency: Frequency.onceDaily);
      expect(med.isTakenToday([]), false);
    });

    test('returns true for onceDaily with 1 log today', () {
      final med = _createMedication(frequency: Frequency.onceDaily);
      final logs = _createLogsForToday(1, 1);
      expect(med.isTakenToday(logs), true);
    });

    test('returns false for twiceDaily with only 1 log today', () {
      final med = _createMedication(frequency: Frequency.twiceDaily);
      final logs = _createLogsForToday(1, 1);
      expect(med.isTakenToday(logs), false);
    });

    test('returns true for twiceDaily with 2 logs today', () {
      final med = _createMedication(frequency: Frequency.twiceDaily);
      final logs = _createLogsForToday(1, 2);
      expect(med.isTakenToday(logs), true);
    });

    test('returns false for asNeeded (always)', () {
      final med = _createMedication(frequency: Frequency.asNeeded);
      final logs = _createLogsForToday(1, 5);
      expect(med.isTakenToday(logs), false);
    });

    test('ignores logs from other medications', () {
      final med = _createMedication(id: 1, frequency: Frequency.onceDaily);
      final logs = _createLogsForToday(2, 3); // Different med ID
      expect(med.isTakenToday(logs), false);
    });
  });

  group('dosesTakenToday', () {
    test('returns 0 when no logs', () {
      final med = _createMedication();
      expect(med.dosesTakenToday([]), 0);
    });

    test('counts only logs for this medication', () {
      final med = _createMedication(id: 1);
      final logs = [
        ..._createLogsForToday(1, 2),
        ..._createLogsForToday(2, 3),
      ];
      expect(med.dosesTakenToday(logs), 2);
    });
  });

  group('dosesRemainingToday', () {
    test('returns full count when no logs', () {
      final med = _createMedication(frequency: Frequency.threeTimesDaily);
      expect(med.dosesRemainingToday([]), 3);
    });

    test('returns 0 when all doses taken', () {
      final med = _createMedication(frequency: Frequency.twiceDaily);
      final logs = _createLogsForToday(1, 2);
      expect(med.dosesRemainingToday(logs), 0);
    });

    test('returns remaining count', () {
      final med = _createMedication(frequency: Frequency.threeTimesDaily);
      final logs = _createLogsForToday(1, 1);
      expect(med.dosesRemainingToday(logs), 2);
    });

    test('returns 0 for asNeeded', () {
      final med = _createMedication(frequency: Frequency.asNeeded);
      expect(med.dosesRemainingToday([]), 0);
    });
  });

  group('getDaysOfSupply', () {
    test('returns quantity for onceDaily', () {
      final med = _createMedication(
        frequency: Frequency.onceDaily,
        quantity: 30,
      );
      expect(med.getDaysOfSupply(), 30);
    });

    test('returns quantity/2 for twiceDaily', () {
      final med = _createMedication(
        frequency: Frequency.twiceDaily,
        quantity: 30,
      );
      expect(med.getDaysOfSupply(), 15);
    });

    test('returns quantity/3 for threeTimesDaily', () {
      final med = _createMedication(
        frequency: Frequency.threeTimesDaily,
        quantity: 30,
      );
      expect(med.getDaysOfSupply(), 10);
    });

    test('returns 9999 for asNeeded', () {
      final med = _createMedication(
        frequency: Frequency.asNeeded,
        quantity: 30,
      );
      expect(med.getDaysOfSupply(), 9999);
    });

    test('uses frequencyPattern when set', () {
      final med = _createMedication(
        quantity: 20,
        frequencyPattern: FrequencyPattern.daily(timesPerDay: 2),
      );
      expect(med.getDaysOfSupply(), 10);
    });

    test('handles specificDays pattern', () {
      final med = _createMedication(
        quantity: 6,
        frequencyPattern: FrequencyPattern.specificDays(
          daysOfWeek: [1, 3, 5], // Mon, Wed, Fri
          timesPerDay: 1,
        ),
      );
      // 6 doses / 3 days per week = 2 weeks = 14 days
      expect(med.getDaysOfSupply(), 14);
    });

    test('handles everyNDays pattern', () {
      final med = _createMedication(
        quantity: 10,
        frequencyPattern: FrequencyPattern.everyNDays(
          days: 3,
          timesPerDay: 1,
        ),
      );
      // 10 doses * 3 days per dose = 30 days
      expect(med.getDaysOfSupply(), 30);
    });

    test('floors division for odd quantities', () {
      final med = _createMedication(
        frequency: Frequency.twiceDaily,
        quantity: 7,
      );
      expect(med.getDaysOfSupply(), 3); // 7/2 = 3.5 -> 3
    });
  });
}
