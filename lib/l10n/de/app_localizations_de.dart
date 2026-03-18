/// German localization strings for the BluePills application.
///
/// This library provides German translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// German implementation of [AppLocalizations].
class AppLocalizationsDe extends AppLocalizations {
  const AppLocalizationsDe();

  @override
  String get appTitle => 'BluePills';

  @override
  String get dosageLabel => 'Dosierung:';

  @override
  String get frequencyLabel => 'Häufigkeit:';

  @override
  String get quantityLabel => 'Menge:';

  @override
  String daysOfSupply(int days) => 'Vorrat für $days Tage';

  @override
  String get addMedication => 'Medikament hinzufügen';

  @override
  String get medicationName => 'Medikamentenname';

  @override
  String get pleaseEnterMedicationName =>
      'Bitte geben Sie den Medikamentennamen ein';

  @override
  String get dosage => 'Dosierung';

  @override
  String get pleaseEnterDosage => 'Bitte geben Sie die Dosierung ein';

  @override
  String get saveMedication => 'Medikament speichern';

  @override
  String get quantity => 'Menge';

  @override
  String get pleaseEnterTheQuantity => 'Bitte geben Sie die Menge ein';

  @override
  String get pleaseEnterAValidNumber =>
      'Bitte geben Sie eine gültige Nummer ein';

  @override
  String get pleaseEnterFrequency => 'Bitte geben Sie die Häufigkeit ein';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get selectReminderTime => 'Erinnerungszeit wählen';

  @override
  String get save => 'Speichern';

  @override
  String get saveAndAddMore => 'Speichern und weiteres hinzufügen';

  @override
  String get medicationSavedAddAnother =>
      'Medikament gespeichert. Ein weiteres hinzufügen?';

  @override
  String failedToSaveMedication(String error) =>
      'Fehler beim Speichern des Medikaments: $error';

  @override
  String get myMedications => 'Meine Medikamente';

  @override
  String get noMedicationsYet => 'Noch keine Medikamente hinzugefügt.';

  @override
  String get tapThePlusButtonToAdd =>
      'Tippen Sie auf die Schaltfläche +, um eines hinzuzufügen.';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get english => 'Englisch';

  @override
  String get finnish => 'Finnisch';

  @override
  String get swedish => 'Schwedisch';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get deviceLanguage => 'Gerätesprache';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get followSystem => 'Systemstandard';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get deleteMedication => 'Medikament löschen';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Sind Sie sicher, dass Sie dieses Medikament löschen möchten?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get error => 'Fehler';

  @override
  String get add => 'Hinzufügen';

  @override
  String markedAsTaken(String name) => '$name als eingenommen markiert';

  @override
  String noMedicationLeftInStock(String name) => 'Kein $name mehr auf Vorrat';

  @override
  String get setReminderFeatureComingSoon =>
      'Erinnerungsfunktion kommt in Kürze';

  @override
  String get selectMedication => 'Medikament auswählen';

  @override
  String get todaysMedications => 'Heutige Medikamente';

  @override
  String takenOf(int taken, int total) => '$taken von $total eingenommen';

  @override
  String get takeAll => 'Alle einnehmen';

  @override
  String get noMedicationsScheduledForToday =>
      'Für heute sind keine Medikamente geplant.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get medicationLogs => 'Protokolle';

  @override
  String get noLogsYet => 'Noch keine Protokolle vorhanden.';

  @override
  String get time => 'Zeit';

  @override
  String get medicationAdherence => 'Therapietreue';

  @override
  String get noDataAvailable => 'Keine Daten verfügbar';

  @override
  String get noMedicationLogsYet => 'Noch keine Protokolle vorhanden';

  @override
  String get adherenceStatistics => 'Statistiken';

  @override
  String get last7Days => 'Letzte 7 Tage';

  @override
  String get last30Days => 'Letzte 30 Tage';

  @override
  String get overallAdherence => 'Gesamttreue';

  @override
  String get dosesTaken => 'Eingenommen';

  @override
  String get dosesMissed => 'Verpasst';

  @override
  String get weeklyView => 'Wochenansicht';

  @override
  String get monthlyView => 'Monatsansicht';

  @override
  String get daily => 'Täglich';

  @override
  String get specificDays => 'Bestimmte Tage';

  @override
  String get everyNDays => 'Alle N Tage';

  @override
  String get selectDays => 'Tage wählen';

  @override
  String get every => 'Alle';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String get timesPerDay => 'Mal täglich';

  @override
  String timesDaily(int times) =>
      times == 1 ? 'Einmal täglich' : '$times Mal täglich';

  @override
  String onDays(String days) => 'Am $days';

  @override
  String timesOnDays(int times, String days) =>
      times == 1 ? 'Am $days' : '$times Mal am $days';

  @override
  String everyIntervalDays(int days) =>
      days == 1 ? 'Jeden Tag' : 'Alle $days Tage';

  @override
  String get everyDay => 'Jeden Tag';

  @override
  String get synchronization => 'Synchronisierung';

  @override
  String get blueskySynchronization => 'BlueSky-Synchronisierung';

