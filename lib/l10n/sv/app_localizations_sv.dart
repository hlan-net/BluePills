/// Swedish localization strings for the BluePills application.
///
/// This library provides Swedish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Swedish implementation of [AppLocalizations].
///
/// Provides all localized strings in Swedish for the BluePills application.
class AppLocalizationsSv extends AppLocalizations {
  @override
  String get appTitle => 'BluePills';

  @override
  String get myMedications => 'Mina Mediciner';

  @override
  String get noMedicationsYet => 'Inga mediciner tillagda än.';

  @override
  String get addMedication => 'Lägg till Medicin';

  @override
  String get editMedication => 'Redigera Medicin';

  @override
  String get medicationName => 'Medicinens Namn';

  @override
  String get dosage => 'Dosering';

  @override
  String get frequency => 'Frekvens';

  @override
  String get reminderTime => 'Påminnelsetid';

  @override
  String get saveMedication => 'Spara Medicin';

  @override
  String get pleaseEnterMedicationName => 'Vänligen ange ett medicinskt namn';

  @override
  String get pleaseEnterDosage => 'Vänligen ange doseringen';

  @override
  String get pleaseEnterFrequency => 'Vänligen ange frekvensen';

  @override
  String get error => 'Fel';

  @override
  String get settings => 'Inställningar';

  @override
  String get language => 'Språk';

  @override
  String get appLanguage => 'Appens språk';

  @override
  String get deviceLanguage => 'Enhetens språk';

  @override
  String get english => 'Engelska';

  @override
  String get finnish => 'Finska';

  @override
  String get swedish => 'Svenska';

  @override
  String get german => 'Tyska';

  @override
  String get spanish => 'Spanska';

  @override
  String get noMedicationsAvailable =>
      'Inga mediciner tillgängliga. Lägg till en medicin först.';

  @override
  String get selectMedication => 'Välj medicin';

  @override
  String get cancel => 'Avbryt';

  @override
  String loggedDoseFor(String medicationName) =>
      'Dos loggad för $medicationName';

  @override
  String noMedicationLeftInStock(String medicationName) =>
      'Ingen $medicationName kvar i lager';

  @override
  String get setReminderFeatureComingSoon =>
      'Ställ in påminnelsefunktion - kommer snart!';

  @override
  String get tapThePlusButtonToAdd =>
      'Tryck på + -knappen för att lägga till din första medicin';

  @override
  String get todaysMedications => "Dagens mediciner";

  @override
  String takenOf(int taken, int total) => '$taken av $total tagna';

  @override
  String markedAsTaken(String medicationName) =>
      '✓ $medicationName markerad som tagen';

  @override
  String get allMedications => 'Alla mediciner';

  @override
  String get deleteMedication => 'Ta bort medicin?';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Är du säker på att du vill ta bort den här medicinen?';

  @override
  String get delete => 'Ta bort';

  @override
  String get setReminder => 'Ställ in påminnelse';

  @override
  String get logDose => 'Logga dos';

  @override
  String get newMedication => 'Ny medicin';

  @override
  String get add => 'Lägg till';

  @override
  String get pleaseSelectAFrequencyPattern =>
      'Vänligen välj ett frekvensmönster';

  @override
  String get pleaseSelectAtLeastOneDay => 'Vänligen välj minst en dag';

  @override
  String get medicationSavedAddAnother => 'Medicin sparad! Lägg till en till.';

  @override
  String failedToSaveMedication(String error) =>
      'Kunde inte spara medicin: $error';

  @override
  String get quantity => 'Kvantitet';

  @override
  String get pleaseEnterTheQuantity => 'Vänligen ange kvantiteten';

  @override
  String get pleaseEnterAValidNumber => 'Vänligen ange ett giltigt nummer';

  @override
  String get useAdvancedFrequency => 'Använd avancerad frekvens';

  @override
  String get selectSpecificDaysAndPatterns =>
      'Välj specifika dagar och mönster';

  @override
  String get useSimpleTextFrequency => 'Använd enkel textfrekvens';

  @override
  String get frequencyPattern => 'Frekvensmönster';

  @override
  String get save => 'Spara';

  @override
  String get saveAndAddMore => 'Spara & lägg till fler';

  @override
  String get onceDaily => 'En gång om dagen';

  @override
  String get twiceDaily => 'Två gånger om dagen';

  @override
  String get threeTimesDaily => 'Tre gånger om dagen';

  @override
  String get asNeeded => 'Vid behov';

  @override
  String get dosageLabel => 'Dosering:';

  @override
  String get frequencyLabel => 'Frekvens:';

  @override
  String get quantityLabel => 'Kvantitet:';

  @override
  String get addStock => 'Lägg till i lager';

  @override
  String addStockFor(String medicationName) =>
      'Lägg till i lager för $medicationName';

  @override
  String get saveStock => 'Spara lager';

  @override
  String get blueskySynchronization => 'BlueSky-synkronisering';

  @override
  String get blueskyHandle => 'BlueSky-handtag';

  @override
  String get yourHandleBskySocial => 'ditt.handtag.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle => 'Ange ditt BlueSky-handtag';

  @override
  String get personalDataServerPDSURL => 'Personlig dataserver (PDS) URL';

  @override
  String get yourPdsExampleCom => 'https://din-pds.exempel.com';

  @override
  String get pleaseEnterYourPDSURL => 'Ange din PDS-URL';

  @override
  String get pleaseEnterAValidURL => 'Ange en giltig URL';

