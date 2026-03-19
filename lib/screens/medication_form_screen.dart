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
/// Manages the form validation, user input, and saving medication data
/// to the database. Also schedules notifications for medication reminders.
class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _quantityController;
  late TextEditingController _storageLocationController;
  late Frequency _selectedFrequency;
  late DateTime _selectedReminderTime;
  DateTime? _selectedExpirationDate;
  FrequencyPattern? _selectedFrequencyPattern;
  bool _useAdvancedFrequency = false;
  bool _isAsNeeded = false;
  bool _wasSaved = false;

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
    _storageLocationController = TextEditingController(
      text: widget.medication?.storageLocation ?? '',
    );
    _selectedFrequency = widget.medication?.frequency ?? Frequency.onceDaily;
    _selectedReminderTime = widget.medication?.reminderTime ?? DateTime.now();
    _selectedExpirationDate = widget.medication?.expirationDate;
    _selectedFrequencyPattern = widget.medication?.frequencyPattern;
    _useAdvancedFrequency = widget.medication?.frequencyPattern != null;
    _isAsNeeded = widget.medication?.isAsNeeded ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _storageLocationController.dispose();
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

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 365));
    final DateTime lastDate = now.add(const Duration(days: 3650)); // 10 years

    DateTime initialDate = _selectedExpirationDate ?? now;
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        _selectedExpirationDate = picked;
      });
    }
  }

  void _saveMedication({bool addAnother = false}) async {
    if (_formKey.currentState!.validate()) {
      final localizations = AppLocalizations.of(context)!;
      // Validate frequency pattern if using advanced mode
      if (_useAdvancedFrequency && !_isAsNeeded) {
        if (_selectedFrequencyPattern == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.pleaseSelectAFrequencyPattern),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        if (_selectedFrequencyPattern!.type == FrequencyType.specificDays &&
            _selectedFrequencyPattern!.daysOfWeek.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.pleaseSelectAtLeastOneDay),
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
          frequencyPattern: (_useAdvancedFrequency && !_isAsNeeded)
              ? _selectedFrequencyPattern
              : null,
          reminderTime: _selectedReminderTime,
          expirationDate: _selectedExpirationDate,
          storageLocation: _storageLocationController.text.isNotEmpty
              ? _storageLocationController.text
              : null,
          isAsNeeded: _isAsNeeded,
        );

        if (widget.medication == null) {
          final newId = await DatabaseHelper().insertMedication(newMedication);
          newMedication.id = newId;
        } else {
          await DatabaseHelper().updateMedication(newMedication);
        }

        // --- Notification Management ---
        final notificationHelper = NotificationHelper();

        // 1. Handle Reminders
        if (!newMedication.isAsNeeded) {
          try {
            await notificationHelper.scheduleNotification(
              id: newMedication.id!,
              title: 'Medication Reminder',
              body: 'Time to take your ${newMedication.name}!',
              scheduledTime: newMedication.reminderTime,
              frequencyPattern: newMedication.frequencyPattern,
            );
          } catch (e) {
            debugPrint('Failed to schedule reminder: $e');
          }
        } else {
          try {
            await notificationHelper.cancelNotification(newMedication.id!);
          } catch (e) {
            debugPrint('Failed to cancel reminder: $e');
          }
        }

        // 2. Handle Expiration Notifications
        if (newMedication.expirationDate != null) {
          try {
            await notificationHelper.scheduleExpirationNotifications(
              newMedication,
            );
          } catch (e) {
            debugPrint('Failed to schedule expiration notifications: $e');
          }
        } else {
          try {
            await notificationHelper.cancelExpirationNotifications(
              newMedication.id!,
            );
          } catch (e) {
            debugPrint('Failed to cancel expiration notifications: $e');
          }
        }

        if (mounted) {
          if (addAnother) {
            // Clear the form for next entry
            _nameController.clear();
            _dosageController.clear();
            _quantityController.clear();
            _storageLocationController.clear();
            _selectedReminderTime = DateTime.now();
            _selectedExpirationDate = null;
            _isAsNeeded = false;
            _useAdvancedFrequency = false;
            setState(() {});

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.medicationSavedAddAnother),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            // Go back to list
            _wasSaved = true;
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        debugPrint('Error saving medication: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.failedToSaveMedication(e.toString())),
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
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _wasSaved);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.medication == null
                ? localizations.addMedication
                : localizations.editMedication,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildBasicInfoFields(localizations),
                const SizedBox(height: 16),
                _buildStorageAndPrnSection(localizations),
                const SizedBox(height: 16),
                if (!_isAsNeeded) _buildFrequencySection(localizations),
                const SizedBox(height: 16),
                _buildDateTimePickers(context, localizations),
                const SizedBox(height: 20),
                _buildActionButtons(localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoFields(AppLocalizations localizations) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: localizations.medicationName),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.pleaseEnterMedicationName;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _dosageController,
          decoration: InputDecoration(labelText: localizations.dosage),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.pleaseEnterDosage;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _quantityController,
          decoration: InputDecoration(labelText: localizations.quantity),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.pleaseEnterTheQuantity;
            }
            if (int.tryParse(value) == null) {
              return localizations.pleaseEnterAValidNumber;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStorageAndPrnSection(AppLocalizations localizations) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _storageLocationController,
                decoration: InputDecoration(
                  labelText: localizations.storageLocationLabel,
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _storageLocationController.text = value;
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: localizations.medicineCabinet,
                            child: Text(localizations.medicineCabinet),
                          ),
                          PopupMenuItem<String>(
                            value: localizations.bedroom,
                            child: Text(localizations.bedroom),
                          ),
                          PopupMenuItem<String>(
                            value: localizations.kitchen,
                            child: Text(localizations.kitchen),
                          ),
                          PopupMenuItem<String>(
                            value: localizations.car,
                            child: Text(localizations.car),
                          ),
                          PopupMenuItem<String>(
                            value: localizations.office,
                            child: Text(localizations.office),
                          ),
                          PopupMenuItem<String>(
                            value: localizations.purseBag,
                            child: Text(localizations.purseBag),
                          ),
                        ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(localizations.asNeededLabel),
          subtitle: Text(localizations.asNeededDescription),
          value: _isAsNeeded,
          onChanged: (value) {
            setState(() {
              _isAsNeeded = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFrequencySection(AppLocalizations localizations) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(localizations.useAdvancedFrequency),
          subtitle: Text(
            _useAdvancedFrequency
                ? localizations.selectSpecificDaysAndPatterns
                : localizations.useSimpleTextFrequency,
          ),
          value: _useAdvancedFrequency,
          onChanged: (value) {
            setState(() {
              _useAdvancedFrequency = value;
            });
          },
        ),
        const SizedBox(height: 8),
        if (!_useAdvancedFrequency)
          _buildSimpleFrequencyDropdown(localizations)
        else
          _buildAdvancedFrequencyCard(localizations),
      ],
    );
  }

  Widget _buildSimpleFrequencyDropdown(AppLocalizations localizations) {
    return DropdownButtonFormField<Frequency>(
      initialValue: _selectedFrequency,
      items: Frequency.values.map((Frequency frequency) {
        String frequencyText;
        switch (frequency) {
          case Frequency.onceDaily:
            frequencyText = localizations.onceDaily;
            break;
          case Frequency.twiceDaily:
            frequencyText = localizations.twiceDaily;
            break;
          case Frequency.threeTimesDaily:
            frequencyText = localizations.threeTimesDaily;
            break;
          case Frequency.asNeeded:
            frequencyText = localizations.asNeeded;
            break;
        }
        return DropdownMenuItem<Frequency>(
          value: frequency,
          child: Text(frequencyText),
        );
      }).toList(),
      onChanged: (Frequency? newValue) {
        setState(() {
          _selectedFrequency = newValue!;
        });
      },
      decoration: InputDecoration(labelText: localizations.frequency),
    );
  }

  Widget _buildAdvancedFrequencyCard(AppLocalizations localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.frequencyPattern,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_selectedFrequencyPattern != null)
              Text(
                _selectedFrequencyPattern!.toReadableString(localizations),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
    );
  }

  Widget _buildDateTimePickers(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(
            _selectedExpirationDate == null
                ? localizations.selectExpirationDateOptional
                : '${localizations.expirationDateLabel}: ${MaterialLocalizations.of(context).formatMediumDate(_selectedExpirationDate!)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today),
              if (_selectedExpirationDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: localizations.clearExpirationDate,
                  onPressed: () {
                    setState(() {
                      _selectedExpirationDate = null;
                    });
                  },
                ),
            ],
          ),
          onTap: () => _selectExpirationDate(context),
        ),
        if (!_isAsNeeded)
          ListTile(
            title: Text(
              '${localizations.reminderTime}: ${TimeOfDay.fromDateTime(_selectedReminderTime).format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context),
          ),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _saveMedication(addAnother: false),
            icon: const Icon(Icons.check),
            label: Text(localizations.save),
          ),
        ),
        if (widget.medication == null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _saveMedication(addAnother: true),
              icon: const Icon(Icons.add),
              label: Text(localizations.saveAndAddMore),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