  @override
  String get enableBlueSkySync => 'BlueSky-Synchronisierung aktivieren';

  @override
  String get blueSkyHandle => 'BlueSky-Benutzername';

  @override
  String get yourHandleBskySocial => 'ihrhandle.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle =>
      'Bitte BlueSky-Benutzernamen eingeben';

  @override
  String get personalDataServerPDSURL => 'Personal Data Server (PDS) URL';

  @override
  String get yourPdsExampleCom => 'pds.beispiel.com';

  @override
  String get pleaseEnterYourPDSURL => 'Bitte PDS-URL eingeben';

  @override
  String get pleaseEnterAValidURL => 'Bitte eine gültige URL eingeben';

  @override
  String get enabling => 'Wird aktiviert...';

  @override
  String get appPassword => 'App-Passwort';

  @override
  String get disableSync => 'Synchronisierung deaktivieren';

  @override
  String get disableBlueSkySync => 'BlueSky-Synchronisierung deaktivieren';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Sind Sie sicher, dass Sie die BlueSky-Synchronisierung deaktivieren möchten?';

  @override
  String get disable => 'Deaktivieren';

  @override
  String get status => 'Status';

  @override
  String get syncDisabled => 'Synchronisierung deaktiviert';

  @override
  String get loggedIn => 'Angemeldet';

  @override
  String get loggedOut => 'Abgemeldet';

  @override
  String get lastSyncedAt => 'Zuletzt synchronisiert';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get confirmLogout => 'Abmelden bestätigen';

  @override
  String get areYouSureYouWantToLogoutFromBlueSky =>
      'Sind Sie sicher, dass Sie sich von BlueSky abmelden möchten?';

  @override
  String connectedAs(String name) => 'Verbunden als $name';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get googleDriveBackup => 'Google Drive-Sicherung';

  @override
  String get backupToGoogleDrive => 'Sicherung auf Google Drive';

  @override
  String get lastBackupAt => 'Letzte Sicherung';

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String get restoreNow => 'Jetzt wiederherstellen';

  @override
  String get restoreNowButton => 'Jetzt wiederherstellen';

  @override
  String get connectToGoogleDrive => 'Mit Google Drive verbinden';

  @override
  String get disconnectGoogleDrive => 'Google Drive trennen';

  @override
  String get backupSuccessful => 'Sicherung erfolgreich abgeschlossen';

  @override
  String backupFailed(String error) => 'Sicherung fehlgeschlagen: $error';

  @override
  String get restoreFromGoogleDrive => 'Von Google Drive wiederherstellen';

  @override
  String get restoreSuccessful => 'Wiederherstellung erfolgreich';

  @override
  String restoreFailed(String error) =>
      'Wiederherstellung fehlgeschlagen: $error';

  @override
  String get autoRestoreFromBackup => 'Autom. Wiederherstellung aus Sicherung';

  @override
  String get restoreNewerBackupOnStartup =>
      'Neuere Sicherung beim Start wiederherstellen';

  @override
  String get noBackupFound => 'Keine Sicherung gefunden';

  @override
  String get dataExportedTo => 'Daten exportiert nach';

  @override
  String failedToExportData(String error) =>
      'Datenexport fehlgeschlagen: $error';

  @override
  String get dataExportedSuccessfully => 'Daten erfolgreich exportiert';

  @override
  String get dataImportedSuccessfully => 'Daten erfolgreich importiert';

  @override
  String failedToImportData(String error) =>
      'Datenimport fehlgeschlagen: $error';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get importData => 'Daten importieren';

  @override
  String get aboutBlueSkyIntegration => 'Über BlueSky-Integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills verwendet das BlueSky AT-Protokoll zur Gerätesynchronisierung.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Ihre Daten werden sicher auf Ihrem eigenen Personal Data Server (PDS) gespeichert.';

  @override
  String get licenseAndLegal => 'Lizenzen & Rechtliches';

  @override
  String get mitLicense => 'MIT-Lizenz';

  @override
  String get medicalDisclaimer => 'Medizinischer Haftungsausschluss';

  @override
  String get medicalDisclaimerDescription =>
      'Diese App dient nur zur Informationsverwaltung. Konsultieren Sie immer Ihren Arzt, bevor Sie Ihre Medikation ändern.';

  @override
  String get syncModeLocalOnlyDescription => 'Nur lokaler Speicher';

  @override
  String get syncModeSyncEnabledDescription => 'Synchronisierung aktiviert';

  @override
  String get syncModeSyncOnlyDescription => 'Nur Synchronisierung';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get testNotification => 'Test-Benachrichtigung';

  @override
  String get notificationSent => 'Test-Benachrichtigung gesendet';

  @override
  String get medicationReminders => 'Medikamentenerinnerungen';

  @override
  String get remindersToTakeYourMedication =>
      'Erinnerungen an Ihre Medikamenteneinnahme';

  @override
  String get timeToTakeYour => 'Zeit für die Einnahme von';

  @override
  String get editMedication => 'Medikament bearbeiten';

  @override
  String get medicationDetails => 'Medikamentendetails';

