/// Widget for displaying today's scheduled medications.
///
/// This library provides a card widget that shows all medications scheduled for today,
/// their status (taken/not taken), and actions to mark them as taken.
library;

import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/l10n/app_localizations.dart';

/// A widget that displays today's medications and their status.
///
/// Shows a list of medications scheduled for today with visual indicators
/// for completion status and provides buttons to mark medications as taken.
class TodayMedicationsWidget extends StatelessWidget {
  /// The list of medications scheduled for today.
  final List<Medication> medications;

  /// The list of medication logs to check if medications were taken.
  final List<MedicationLog> logs;

  /// Callback invoked when a single medication is marked as taken.
  final ValueChanged<Medication> onTakeMedication;

  /// Callback invoked when the "Take All" button is pressed.
  final VoidCallback onTakeAll;

  const TodayMedicationsWidget({
    super.key,
    required this.medications,
    required this.logs,
    required this.onTakeMedication,
    required this.onTakeAll,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.todaysMedications,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: onTakeAll,
                  child: Text(localizations.takeAll),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if (medications.isEmpty)
              Text(localizations.noMedicationsScheduledForToday)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
                  final isTaken = medication.isTakenToday(logs);
                  return ListTile(
                    leading: isTaken
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked),
                    title: Text(medication.name),
                    subtitle: Text(medication.dosage),
                    trailing: isTaken
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => onTakeMedication(medication),
                          ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
