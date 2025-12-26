import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';

class TodayMedicationsWidget extends StatelessWidget {
  final List<Medication> medications;
  final List<MedicationLog> logs;
  final ValueChanged<Medication> onTakeMedication;
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
                  "Today's Medications",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: onTakeAll,
                  child: const Text('Take All'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if (medications.isEmpty)
              const Text('No medications scheduled for today.')
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
