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

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get deviceLanguage => 'Device Language';

  @override
  String get english => 'English';

  @override
  String get finnish => 'Finnish';

  @override
  String get swedish => 'Swedish';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get noMedicationsAvailable => 'No medications available. Please add a medication first.';

  @override
  String get selectMedication => 'Select Medication';

  @override
  String get cancel => 'Cancel';

  @override
  String loggedDoseFor(String medicationName) => 'Logged dose for $medicationName';

  @override
  String noMedicationLeftInStock(String medicationName) => 'No $medicationName left in stock';

  @override
  String get setReminderFeatureComingSoon => 'Set reminder feature - coming soon!';

  @override
  String get tapThePlusButtonToAdd => 'Tap the + button to add your first medication';

  @override
  String get todaysMedications => "Today's Medications";

  @override
  String takenOf(int taken, int total) => '$taken of $total taken';

  @override
  String markedAsTaken(String medicationName) => '✓ $medicationName marked as taken';

  @override
  String get allMedications => 'All Medications';

  @override
  String get deleteMedication => 'Delete Medication?';

  @override
  String get areYouSureYouWantToDeleteThisMedication => 'Are you sure you want to delete this medication?';

  @override
  String get delete => 'Delete';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get logDose => 'Log Dose';

  @override
  String get newMedication => 'New Medication';

  @override
  String get add => 'Add';

  @override
  String get pleaseSelectAFrequencyPattern => 'Please select a frequency pattern';

  @override
  String get pleaseSelectAtLeastOneDay => 'Please select at least one day';

  @override
  String get medicationSavedAddAnother => 'Medication saved! Add another.';

  @override
  String failedToSaveMedication(String error) => 'Failed to save medication: $error';

  @override
  String get quantity => 'Quantity';

  @override
  String get pleaseEnterTheQuantity => 'Please enter the quantity';

  @override
  String get pleaseEnterAValidNumber => 'Please enter a valid number';

  @override
  String get useAdvancedFrequency => 'Use Advanced Frequency';

  @override
  String get selectSpecificDaysAndPatterns => 'Select specific days and patterns';

  @override
  String get useSimpleTextFrequency => 'Use simple text frequency';

  @override
  String get frequencyPattern => 'Frequency Pattern';

  @override
  String get save => 'Save';

  @override
  String get saveAndAddMore => 'Save & Add More';

  @override
  String get onceDaily => 'Once Daily';

  @override
  String get twiceDaily => 'Twice Daily';

  @override
  String get threeTimesDaily => 'Three Times Daily';

  @override
  String get asNeeded => 'As Needed';

  @override
  String get dosageLabel => 'Dosage:';

  @override
  String get frequencyLabel => 'Frequency:';

  @override
  String get quantityLabel => 'Quantity:';

  @override
  String get addStock => 'Add Stock';

  @override
  String addStockFor(String medicationName) => 'Add Stock for $medicationName';

  @override
  String get saveStock => 'Save Stock';

  @override
  String get blueskySynchronization => 'BlueSky Synchronization';

  @override
  String get blueskyHandle => 'BlueSky Handle';

  @override
  String get yourHandleBskySocial => 'your.handle.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle => 'Please enter your BlueSky handle';

  @override
  String get personalDataServerPDSURL => 'Personal Data Server (PDS) URL';

  @override
  String get yourPdsExampleCom => 'https://your-pds.example.com';

  @override
  String get pleaseEnterYourPDSURL => 'Please enter your PDS URL';

  @override
  String get pleaseEnterAValidURL => 'Please enter a valid URL';

  @override
  String get enabling => 'Enabling...';

  @override
  String get enableBlueSkySync => 'Enable BlueSky Sync';

  @override
  String get disableSync => 'Disable Sync';

  @override
  String get disableBlueSkySync => 'Disable BlueSky Sync';

  @override
  String get disableBlueSkySyncConfirmation =>
      'This will disable synchronization with BlueSky. Your data will remain stored locally. Are you sure you want to continue?';

  @override
  String get disable => 'Disable';

  @override
  String get blueskySyncDisabled => 'BlueSky sync disabled';

  @override
  String failedToDisableSync(String error) => 'Failed to disable sync: $error';

  @override
  String get blueskySyncEnabledSuccessfully => 'BlueSky sync enabled successfully!';

  @override
  String failedToEnableSync(String error) => 'Failed to enable sync: $error';

  @override
  String get googleDriveBackup => 'Google Drive Backup';

  @override
  String connectedAs(String userId) => 'Connected as: $userId';

  @override
  String get autoRestoreFromBackup => 'Auto-restore from backup';

  @override
  String get restoreNewerBackupOnStartup => 'Restore newer backup on startup';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get restoreNow => 'Restore Now';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get backupSuccessful => 'Backup successful!';

  @override
  String backupFailed(String error) => 'Backup failed: $error';

  @override
  String get restoreSuccessful => 'Restore successful! Please restart the app.';

  @override
  String get noBackupFound => 'No backup found.';

  @override
  String restoreFailed(String error) => 'Restore failed: $error';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get importData => 'Import Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get dataImportedSuccessfully => 'Data imported successfully!';

  @override
  String failedToImportData(String error) => 'Failed to import data: $error';

  @override
  String get dataExportedSuccessfully => 'Data exported successfully!';

  @override
  String failedToExportData(String error) => 'Failed to export data: $error';

  @override
  String get aboutBlueSkyIntegration => 'About BlueSky Integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills uses the AT Protocol to sync your medication data with your personal BlueSky account. This allows you to access your medications from any device while maintaining full control over your data.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Your medication data will be stored securely on your chosen Personal Data Server (PDS) and synchronized across all your devices.';

  @override
  String get licenseAndLegal => 'License & Legal';

  @override
  String get mitLicense => 'BluePills is open source software licensed under the MIT License.';

  @override
  String get medicalDisclaimer => 'Medical Disclaimer';

  @override
  String get medicalDisclaimerDescription =>
      'This software is for informational purposes only and is not intended to replace professional medical advice, diagnosis, or treatment. Always consult healthcare professionals regarding your medications.';

  @override
  String get syncModeLocalOnlyDescription => 'Store data locally on this device only';

  @override
  String get syncModeSyncEnabledDescription => 'Store locally and sync with BlueSky';

  @override
  String get syncModeSyncOnlyDescription => 'Store only on BlueSky (requires internet connection)';
}
