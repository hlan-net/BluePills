/// Medication form screen for adding or editing medications.
///
/// This library provides the UI for creating new medications or editing
/// existing ones, including name, dosage, frequency, and reminder time.
library;

import 'package:flutter/material.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/frequency_pattern.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/widgets/frequency_selector.dart';

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
  late TextEditingController _quantityController;
  late Frequency _selectedFrequency;
  late DateTime _selectedReminderTime;
  FrequencyPattern? _selectedFrequencyPattern;
  bool _useAdvancedFrequency = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.medication?.name ?? '',
    );
    _dosageController = TextEditingController(
      text: widget.medication?.dosage ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.medication?.quantity.toString() ?? '0',
    );
    _selectedFrequency = widget.medication?.frequency ?? Frequency.onceDaily;
    _selectedReminderTime = widget.medication?.reminderTime ?? DateTime.now();
    _selectedFrequencyPattern = widget.medication?.frequencyPattern;
    _useAdvancedFrequency = widget.medication?.frequencyPattern != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
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

  void _saveMedication({bool addAnother = false}) async {
    if (_formKey.currentState!.validate()) {
      // Validate frequency pattern if using advanced mode
      if (_useAdvancedFrequency) {
        if (_selectedFrequencyPattern == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a frequency pattern'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        if (_selectedFrequencyPattern!.type == FrequencyType.specificDays &&
            _selectedFrequencyPattern!.daysOfWeek.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one day'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      try {
        final newMedication = Medication(
          id: widget.medication?.id,
          name: _nameController.text,
          dosage: _dosageController.text,
          quantity: int.tryParse(_quantityController.text) ?? 0,
          frequency: _selectedFrequency,
          frequencyPattern: _useAdvancedFrequency
              ? _selectedFrequencyPattern
              : null,
          reminderTime: _selectedReminderTime,
        );

        if (widget.medication == null) {
          final newId = await DatabaseHelper().insertMedication(newMedication);
          newMedication.id = newId;
        } else {
          await DatabaseHelper().updateMedication(newMedication);
        }

        // Try to schedule notification, but don't fail if it doesn't work
        try {
          await NotificationHelper().scheduleNotification(
            newMedication.id!,
            'Medication Reminder',
            'Time to take your ${newMedication.name}!',
            newMedication.reminderTime,
          );
        } catch (e) {
          debugPrint('Failed to schedule notification: $e');
        }

        if (mounted) {
          if (addAnother) {
            // Clear the form for next entry
            _nameController.clear();
            _dosageController.clear();
            _frequencyController.clear();
            _selectedReminderTime = DateTime.now();
            setState(() {});

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Medication saved! Add another.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Go back to list
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        debugPrint('Error saving medication: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save medication: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
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
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Frequency mode toggle
              SwitchListTile(
                title: const Text('Use Advanced Frequency'),
                subtitle: Text(
                  _useAdvancedFrequency
                      ? 'Select specific days and patterns'
                      : 'Use simple text frequency',
                ),
                value: _useAdvancedFrequency,
                onChanged: (value) {
                  setState(() {
                    _useAdvancedFrequency = value;
                  });
                },
              ),
              const SizedBox(height: 8),

              // Frequency input - either simple text or advanced selector
              if (!_useAdvancedFrequency)
                DropdownButtonFormField<Frequency>(
                  value: _selectedFrequency,
                  items: Frequency.values.map((Frequency frequency) {
                    return DropdownMenuItem<Frequency>(
                      value: frequency,
                      child: Text(frequency.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Frequency? newValue) {
                    setState(() {
                      _selectedFrequency = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: localizations?.frequency ?? 'Frequency',
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequency Pattern',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (_selectedFrequencyPattern != null)
                          Text(
                            _selectedFrequencyPattern!.toReadableString(),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        const SizedBox(height: 16),
                        FrequencySelector(
                          initialPattern: _selectedFrequencyPattern,
                          onPatternChanged: (pattern) {
                            setState(() {
                              _selectedFrequencyPattern = pattern;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ListTile(
                title: Text(
                  '${localizations?.reminderTime ?? 'Reminder Time'}: ${TimeOfDay.fromDateTime(_selectedReminderTime).format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _saveMedication(addAnother: false),
                      icon: const Icon(Icons.check),
                      label: Text(localizations?.saveMedication ?? 'Save'),
                    ),
                  ),
                  if (widget.medication == null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _saveMedication(addAnother: true),
                        icon: const Icon(Icons.add),
                        label: const Text('Save & Add More'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
