/// English localization strings for the BluePills application.
///
/// This library provides English translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// English implementation of [AppLocalizations].
class AppLocalizationsEn extends AppLocalizations {
  const AppLocalizationsEn();

  @override
  String get appTitle => 'BluePills';

  @override
  String get dosageLabel => 'Dosage:';

  @override
  String get frequencyLabel => 'Frequency:';

  @override
  String get quantityLabel => 'Quantity:';

  @override
  String daysOfSupply(int days) => '$days days of supply';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get pleaseEnterMedicationName => 'Please enter medication name';

  @override
  String get dosage => 'Dosage';

  @override
  String get pleaseEnterDosage => 'Please enter dosage';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get quantity => 'Quantity';

  @override
  String get pleaseEnterTheQuantity => 'Please enter the quantity';

  @override
  String get pleaseEnterAValidNumber => 'Please enter a valid number';

  @override
  String get pleaseEnterFrequency => 'Please enter frequency';

  @override
  String get frequency => 'Frequency';

  @override
  String get selectReminderTime => 'Select Reminder Time';

  @override
  String get save => 'Save';

  @override
  String get saveAndAddMore => 'Save and Add More';

  @override
  String get medicationSavedAddAnother => 'Medication saved. Add another?';

  @override
  String failedToSaveMedication(String error) =>
      'Failed to save medication: $error';

  @override
  String get myMedications => 'My Medications';

  @override
  String get noMedicationsYet => 'No medications added yet.';

  @override
  String get tapThePlusButtonToAdd => 'Tap the + button to add one.';

  @override
  String get selectLanguage => 'Select Language';

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
  String get appLanguage => 'App Language';

  @override
  String get deviceLanguage => 'Device Language';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get followSystem => 'Follow System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Are you sure you want to delete this medication?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get error => 'Error';

  @override
  String get add => 'Add';

  @override
  String markedAsTaken(String name) => '$name marked as taken';

  @override
  String noMedicationLeftInStock(String name) => 'No $name left in stock';

  @override
  String get setReminderFeatureComingSoon => 'Set reminder feature coming soon';

  @override
  String get selectMedication => 'Select Medication';

  @override
  String get todaysMedications => 'Today\'s Medications';

  @override
  String takenOf(int taken, int total) => 'Taken $taken of $total';

  @override
  String get takeAll => 'Take All';

  @override
  String get noMedicationsScheduledForToday =>
      'No medications scheduled for today.';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get medicationLogs => 'Medication Logs';

  @override
  String get noLogsYet => 'No logs yet.';

  @override
  String get time => 'Time';

  @override
  String get medicationAdherence => 'Medication Adherence';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get noMedicationLogsYet => 'No medication logs yet';

  @override
  String get adherenceStatistics => 'Adherence Statistics';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get overallAdherence => 'Overall Adherence';

  @override
  String get dosesTaken => 'Doses Taken';

  @override
  String get dosesMissed => 'Doses Missed';

  @override
  String get weeklyView => 'Weekly View';

  @override
  String get monthlyView => 'Monthly View';

  @override
  String get daily => 'Daily';

  @override
  String get specificDays => 'Specific Days';

  @override
  String get everyNDays => 'Every N Days';

  @override
  String get selectDays => 'Select Days';

  @override
  String get every => 'Every';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get timesPerDay => 'times per day';

  @override
  String timesDaily(int times) =>
      times == 1 ? 'Once daily' : '$times times daily';

  @override
  String onDays(String days) => 'On $days';

  @override
  String timesOnDays(int times, String days) =>
      times == 1 ? 'On $days' : '$times times on $days';

  @override
  String everyIntervalDays(int days) =>
      days == 1 ? 'Every day' : 'Every $days days';

  @override
  String get everyDay => 'Every day';

  @override
  String get synchronization => 'Synchronization';

  @override
  String get blueskySynchronization => 'BlueSky Synchronization';

  @override
  String get enableBlueSkySync => 'Enable BlueSky Sync';

  @override
  String get blueSkyHandle => 'BlueSky Handle';

  @override
  String get yourHandleBskySocial => 'yourhandle.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle => 'Please enter your BlueSky handle';

  @override
  String get personalDataServerPDSURL => 'Personal Data Server (PDS) URL';

  @override
  String get yourPdsExampleCom => 'pds.example.com';

  @override
  String get pleaseEnterYourPDSURL => 'Please enter your PDS URL';

  @override
  String get pleaseEnterAValidURL => 'Please enter a valid URL';

  @override
  String get enabling => 'Enabling...';

  @override
  String get appPassword => 'App Password';

  @override
  String get disableSync => 'Disable Sync';

  @override
  String get disableBlueSkySync => 'Disable BlueSky Sync';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Are you sure you want to disable BlueSky sync?';

  @override
  String get disable => 'Disable';

  @override
  String get status => 'Status';

  @override
  String get syncDisabled => 'Sync disabled';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get loggedOut => 'Logged out';

  @override
  String get lastSyncedAt => 'Last synced at';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get areYouSureYouWantToLogoutFromBlueSky =>
      'Are you sure you want to logout from BlueSky?';

  @override
  String connectedAs(String name) => 'Connected as $name';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get googleDriveBackup => 'Google Drive Backup';

  @override
  String get backupToGoogleDrive => 'Backup to Google Drive';

  @override
  String get lastBackupAt => 'Last backup at';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get restoreNow => 'Restore Now';

  @override
  String get restoreNowButton => 'Restore Now';

  @override
  String get connectToGoogleDrive => 'Connect to Google Drive';

  @override
  String get disconnectGoogleDrive => 'Disconnect Google Drive';