  @override
  String get addStock => 'Vorrat hinzufügen';

  @override
  String get currentQuantity => 'Aktuelle Menge';

  @override
  String get quantityToAdd => 'Hinzuzufügende Menge';

  @override
  String get confirmAddStock => 'Hinzufügen bestätigen';

  @override
  String get stockAddedSuccessfully => 'Vorrat erfolgreich hinzugefügt';

  @override
  String get saveStock => 'Vorrat speichern';

  @override
  String addStockFor(String medicationName) =>
      'Vorrat hinzufügen für: $medicationName';

  @override
  String get dailyMedications => 'Tägliche Medikamente';

  @override
  String get allMedications => 'Alle Medikamente';

  @override
  String get showLowStock => 'Geringer Lagerbestand anzeigen';

  @override
  String get showExpiringSoon => 'Bald ablaufend anzeigen';

  @override
  String get expirationDate => 'Verfallsdatum';

  @override
  String get expirationDateLabel => 'Verfallsdatum';

  @override
  String get expiresLabel => 'Läuft ab:';

  @override
  String get selectExpirationDateOptional => 'Verfallsdatum wählen (Optional)';

  @override
  String get clearExpirationDate => 'Verfallsdatum löschen';

  @override
  String get syncCompletedSuccessfully => 'Synchronisierung erfolgreich';

  @override
  String syncFailed(String error) => 'Synchronisierung fehlgeschlagen: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-Synchronisierung aktiviert';

  @override
  String failedToEnableSync(String error) =>
      'Synchronisierung fehlgeschlagen: $error';

  @override
  String get blueskySyncDisabled => 'BlueSky-Synchronisierung deaktiviert';

  @override
  String failedToDisableSync(String error) =>
      'Deaktivierung fehlgeschlagen: $error';

  @override
  String criticallyLowStock(int count) => 'Kritisch niedriger Bestand ($count)';

  @override
  String get dismiss => 'Verwerfen';

  @override
  String get setReminder => 'Erinnerung einstellen';

  @override
  String get logDose => 'Dosis protokollieren';

  @override
  String get newMedication => 'Neues Medikament';

  @override
  String reminderSetFor(String name, String time) =>
      'Erinnerung für $name auf $time Uhr eingestellt';

  @override
  String loggedDoseFor(String name) => 'Dosis für $name protokolliert';

  @override
  String get onceDaily => 'Einmal täglich';

  @override
  String get twiceDaily => 'Zweimal täglich';

  @override
  String get threeTimesDaily => 'Dreimal täglich';

  @override
  String get asNeeded => 'Bei Bedarf';

  @override
  String get monday => 'Montag';

  @override
  String get tuesday => 'Dienstag';

  @override
  String get wednesday => 'Mittwoch';

  @override
  String get thursday => 'Donnerstag';

  @override
  String get friday => 'Freitag';

  @override
  String get saturday => 'Samstag';

  @override
  String get sunday => 'Sonntag';

  @override
  String get mon => 'Mo';

  @override
  String get tue => 'Di';

  @override
  String get wed => 'Mi';

  @override
  String get thu => 'Do';

  @override
  String get fri => 'Fr';

  @override
  String get sat => 'Sa';

  @override
  String get sun => 'So';

  @override
  String get timesPerDayLabel => 'Mal pro Tag';

  @override
  String get everyDayLabel => 'jeden Tag';

  @override
  String get everyNDaysLabel => 'alle N Tage';

  @override
  String get intervalDaysLabel => 'Tage Intervall';

  @override
  String get pleaseSelectAFrequencyPattern => 'Bitte Häufigkeitsmuster wählen';

  @override
  String get pleaseSelectAtLeastOneDay => 'Bitte mindestens einen Tag wählen';

  @override
  String get useAdvancedFrequency => 'Erweiterte Häufigkeit verwenden';

  @override
  String get selectSpecificDaysAndPatterns => 'Tage und Muster wählen';

  @override
  String get useSimpleTextFrequency => 'Einfache Häufigkeit verwenden';

  @override
  String get frequencyPattern => 'Häufigkeitsmuster';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get noMedicationsAvailable => 'Keine Medikamente verfügbar';

  @override
  String get storageLocation => 'Lagerort';

  @override
  String get storageLocationLabel => 'Lagerort';

  @override
  String get asNeededLabel => 'Bei Bedarf (PRN)';

  @override
  String get asNeededDescription => 'Kein fester Zeitplan';

  @override
  String get lastTaken => 'Zuletzt eingenommen';

  @override
  String lastTakenDaysAgo(int days) => days == 0
      ? 'Zuletzt eingenommen: Heute'
      : 'Zuletzt eingenommen: vor $days Tagen';

  @override
  String get selectLocation => 'Ort wählen';

  @override
  String get medicineCabinet => 'Medizinschrank';

  @override
  String get bedroom => 'Schlafzimmer';

  @override
  String get kitchen => 'Küche';

  @override
  String get car => 'Auto';

  @override
  String get office => 'Büro';

  @override
  String get purseBag => 'Tasche';
}
