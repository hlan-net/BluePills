/// Swedish localization strings for the BluePills application.
///
/// This library provides Swedish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Swedish implementation of [AppLocalizations].
class AppLocalizationsSv extends AppLocalizations {
  const AppLocalizationsSv();

  @override
  String get appTitle => 'BluePills';

  @override
  String get dosageLabel => 'Dosering:';

  @override
  String get frequencyLabel => 'Frekvens:';

  @override
  String get quantityLabel => 'Antal:';

  @override
  String daysOfSupply(int days) => '$days dagars lager';

  @override
  String get addMedication => 'Lägg till medicin';

  @override
  String get medicationName => 'Medicinens namn';

  @override
  String get pleaseEnterMedicationName => 'Vänligen fyll i medicinens namn';

  @override
  String get dosage => 'Dosering';

  @override
  String get pleaseEnterDosage => 'Vänligen fyll i dosering';

  @override
  String get saveMedication => 'Spara medicin';

  @override
  String get quantity => 'Antal';

  @override
  String get pleaseEnterTheQuantity => 'Vänligen fyll i antal';

  @override
  String get pleaseEnterAValidNumber => 'Vänligen fyll i ett giltigt nummer';

  @override
  String get pleaseEnterFrequency => 'Vänligen fyll i frekvens';

  @override
  String get frequency => 'Frekvens';

  @override
  String get selectReminderTime => 'Välj påminnelsetid';

  @override
  String get save => 'Spara';

  @override
  String get saveAndAddMore => 'Spara och lägg till fler';

  @override
  String get medicationSavedAddAnother =>
      'Medicinen sparad. Lägg till en till?';

  @override
  String failedToSaveMedication(String error) =>
      'Det gick inte att spara medicinen: $error';

  @override
  String get myMedications => 'Mina mediciner';

  @override
  String get noMedicationsYet => 'Inga mediciner tillagda ännu.';

  @override
  String get tapThePlusButtonToAdd =>
      'Tryck på +-knappen för att lägga till en.';

  @override
  String get selectLanguage => 'Välj språk';

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
  String get appLanguage => 'Appens språk';

  @override
  String get deviceLanguage => 'Enhetens språk';

  @override
  String get language => 'Språk';

  @override
  String get theme => 'Tema';

  @override
  String get followSystem => 'Följ systemet';

  @override
  String get light => 'Ljust';

  @override
  String get dark => 'Mörkt';

  @override
  String get deleteMedication => 'Ta bort medicin';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Är du säker på att du vill ta bort den här medicinen?';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Ta bort';

  @override
  String get error => 'Fel';

  @override
  String get add => 'Lägg till';

  @override
  String markedAsTaken(String name) => '$name markerad som tagen';

  @override
  String noMedicationLeftInStock(String name) => 'Slut på $name i lager';

  @override
  String get setReminderFeatureComingSoon => 'Påminnelsefunktion kommer snart';

  @override
  String get selectMedication => 'Välj medicin';

  @override
  String get todaysMedications => 'Dagens mediciner';

  @override
  String takenOf(int taken, int total) => 'Tagit $taken av $total';

  @override
  String get takeAll => 'Ta alla';

  @override
  String get noMedicationsScheduledForToday =>
      'Inga mediciner inplanerade för idag.';

  @override
  String get settings => 'Inställningar';

  @override
  String get about => 'Om';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get medicationLogs => 'Medicinloggar';

  @override
  String get noLogsYet => 'Inga loggar ännu.';

  @override
  String get time => 'Tid';

  @override
  String get medicationAdherence => 'Efterlevnad';

  @override
  String get noDataAvailable => 'Ingen data tillgänglig';

  @override
  String get noMedicationLogsYet => 'Inga medicinloggar ännu';

  @override
  String get adherenceStatistics => 'Statistik';

  @override
  String get last7Days => 'Senaste 7 dagarna';

  @override
  String get last30Days => 'Senaste 30 dagarna';

  @override
  String get overallAdherence => 'Total efterlevnad';

  @override
  String get dosesTaken => 'Tagna doser';

  @override
  String get dosesMissed => 'Missade doser';

  @override
  String get weeklyView => 'Veckovy';

  @override
  String get monthlyView => 'Månadsvy';

  @override
  String get daily => 'Dagligen';

  @override
  String get specificDays => 'Specifika dagar';

  @override
  String get everyNDays => 'Var N:e dag';

  @override
  String get selectDays => 'Välj dagar';

  @override
  String get every => 'Varje';

  @override
  String get day => 'dag';

  @override
  String get days => 'dagar';

  @override
  String get timesPerDay => 'gånger om dagen';

  @override
  String timesDaily(int times) =>
      times == 1 ? 'En gång dagligen' : '$times gånger om dagen';

  @override
  String onDays(String days) => 'På $days';

  @override
  String timesOnDays(int times, String days) =>
      times == 1 ? 'På $days' : '$times gånger på $days';

  @override
  String everyIntervalDays(int days) =>
      days == 1 ? 'Varje dag' : 'Var $days:e dag';

