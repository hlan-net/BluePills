/// Medication form screen for adding or editing medications.
///
/// This library provides the UI for creating new medications or editing
/// existing ones, including name, dosage, frequency, and reminder time.
library;

import 'package:flutter/material.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/l10n/app_localizations.dart';

import 'package:bluepills/notifications/notification_helper.dart';

/// A stateful widget that displays the medication form.
///
/// Can be used in two modes:
/// - Add mode: Creates a new medication (when [medication] is null)
/// - Edit mode: Updates an existing medication (when [medication] is provided)
class MedicationFormScreen extends StatefulWidget {
  /// The medication to edit, or null to create a new medication.
  final Medication? medication;

  const MedicationFormScreen({super.key, this.medication});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

/// State class for the medication form screen.
///
/// Manages form validation, user input, and saving medication data
/// to the database. Also schedules notifications for medication reminders.
class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _frequencyController;
  late DateTime _selectedReminderTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.medication?.name ?? '',
    );
    _dosageController = TextEditingController(
      text: widget.medication?.dosage ?? '',
    );
    _frequencyController = TextEditingController(
      text: widget.medication?.frequency ?? '',
    );
    _selectedReminderTime = widget.medication?.reminderTime ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedReminderTime),
    );
    if (picked != null) {
      setState(() {
        _selectedReminderTime = DateTime(
          _selectedReminderTime.year,
          _selectedReminderTime.month,
          _selectedReminderTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final newMedication = Medication(
        id: widget.medication?.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
        reminderTime: _selectedReminderTime,
      );

      if (widget.medication == null) {
        final newId = await DatabaseHelper().insertMedication(newMedication);
        newMedication.id = newId;
      } else {
        await DatabaseHelper().updateMedication(newMedication);
      }

      await NotificationHelper().scheduleNotification(
        newMedication.id!,
        'Medication Reminder',
        'Time to take your ${newMedication.name}!',
        newMedication.reminderTime,
      );

      if (mounted) {
        Navigator.pop(context, true); // Pass true to indicate a change
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.medication == null
              ? (localizations?.addMedication ?? 'Add Medication')
              : (localizations?.editMedication ?? 'Edit Medication'),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: localizations?.medicationName ?? 'Medication Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.pleaseEnterMedicationName ??
                        'Please enter a medication name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: localizations?.dosage ?? 'Dosage',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.pleaseEnterDosage ??
                        'Please enter the dosage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _frequencyController,
                decoration: InputDecoration(
                  labelText: localizations?.frequency ?? 'Frequency',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.pleaseEnterFrequency ??
                        'Please enter the frequency';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  '${localizations?.reminderTime ?? 'Reminder Time'}: ${TimeOfDay.fromDateTime(_selectedReminderTime).format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedication,
                child: Text(localizations?.saveMedication ?? 'Save Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