  @override
  String get enabling => 'Aktiverar...';

  @override
  String get enableBlueSkySync => 'Aktivera BlueSky-synkronisering';

  @override
  String get disableSync => 'Inaktivera synkronisering';

  @override
  String get disableBlueSkySync => 'Inaktivera BlueSky-synkronisering';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Detta inaktiverar synkronisering med BlueSky. Dina data kommer att finnas kvar lokalt. Är du säker på att du vill fortsätta?';

  @override
  String get disable => 'Inaktivera';

  @override
  String get blueskySyncDisabled => 'BlueSky-synkronisering inaktiverad';

  @override
  String failedToDisableSync(String error) =>
      'Misslyckades med att inaktivera synkronisering: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-synkronisering har aktiverats!';

  @override
  String failedToEnableSync(String error) =>
      'Misslyckades med att aktivera synkronisering: $error';

  @override
  String get googleDriveBackup => 'Google Drive-säkerhetskopia';

  @override
  String connectedAs(String userId) => 'Ansluten som: $userId';

  @override
  String get autoRestoreFromBackup => 'Auto-återställ från säkerhetskopia';

  @override
  String get restoreNewerBackupOnStartup =>
      'Återställ nyare säkerhetskopia vid start';

  @override
  String get backupNow => 'Säkerhetskopiera nu';

  @override
  String get restoreNow => 'Återställ nu';

  @override
  String get disconnect => 'Koppla från';

  @override
  String get backupSuccessful => 'Säkerhetskopiering lyckades!';

  @override
  String backupFailed(String error) =>
      'Säkerhetskopiering misslyckades: $error';

  @override
  String get restoreSuccessful => 'Återställning lyckades! Starta om appen.';

  @override
  String get noBackupFound => 'Ingen säkerhetskopia hittades.';

  @override
  String restoreFailed(String error) => 'Återställning misslyckades: $error';

  @override
  String get dataManagement => 'Datahantering';

  @override
  String get importData => 'Importera data';

  @override
  String get exportData => 'Exportera data';

  @override
  String get dataImportedSuccessfully => 'Data importerades framgångsrikt!';

  @override
  String failedToImportData(String error) =>
      'Misslyckades med att importera data: $error';

  @override
  String get dataExportedSuccessfully => 'Data exporterades framgångsrikt!';

  @override
  String failedToExportData(String error) =>
      'Misslyckades med att exportera data: $error';

  @override
  String get aboutBlueSkyIntegration => 'Om BlueSky-integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills använder AT-protokollet för att synkronisera dina medicindata med ditt personliga BlueSky-konto. Detta ger dig tillgång till dina mediciner från vilken enhet som helst samtidigt som du behåller full kontroll över dina data.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Dina medicindata lagras säkert på din valda personliga dataserver (PDS) och synkroniseras över alla dina enheter.';

  @override
  String get licenseAndLegal => 'Licens och juridiskt';

  @override
  String get mitLicense =>
      'BluePills är öppen källkodsprogramvara licensierad under MIT-licensen.';

  @override
  String get medicalDisclaimer => 'Medicinsk ansvarsfriskrivning';

  @override
  String get medicalDisclaimerDescription =>
      'Denna programvara är endast avsedd för informationsändamål och är inte avsedd att ersätta professionell medicinsk rådgivning, diagnos eller behandling. Rådgör alltid med sjukvårdspersonal angående dina mediciner.';

  @override
  String get syncModeLocalOnlyDescription =>
      'Lagra data endast lokalt på denna enhet';

  @override
  String get syncModeSyncEnabledDescription =>
      'Lagra lokalt och synkronisera med BlueSky';

  @override
  String get syncModeSyncOnlyDescription =>
      'Lagra endast på BlueSky (kräver internetanslutning)';

  // Low Stock & Dashboard
  @override
  String criticallyLowStock(int count) => '$count mediciner har kritiskt lågt lager!';

  @override
  String get dismiss => 'AVFÄRDA';

  @override
  String get takeAll => 'Ta alla';

  @override
  String get noMedicationsScheduledForToday => 'Inga mediciner schemalagda för idag.';

  // Adherence Screen
  @override
  String get medicationAdherence => 'Medicinföljsamhet';

  @override
  String get noDataAvailable => 'Inga data tillgängliga.';

  @override
  String get noMedicationLogsYet => 'Inga medicinloggar än.';

  @override
  String get adherenceStatistics => 'Följsamhetsstatistik';

  @override
  String get last7Days => 'Senaste 7 dagarna';

  @override
  String get last30Days => 'Senaste 30 dagarna';

  // Frequency Selector & Patterns
  @override
  String get daily => 'Dagligen';

  @override
  String get specificDays => 'Specifika dagar';

  @override
  String get everyNDays => 'Var N:e dag';

  @override
  String get selectDays => 'Välj dagar:';

  @override
  String get every => 'Varje';

  @override
  String get day => 'dag';

  @override
  String get days => 'dagar';

  @override
  String get timesPerDay => 'Gånger per dag:';

  @override
  String timesDaily(int times) => times == 1 ? 'En gång dagligen' : '$times gånger dagligen';

  @override
  String onDays(String days) => 'På $days';

  @override
  String timesOnDays(int times, String days) => times == 1 ? 'På $days' : '$times gånger på $days';

  @override
  String everyIntervalDays(int days) => days == 1 ? 'Varje dag' : 'Var $days:e dag';

  @override
  String get everyDay => 'Varje dag';
}
