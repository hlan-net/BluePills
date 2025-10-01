import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

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