  @override
  String get backupSuccessful => 'Backup successful';

  @override
  String backupFailed(String error) => 'Backup failed: $error';

  @override
  String get restoreFromGoogleDrive => 'Restore from Google Drive';

  @override
  String get restoreSuccessful => 'Restore successful';

  @override
  String restoreFailed(String error) => 'Restore failed: $error';

  @override
  String get autoRestoreFromBackup => 'Auto restore from backup';

  @override
  String get restoreNewerBackupOnStartup =>
      'Restore newer backup on startup';

  @override
  String get noBackupFound => 'No backup found';

  @override
  String get dataExportedTo => 'Data exported to';

  @override
  String failedToExportData(String error) => 'Failed to export data: $error';

  @override
  String get dataExportedSuccessfully => 'Data exported successfully';

  @override
  String get dataImportedSuccessfully => 'Data imported successfully';

  @override
  String failedToImportData(String error) => 'Failed to import data: $error';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get aboutBlueSkyIntegration => 'About BlueSky Integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills uses the BlueSky AT Protocol to synchronize your data across devices.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Your data is stored securely on your own Personal Data Server (PDS).';

  @override
  String get licenseAndLegal => 'License & Legal';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get medicalDisclaimer => 'Medical Disclaimer';

  @override
  String get medicalDisclaimerDescription =>
      'This app is for information management only. Always consult your doctor before changing medication.';

  @override
  String get syncModeLocalOnlyDescription => 'Local storage only';

  @override
  String get syncModeSyncEnabledDescription => 'Sync enabled';

  @override
  String get syncModeSyncOnlyDescription => 'Sync only';

  @override
  String get notifications => 'Notifications';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get notificationSent => 'Test notification sent';

  @override
  String get medicationReminders => 'Medication Reminders';

  @override
  String get remindersToTakeYourMedication =>
      'Reminders to take your medication';

  @override
  String get timeToTakeYour => 'Time to take your';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get medicationDetails => 'Medication Details';

  @override
  String get addStock => 'Add Stock';

  @override
  String get currentQuantity => 'Current Quantity';

  @override
  String get quantityToAdd => 'Quantity to Add';

  @override
  String get confirmAddStock => 'Confirm Add Stock';

  @override
  String get stockAddedSuccessfully => 'Stock added successfully';

  @override
  String get saveStock => 'Save Stock';

  @override
  String addStockFor(String medicationName) => 'Add Stock For: $medicationName';

  @override
  String get dailyMedications => 'Daily Medications';

  @override
  String get allMedications => 'All Medications';

  @override
  String get showLowStock => 'Show Low Stock';

  @override
  String get showExpiringSoon => 'Show Expiring Soon';

  @override
  String get expirationDate => 'Expiration Date';

  @override
  String get expirationDateLabel => 'Expiration Date';

  @override
  String get expiresLabel => 'Expires:';

  @override
  String get selectExpirationDateOptional =>
      'Select Expiration Date (Optional)';

  @override
  String get clearExpirationDate => 'Clear Expiration Date';

  @override
  String get syncCompletedSuccessfully => 'Sync completed successfully';

  @override
  String syncFailed(String error) => 'Sync failed: $error';

  @override
  String get blueskySyncEnabledSuccessfully => 'BlueSky sync enabled successfully';

  @override
  String failedToEnableSync(String error) => 'Failed to enable sync: $error';

  @override
  String get blueskySyncDisabled => 'BlueSky sync disabled';

  @override
  String failedToDisableSync(String error) => 'Failed to disable sync: $error';

  @override
  String criticallyLowStock(int count) => 'Critically low stock ($count)';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get logDose => 'Log Dose';

  @override
  String get newMedication => 'New Medication';

  @override
  String reminderSetFor(String name, String time) =>
      'Reminder for $name set for $time';

  @override
  String loggedDoseFor(String name) => 'Logged dose for $name';

  @override
  String get onceDaily => 'Once daily';

  @override
  String get twiceDaily => 'Twice daily';

  @override
  String get threeTimesDaily => 'Three times daily';

  @override
  String get asNeeded => 'As needed';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get timesPerDayLabel => 'times per day';

  @override
  String get everyDayLabel => 'every day';

  @override
  String get everyNDaysLabel => 'every N days';

  @override
  String get intervalDaysLabel => 'days interval';

  @override
  String get pleaseSelectAFrequencyPattern => 'Please select a frequency pattern';

  @override
  String get pleaseSelectAtLeastOneDay => 'Please select at least one day';

  @override
  String get useAdvancedFrequency => 'Use Advanced Frequency';

  @override
  String get selectSpecificDaysAndPatterns => 'Select specific days and patterns';

  @override
  String get useSimpleTextFrequency => 'Use simple text frequency';

  @override
  String get frequencyPattern => 'Frequency Pattern';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get noMedicationsAvailable => 'No medications available';

  @override
  String get storageLocation => 'Storage Location';

  @override
  String get storageLocationLabel => 'Storage Location';

  @override
  String get asNeededLabel => 'As-Needed (PRN)';

  @override
  String get asNeededDescription => 'No fixed schedule';

  @override
  String get lastTaken => 'Last taken';

  @override
  String lastTakenDaysAgo(int days) =>
      days == 0 ? 'Last taken: Today' : 'Last taken: $days days ago';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get medicineCabinet => 'Medicine Cabinet';

  @override
  String get bedroom => 'Bedroom';

  @override
  String get kitchen => 'Kitchen';

  @override
  String get car => 'Car';

  @override
  String get office => 'Office';

  @override
  String get purseBag => 'Purse/Bag';
}
