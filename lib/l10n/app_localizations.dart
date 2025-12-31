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
    Locale('en'), // English
    Locale('fi', 'FI'), // Finnish
    Locale('sv', 'SE'), // Swedish
    Locale('de', 'DE'), // German
    Locale('es', 'ES'), // Spanish
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

  // Settings screen
  String get settings;
  String get language;
  String get appLanguage;
  String get deviceLanguage;
  String get english;
  String get finnish;
  String get swedish;
  String get german;
  String get spanish;

  // Medication list screen
  String get noMedicationsAvailable;
  String get selectMedication;
  String get cancel;
  String loggedDoseFor(String medicationName);
  String noMedicationLeftInStock(String medicationName);
  String get setReminderFeatureComingSoon;
  String get tapThePlusButtonToAdd;
  String get todaysMedications;
  String takenOf(int taken, int total);
  String markedAsTaken(String medicationName);
  String get allMedications;
  String get deleteMedication;
  String get areYouSureYouWantToDeleteThisMedication;
  String get delete;
  String get setReminder;
  String get logDose;
  String get newMedication;
  String get add;

  // Medication form screen
  String get pleaseSelectAFrequencyPattern;
  String get pleaseSelectAtLeastOneDay;
  String get medicationSavedAddAnother;
  String failedToSaveMedication(String error);
  String get quantity;
  String get pleaseEnterTheQuantity;
  String get pleaseEnterAValidNumber;
  String get useAdvancedFrequency;
  String get selectSpecificDaysAndPatterns;
  String get useSimpleTextFrequency;
  String get frequencyPattern;
  String get save;
  String get saveAndAddMore;

  // Frequency options
  String get onceDaily;
  String get twiceDaily;
  String get threeTimesDaily;
  String get asNeeded;

  // Medication details screen
  String get dosageLabel;
  String get frequencyLabel;
  String get quantityLabel;
  String get addStock;

  // Add stock screen
  String addStockFor(String medicationName);
  String get saveStock;

  // Settings screen
  String get blueskySynchronization;
  String get blueskyHandle;
  String get yourHandleBskySocial;
  String get pleaseEnterYourBlueskyHandle;
  String get personalDataServerPDSURL;
  String get yourPdsExampleCom;
  String get pleaseEnterYourPDSURL;
  String get pleaseEnterAValidURL;
  String get enabling;
  String get enableBlueSkySync;
  String get disableSync;
  String get disableBlueSkySync;
  String get disableBlueSkySyncConfirmation;
  String get disable;
  String get blueskySyncDisabled;
  String failedToDisableSync(String error);
  String get blueskySyncEnabledSuccessfully;
  String failedToEnableSync(String error);

  // Google Drive Backup Card
  String get googleDriveBackup;
  String connectedAs(String userId);
  String get autoRestoreFromBackup;
  String get restoreNewerBackupOnStartup;
  String get backupNow;
  String get restoreNow;
  String get disconnect;
  String get backupSuccessful;
  String backupFailed(String error);
  String get restoreSuccessful;
  String get noBackupFound;
  String restoreFailed(String error);

  // Data Management Card
  String get dataManagement;
  String get importData;
  String get exportData;
  String get dataImportedSuccessfully;
  String failedToImportData(String error);
  String get dataExportedSuccessfully;
  String failedToExportData(String error);

  // About Card
  String get aboutBlueSkyIntegration;
  String get aboutBlueSkyIntegrationDescription;
  String get aboutBlueSkyIntegrationDescription2;
  String get licenseAndLegal;
  String get mitLicense;
  String get medicalDisclaimer;
  String get medicalDisclaimerDescription;

  // Sync Mode descriptions
  String get syncModeLocalOnlyDescription;
  String get syncModeSyncEnabledDescription;
  String get syncModeSyncOnlyDescription;

  // Low Stock & Dashboard
  String criticallyLowStock(int count);
  String get dismiss;
  String get takeAll;
  String get noMedicationsScheduledForToday;

  // Adherence Screen
  String get medicationAdherence;
  String get noDataAvailable;
  String get noMedicationLogsYet;
  String get adherenceStatistics;
  String get last7Days;
  String get last30Days;

  // Frequency Selector & Patterns
  String get daily;
  String get specificDays;
  String get everyNDays;
  String get selectDays;
  String get every;
  String get day;
  String get days;
  String get timesPerDay;
  String timesDaily(int times);
  String onDays(String days);
  String timesOnDays(int times, String days);
  String everyIntervalDays(int days);
  String get everyDay;
}
