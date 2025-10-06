/// Base class for application localizations.
///
/// This library defines the abstract base class for all localized strings
/// used in the BluePills application. Implementations provide translations
/// for specific languages.
library;

import 'package:flutter/material.dart';

/// Abstract base class for application localizations.
///
/// Defines all the localized strings used throughout the application.
/// Concrete implementations (e.g., [AppLocalizationsEn], [AppLocalizationsFi])
/// provide the actual translations for specific languages.
///
/// Access localizations in your widgets using:
/// ```dart
/// final localizations = AppLocalizations.of(context);
/// Text(localizations.appTitle);
/// ```
abstract class AppLocalizations {
  /// Retrieves the localized strings for the current context.
  ///
  /// Returns null if localizations haven't been loaded yet.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// List of locales supported by the application.
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fi', 'FI'), // Finnish
  ];

  // App title
  String get appTitle;

  // Main screen
  String get myMedications;
  String get noMedicationsYet;

  // Form screen
  String get addMedication;
  String get editMedication;
  String get medicationName;
  String get dosage;
  String get frequency;
  String get reminderTime;
  String get saveMedication;

  // Validation messages
  String get pleaseEnterMedicationName;
  String get pleaseEnterDosage;
  String get pleaseEnterFrequency;

  // Generic
  String get error;
}
