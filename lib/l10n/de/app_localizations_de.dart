/// German localization strings for the BluePills application.
///
/// This library provides German translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// German implementation of [AppLocalizations].
///
/// Provides all localized strings in German for the BluePills application.
class AppLocalizationsDe extends AppLocalizations {
  @override
  String get appTitle => 'BluePills';

  @override
  String get myMedications => 'Meine Medikamente';

  @override
  String get noMedicationsYet => 'Noch keine Medikamente hinzugefügt.';

  @override
  String get addMedication => 'Medikament hinzufügen';

  @override
  String get editMedication => 'Medikament bearbeiten';

  @override
  String get medicationName => 'Name des Medikaments';

  @override
  String get dosage => 'Dosierung';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get saveMedication => 'Medikament speichern';

  @override
  String get pleaseEnterMedicationName =>
      'Bitte geben Sie einen Medikamentennamen ein';

  @override
  String get pleaseEnterDosage => 'Bitte geben Sie die Dosierung ein';

  @override
  String get pleaseEnterFrequency => 'Bitte geben Sie die Häufigkeit ein';

  @override
  String get error => 'Fehler';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get deviceLanguage => 'Gerätesprache';

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
  String get noMedicationsAvailable =>
      'Keine Medikamente verfügbar. Bitte fügen Sie zuerst ein Medikament hinzu.';

  @override
  String get selectMedication => 'Medikament auswählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String loggedDoseFor(String medicationName) =>
      'Dosis für $medicationName protokolliert';

  @override
  String noMedicationLeftInStock(String medicationName) =>
      'Kein $medicationName mehr auf Lager';

  @override
  String get setReminderFeatureComingSoon =>
      'Erinnerungsfunktion einstellen - kommt bald!';

  @override
  String get tapThePlusButtonToAdd =>
      'Tippen Sie auf die + -Taste, um Ihr erstes Medikament hinzuzufügen';

  @override
  String get todaysMedications => "Heutige Medikamente";

  @override
  String takenOf(int taken, int total) => '$taken von $total eingenommen';

  @override
  String markedAsTaken(String medicationName) =>
      '✓ $medicationName als eingenommen markiert';

  @override
  String get allMedications => 'Alle Medikamente';

  @override
  String get deleteMedication => 'Medikament löschen?';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Sind Sie sicher, dass Sie dieses Medikament löschen möchten?';

  @override
  String get delete => 'Löschen';

  @override
  String get setReminder => 'Erinnerung einstellen';

  @override
  String get logDose => 'Dosis protokollieren';

  @override
  String get newMedication => 'Neues Medikament';

  @override
  String get add => 'Hinzufügen';

  @override
  String get pleaseSelectAFrequencyPattern =>
      'Bitte wählen Sie ein Frequenzmuster';

  @override
  String get pleaseSelectAtLeastOneDay =>
      'Bitte wählen Sie mindestens einen Tag aus';

  @override
  String get medicationSavedAddAnother =>
      'Medikament gespeichert! Fügen Sie ein weiteres hinzu.';

  @override
  String failedToSaveMedication(String error) =>
      'Fehler beim Speichern des Medikaments: $error';

  @override
  String get quantity => 'Menge';

  @override
  String get pleaseEnterTheQuantity => 'Bitte geben Sie die Menge ein';

  @override
  String get pleaseEnterAValidNumber =>
      'Bitte geben Sie eine gültige Nummer ein';

  @override
  String get useAdvancedFrequency => 'Erweiterte Häufigkeit verwenden';

  @override
  String get selectSpecificDaysAndPatterns =>
      'Spezifische Tage und Muster auswählen';

  @override
  String get useSimpleTextFrequency => 'Einfache Texthäufigkeit verwenden';

  @override
  String get frequencyPattern => 'Frequenzmuster';

  @override
  String get save => 'Speichern';

  @override
  String get saveAndAddMore => 'Speichern & mehr hinzufügen';

  @override
  String get onceDaily => 'Einmal täglich';

  @override
  String get twiceDaily => 'Zweimal täglich';

  @override
  String get threeTimesDaily => 'Dreimal täglich';

  @override
  String get asNeeded => 'Bei Bedarf';

  @override
  String get dosageLabel => 'Dosierung:';

  @override
  String get frequencyLabel => 'Häufigkeit:';

  @override
  String get quantityLabel => 'Menge:';

  @override
  String get addStock => 'Bestand hinzufügen';

  @override
  String addStockFor(String medicationName) =>
      'Bestand für $medicationName hinzufügen';

  @override
  String get saveStock => 'Bestand speichern';

  @override
  String get blueskySynchronization => 'BlueSky-Synchronisation';

  @override
  String get blueskyHandle => 'BlueSky-Handle';

  @override
  String get yourHandleBskySocial => 'dein.handle.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle =>
      'Bitte geben Sie Ihren BlueSky-Handle ein';

  @override
  String get personalDataServerPDSURL =>
      'URL des persönlichen Datenservers (PDS)';

  @override
  String get yourPdsExampleCom => 'https://dein-pds.beispiel.com';

  @override
  String get pleaseEnterYourPDSURL => 'Bitte geben Sie Ihre PDS-URL ein';

  @override
  String get pleaseEnterAValidURL => 'Bitte geben Sie eine gültige URL ein';

  @override
  String get enabling => 'Wird aktiviert...';

  @override
  String get enableBlueSkySync => 'BlueSky-Synchronisation aktivieren';

