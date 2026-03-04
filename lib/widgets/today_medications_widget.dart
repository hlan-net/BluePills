/// Widget for displaying today's scheduled medications.
///
/// This library provides a card widget that shows all medications scheduled for today,
/// their status (taken/not taken), and actions to mark them as taken.
library;

import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/l10n/app_localizations.dart';

/// A card widget that displays a list of today's medications.
///
/// This widget takes a list of medications and their corresponding logs for today,
/// and provides a callback for marking a medication as taken.
class TodayMedicationsWidget extends StatelessWidget {
  /// The list of all medications.
  final List<Medication> medications;

  /// The list of medication logs for today.
  final List<MedicationLog> logs;

  /// Callback function when a medication is marked as taken.
  final Function(Medication) onTakeMedication;

  /// Callback function when all medications are marked as taken.
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

    // Filter for scheduled today or as-needed
    final todaysMedications =
        medications.where((m) => m.shouldTakeToday() || m.isAsNeeded).toList();

    // Sort: Scheduled first, then as-needed
    todaysMedications.sort((a, b) {
      if (a.isAsNeeded && !b.isAsNeeded) return 1;
      if (!a.isAsNeeded && b.isAsNeeded) return -1;
      return a.name.compareTo(b.name);
    });

    final allTaken = todaysMedications
        .where((m) => !m.isAsNeeded)
        .every((m) => m.isTakenToday(logs));

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.todaysMedications,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!allTaken)
                  TextButton(
                    onPressed: onTakeAll,
                    child: Text(localizations.takeAll),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (todaysMedications.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(localizations.noMedicationsScheduledForToday),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todaysMedications.length,
                itemBuilder: (context, index) {
                  final medication = todaysMedications[index];
                  final isTaken = medication.isTakenToday(logs);
                  final dosesRemaining = medication.dosesRemainingToday(logs);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          medication.isAsNeeded
                              ? Colors.blue.withValues(alpha: 0.1)
                              : (isTaken ? Colors.green : Colors.orange),
                      child: Icon(
                        medication.isAsNeeded
                            ? Icons.medical_information
                            : (isTaken ? Icons.check : Icons.medication),
                        color:
                            medication.isAsNeeded
                                ? Colors.blue
                                : Colors.white,
                      ),
                    ),
                    title: Text(
                      medication.name,
                      style: TextStyle(
                        fontWeight:
                            isTaken ? FontWeight.normal : FontWeight.bold,
                        decoration:
                            isTaken ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      medication.isAsNeeded
                          ? localizations.asNeeded
                          : localizations.takenOf(
                            medication.requiredDosesPerDay - dosesRemaining,
                            medication.requiredDosesPerDay,
                          ),
                    ),
                    trailing:
                        isTaken
                            ? const Icon(Icons.check_circle, color: Colors.green)
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