  @override
  String get everyDay => 'Varje dag';

  @override
  String get synchronization => 'Synkronisering';

  @override
  String get blueskySynchronization => 'BlueSky-synkronisering';

  @override
  String get enableBlueSkySync => 'Aktivera BlueSky-synkronisering';

  @override
  String get blueSkyHandle => 'BlueSky-användarnamn';

  @override
  String get yourHandleBskySocial => 'dittnamn.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle =>
      'Vänligen fyll i ditt BlueSky-användarnamn';

  @override
  String get personalDataServerPDSURL => 'Personal Data Server (PDS) URL';

  @override
  String get yourPdsExampleCom => 'pds.exempel.com';

  @override
  String get pleaseEnterYourPDSURL => 'Vänligen fyll i PDS-URL';

  @override
  String get pleaseEnterAValidURL => 'Vänligen fyll i en giltig URL';

  @override
  String get enabling => 'Aktiverar...';

  @override
  String get appPassword => 'App-lösenord';

  @override
  String get disableSync => 'Inaktivera synkronisering';

  @override
  String get disableBlueSkySync => 'Inaktivera BlueSky-synkronisering';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Är du säker på att du vill inaktivera BlueSky-synkronisering?';

  @override
  String get disable => 'Inaktivera';

  @override
  String get status => 'Status';

  @override
  String get syncDisabled => 'Synkronisering inaktiverad';

  @override
  String get loggedIn => 'Inloggad';

  @override
  String get loggedOut => 'Utloggad';

  @override
  String get lastSyncedAt => 'Senast synkroniserad';

  @override
  String get syncNow => 'Synkronisera nu';

  @override
  String get login => 'Logga in';

  @override
  String get logout => 'Logga ut';

  @override
  String get disconnect => 'Koppla från';

  @override
  String get confirmLogout => 'Bekräfta utloggning';

  @override
  String get areYouSureYouWantToLogoutFromBlueSky =>
      'Är du säker på att du vill logga ut från BlueSky?';

  @override
  String connectedAs(String name) => 'Ansluten som $name';

  @override
  String get dataManagement => 'Datahantering';

  @override
  String get googleDriveBackup => 'Google Drive-säkerhetskopiering';

  @override
  String get backupToGoogleDrive => 'Säkerhetskopiera till Google Drive';

  @override
  String get lastBackupAt => 'Senaste säkerhetskopiering';

  @override
  String get backupNow => 'Säkerhetskopiera nu';

  @override
  String get restoreNow => 'Återställ nu';

  @override
  String get restoreNowButton => 'Återställ nu';

  @override
  String get connectToGoogleDrive => 'Anslut till Google Drive';

  @override
  String get disconnectGoogleDrive => 'Koppla från Google Drive';

  @override
  String get backupSuccessful => 'Säkerhetskopieringen lyckades';

  @override
  String backupFailed(String error) =>
      'Säkerhetskopieringen misslyckades: $error';

  @override
  String get restoreFromGoogleDrive => 'Återställ från Google Drive';

  @override
  String get restoreSuccessful => 'Återställningen lyckades';

  @override
  String restoreFailed(String error) => 'Återställningen misslyckades: $error';

  @override
  String get autoRestoreFromBackup =>
      'Automatisk återställning från säkerhetskopia';

  @override
  String get restoreNewerBackupOnStartup =>
      'Återställ nyare säkerhetskopia vid start';

  @override
  String get noBackupFound => 'Ingen säkerhetskopia hittades';

  @override
  String get dataExportedTo => 'Data exporterad till';

  @override
  String failedToExportData(String error) =>
      'Dataexporten misslyckades: $error';

  @override
  String get dataExportedSuccessfully => 'Data exporterad framgångsrikt';

  @override
  String get dataImportedSuccessfully => 'Data importerad framgångsrikt';

  @override
  String failedToImportData(String error) =>
      'Dataimporten misslyckades: $error';

  @override
  String get exportData => 'Exportera data';

  @override
  String get importData => 'Importera data';

  @override
  String get aboutBlueSkyIntegration => 'Om BlueSky-integration';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills använder BlueSky AT-protokollet för att synkronisera din data mellan enheter.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Din data lagras säkert på din egen Personal Data Server (PDS).';

  @override
  String get licenseAndLegal => 'Licenser & laglig information';

  @override
  String get mitLicense => 'MIT-licens';

  @override
  String get medicalDisclaimer => 'Medicinsk ansvarsfriskrivning';

  @override
  String get medicalDisclaimerDescription =>
      'Denna app är endast för informationshantering. Rådfråga alltid din läkare innan du ändrar medicinering.';

  @override
  String get syncModeLocalOnlyDescription => 'Endast lokal lagring';

  @override
  String get syncModeSyncEnabledDescription => 'Synkronisering aktiverad';

  @override
  String get syncModeSyncOnlyDescription => 'Endast synkronisering';

  @override
  String get notifications => 'Aviseringar';

