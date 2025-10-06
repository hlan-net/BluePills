/// Finnish localization strings for the BluePills application.
///
/// This library provides Finnish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Finnish implementation of [AppLocalizations].
///
/// Provides all localized strings in Finnish (Suomi) for the BluePills application.
class AppLocalizationsFi extends AppLocalizations {
  @override
  String get appTitle => 'SinisetPillerit';

  @override
  String get myMedications => 'Minun lääkkeeni';

  @override
  String get noMedicationsYet => 'Lääkkeitä ei ole vielä lisätty.';

  @override
  String get addMedication => 'Lisää lääke';

  @override
  String get editMedication => 'Muokkaa lääkettä';

  @override
  String get medicationName => 'Lääkkeen nimi';

  @override
  String get dosage => 'Annostus';

  @override
  String get frequency => 'Taajuus';

  @override
  String get reminderTime => 'Muistutusaika';

  @override
  String get saveMedication => 'Tallenna lääke';

  @override
  String get pleaseEnterMedicationName => 'Syötä lääkkeen nimi';

  @override
  String get pleaseEnterDosage => 'Syötä annostus';

  @override
  String get pleaseEnterFrequency => 'Syötä taajuus';

  @override
  String get error => 'Virhe';
}
