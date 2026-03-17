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
    final todaysMedications = _prepareMedications();
    final allTaken = _allScheduledMedicationsTaken(todaysMedications);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, localizations, allTaken),
            const SizedBox(height: 16),
            if (todaysMedications.isEmpty)
              _buildEmptyState(localizations)
            else
              _buildMedicationList(localizations, todaysMedications),
          ],
        ),
      ),
    );
  }

  List<Medication> _prepareMedications() {
    final todaysMedications = medications
        .where((m) => m.shouldTakeToday() || m.isAsNeeded)
        .toList();

    todaysMedications.sort((a, b) {
      if (a.isAsNeeded && !b.isAsNeeded) return 1;
      if (!a.isAsNeeded && b.isAsNeeded) return -1;
      return a.name.compareTo(b.name);
    });
    return todaysMedications;
  }

  bool _allScheduledMedicationsTaken(List<Medication> todaysMedications) {
    return todaysMedications
        .where((m) => !m.isAsNeeded)
        .every((m) => m.isTakenToday(logs));
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool allTaken,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localizations.todaysMedications,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (!allTaken)
          TextButton(onPressed: onTakeAll, child: Text(localizations.takeAll)),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text(localizations.noMedicationsScheduledForToday)),
    );
  }

  Widget _buildMedicationList(
    AppLocalizations localizations,
    List<Medication> todaysMedications,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todaysMedications.length,
      itemBuilder: (context, index) {
        final medication = todaysMedications[index];
        final isTaken = medication.isTakenToday(logs);
        final dosesRemaining = medication.dosesRemainingToday(logs);

        return _MedicationTile(
          medication: medication,
          isTaken: isTaken,
          dosesRemaining: dosesRemaining,
          localizations: localizations,
          onTakeMedication: onTakeMedication,
        );
      },
    );
  }
}

class _MedicationTile extends StatelessWidget {
  final Medication medication;
  final bool isTaken;
  final int dosesRemaining;
  final AppLocalizations localizations;
  final Function(Medication) onTakeMedication;

  const _MedicationTile({
    required this.medication,
    required this.isTaken,
    required this.dosesRemaining,
    required this.localizations,
    required this.onTakeMedication,
  });

  @override
  Widget build(BuildContext context) {
    final status = _tileVisuals();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: status.backgroundColor,
        child: Icon(status.icon, color: status.iconColor),
      ),
      title: Text(
        medication.name,
        style: TextStyle(
          fontWeight: isTaken ? FontWeight.normal : FontWeight.bold,
          decoration: isTaken ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(_subtitleText()),
      trailing: isTaken
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => onTakeMedication(medication),
            ),
    );
  }

  String _subtitleText() {
    if (medication.isAsNeeded) {
      return localizations.asNeeded;
    }
    final dosesTaken = medication.requiredDosesPerDay - dosesRemaining;
    return localizations.takenOf(dosesTaken, medication.requiredDosesPerDay);
  }

  _MedicationTileVisuals _tileVisuals() {
    if (medication.isAsNeeded) {
      return _MedicationTileVisuals(
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        icon: Icons.medical_information,
        iconColor: Colors.blue,
      );
    }

    const iconColor = Colors.white;
    if (isTaken) {
      return _MedicationTileVisuals(
        backgroundColor: Colors.green,
        icon: Icons.check,
        iconColor: iconColor,
      );
    }

    return _MedicationTileVisuals(
      backgroundColor: Colors.orange,
      icon: Icons.medication,
      iconColor: iconColor,
    );
  }
}

class _MedicationTileVisuals {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const _MedicationTileVisuals({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
}