  @override
  String get testNotification => 'Testa avisering';

  @override
  String get notificationSent => 'Testavisering skickad';

  @override
  String get medicationReminders => 'Medicin-påminnelser';

  @override
  String get remindersToTakeYourMedication =>
      'Påminnelser om att ta din medicin';

  @override
  String get timeToTakeYour => 'Dags att ta din';

  @override
  String get editMedication => 'Redigera medicin';

  @override
  String get medicationDetails => 'Medicindetaljer';

  @override
  String get addStock => 'Fyll på lager';

  @override
  String get currentQuantity => 'Nuvarande antal';

  @override
  String get quantityToAdd => 'Antal att lägga till';

  @override
  String get confirmAddStock => 'Bekräfta påfyllning';

  @override
  String get stockAddedSuccessfully => 'Lager påfyllt framgångsrikt';

  @override
  String get saveStock => 'Spara lager';

  @override
  String addStockFor(String medicationName) =>
      'Fyll på lager för: $medicationName';

  @override
  String get dailyMedications => 'Dagliga mediciner';

  @override
  String get allMedications => 'Alla mediciner';

  @override
  String get showLowStock => 'Visa lågt lager';

  @override
  String get showExpiringSoon => 'Visa går ut snart';

  @override
  String get expirationDate => 'Utgångsdatum';

  @override
  String get expirationDateLabel => 'Utgångsdatum';

  @override
  String get expiresLabel => 'Går ut:';

  @override
  String get selectExpirationDateOptional => 'Välj utgångsdatum (valfritt)';

  @override
  String get clearExpirationDate => 'Rensa utgångsdatum';

  @override
  String get syncCompletedSuccessfully => 'Synkroniseringen lyckades';

  @override
  String syncFailed(String error) => 'Synkroniseringen misslyckades: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-synkronisering aktiverad';

  @override
  String failedToEnableSync(String error) =>
      'Det gick inte att aktivera synkronisering: $error';

  @override
  String get blueskySyncDisabled => 'BlueSky-synkronisering inaktiverad';

  @override
  String failedToDisableSync(String error) =>
      'Det gick inte att inaktivera synkronisering: $error';

  @override
  String criticallyLowStock(int count) => 'Kritiskt lågt lager ($count)';

  @override
  String get dismiss => 'Avfärda';

  @override
  String get setReminder => 'Ställ in påminnelse';

  @override
  String get logDose => 'Logga dos';

  @override
  String get newMedication => 'Ny medicin';

  @override
  String reminderSetFor(String name, String time) =>
      'Påminnelse för $name inställd på $time';

  @override
  String loggedDoseFor(String name) => 'Dos av $name loggad';

  @override
  String get onceDaily => 'En gång dagligen';

  @override
  String get twiceDaily => 'Två gånger dagligen';

  @override
  String get threeTimesDaily => 'Tre gånger dagligen';

  @override
  String get asNeeded => 'Vid behov';

  @override
  String get monday => 'Måndag';

  @override
  String get tuesday => 'Tisdag';

  @override
  String get wednesday => 'Onsdag';

  @override
  String get thursday => 'Torsdag';

  @override
  String get friday => 'Fredag';

  @override
  String get saturday => 'Lördag';

  @override
  String get sunday => 'Söndag';

  @override
  String get mon => 'Mån';

  @override
  String get tue => 'Tis';

  @override
  String get wed => 'Ons';

  @override
  String get thu => 'Tor';

  @override
  String get fri => 'Fre';

  @override
  String get sat => 'Lör';

  @override
  String get sun => 'Sön';

  @override
  String get timesPerDayLabel => 'gånger per dag';

  @override
  String get everyDayLabel => 'varje dag';

  @override
  String get everyNDaysLabel => 'var N:e dag';

  @override
  String get intervalDaysLabel => 'dagars intervall';

  @override
  String get pleaseSelectAFrequencyPattern =>
      'Vänligen välj ett frekvensmönster';

  @override
  String get pleaseSelectAtLeastOneDay => 'Vänligen välj minst en dag';

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
  String get reminderTime => 'Påminnelsetid';

  @override
  String get noMedicationsAvailable => 'Inga mediciner tillgängliga';

  @override
  String get storageLocation => 'Förvaringsplats';

  @override
  String get storageLocationLabel => 'Förvaringsplats';

  @override
  String get asNeededLabel => 'Vid behov (PRN)';

  @override
  String get asNeededDescription => 'Inget fast schema';

  @override
  String get lastTaken => 'Senast tagen';

  @override
  String lastTakenDaysAgo(int days) =>
      days == 0 ? 'Senast tagen: Idag' : 'Senast tagen: för $days dagar sedan';

  @override
  String get selectLocation => 'Välj plats';

  @override
  String get medicineCabinet => 'Medicinskåp';

  @override
  String get bedroom => 'Sovrum';

  @override
  String get kitchen => 'Kök';

  @override
  String get car => 'Bil';

  @override
  String get office => 'Kontor';

  @override
  String get purseBag => 'Väska';
}