  @override
  String get disableSync => 'Synchronisierung deaktivieren';

  @override
  String get disableBlueSkySync => 'BlueSky-Synchronisation deaktivieren';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Dies deaktiviert die Synchronisierung mit BlueSky. Ihre Daten bleiben lokal gespeichert. Sind Sie sicher, dass Sie fortfahren möchten?';

  @override
  String get disable => 'Deaktivieren';

  @override
  String get blueskySyncDisabled => 'BlueSky-Synchronisation deaktiviert';

  @override
  String failedToDisableSync(String error) =>
      'Fehler beim Deaktivieren der Synchronisierung: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-Synchronisation erfolgreich aktiviert!';

  @override
  String failedToEnableSync(String error) =>
      'Fehler beim Aktivieren der Synchronisierung: $error';

  @override
  String get googleDriveBackup => 'Google Drive-Sicherung';

  @override
  String connectedAs(String userId) => 'Verbunden als: $userId';

  @override
  String get autoRestoreFromBackup =>
      'Automatische Wiederherstellung aus Backup';

  @override
  String get restoreNewerBackupOnStartup =>
      'Neueres Backup beim Start wiederherstellen';

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String get restoreNow => 'Jetzt wiederherstellen';

  @override
  String get disconnect => 'Trennen';

  @override
  String get backupSuccessful => 'Sicherung erfolgreich!';

  @override
  String backupFailed(String error) => 'Sicherung fehlgeschlagen: $error';

  @override
  String get restoreSuccessful =>
      'Wiederherstellung erfolgreich! Bitte starten Sie die App neu.';

  @override
  String get noBackupFound => 'Kein Backup gefunden.';

  @override
  String restoreFailed(String error) =>
      'Wiederherstellung fehlgeschlagen: $error';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get importData => 'Daten importieren';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get dataImportedSuccessfully => 'Daten erfolgreich importiert!';

  @override
  String failedToImportData(String error) =>
      'Fehler beim Importieren von Daten: $error';

  @override
  String get dataExportedSuccessfully => 'Daten erfolgreich exportiert!';

  @override
  String failedToExportData(String error) =>
      'Fehler beim Exportieren von Daten: $error';

  @override
  String get aboutBlueSkyIntegration => 'Über die BlueSky-Integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills verwendet das AT-Protokoll, um Ihre Medikamentendaten mit Ihrem persönlichen BlueSky-Konto zu synchronisieren. Dies ermöglicht Ihnen den Zugriff auf Ihre Medikamente von jedem Gerät aus, während Sie die volle Kontrolle über Ihre Daten behalten.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Ihre Medikamentendaten werden sicher auf Ihrem ausgewählten Personal Data Server (PDS) gespeichert und auf allen Ihren Geräten synchronisiert.';

  @override
  String get licenseAndLegal => 'Lizenz & Rechtliches';

  @override
  String get mitLicense =>
      'BluePills ist eine Open-Source-Software, die unter der MIT-Lizenz lizenziert ist.';

  @override
  String get medicalDisclaimer => 'Medizinischer Haftungsausschluss';

  @override
  String get medicalDisclaimerDescription =>
      'Diese Software dient nur zu Informationszwecken und ist nicht dazu bestimmt, professionelle medizinische Beratung, Diagnose oder Behandlung zu ersetzen. Konsultieren Sie immer medizinisches Fachpersonal bezüglich Ihrer Medikamente.';

  @override
  String get syncModeLocalOnlyDescription =>
      'Daten nur lokal auf diesem Gerät speichern';

  @override
  String get syncModeSyncEnabledDescription =>
      'Lokal speichern und mit BlueSky synchronisieren';

  @override
  String get syncModeSyncOnlyDescription =>
      'Nur auf BlueSky speichern (erfordert Internetverbindung)';

  // Low Stock & Dashboard
  @override
  String criticallyLowStock(int count) => '$count Medikament(e) haben einen kritisch niedrigen Bestand!';

  @override
  String get dismiss => 'SCHLIESSEN';

  @override
  String get takeAll => 'Alle einnehmen';

  @override
  String get noMedicationsScheduledForToday => 'Keine Medikamente für heute geplant.';

  // Adherence Screen
  @override
  String get medicationAdherence => 'Medikamentenadhärenz';

  @override
  String get noDataAvailable => 'Keine Daten verfügbar.';

  @override
  String get noMedicationLogsYet => 'Noch keine Medikamentenprotokolle.';

  @override
  String get adherenceStatistics => 'Adhärenzstatistik';

  @override
  String get last7Days => 'Letzte 7 Tage';

  @override
  String get last30Days => 'Letzte 30 Tage';

  // Frequency Selector & Patterns
  @override
  String get daily => 'Täglich';

  @override
  String get specificDays => 'Spezifische Tage';

  @override
  String get everyNDays => 'Alle N Tage';

  @override
  String get selectDays => 'Tage auswählen:';

  @override
  String get every => 'Alle';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String get timesPerDay => 'Mal pro Tag:';

  @override
  String timesDaily(int times) => times == 1 ? 'Einmal täglich' : '$times Mal täglich';

  @override
  String onDays(String days) => 'Am $days';

  @override
  String timesOnDays(int times, String days) => times == 1 ? 'Am $days' : '$times Mal am $days';

  @override
  String everyIntervalDays(int days) => days == 1 ? 'Jeden Tag' : 'Alle $days Tage';

  @override
  String get everyDay => 'Jeden Tag';
}
