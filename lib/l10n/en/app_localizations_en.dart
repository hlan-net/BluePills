/// English localization strings for the BluePills application.
///
/// This library provides English translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// English implementation of [AppLocalizations].
///
/// Provides all localized strings in English for the BluePills application.
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'BluePills';

  @override
  String get myMedications => 'My Medications';

  @override
  String get noMedicationsYet => 'No medications added yet.';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get frequency => 'Frequency';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get pleaseEnterMedicationName => 'Please enter a medication name';

  @override
  String get pleaseEnterDosage => 'Please enter the dosage';

  @override
  String get pleaseEnterFrequency => 'Please enter the frequency';

  @override
  String get error => 'Error';
}
