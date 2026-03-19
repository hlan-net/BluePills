/// Finnish localization strings for the BluePills application.
///
/// This library provides Finnish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Finnish implementation of [AppLocalizations].
class AppLocalizationsFi extends AppLocalizations {
  const AppLocalizationsFi();

  @override
  String get appTitle => 'BluePills';

  @override
  String get dosageLabel => 'Annostus:';

  @override
  String get frequencyLabel => 'Taajuus:';

  @override
  String get quantityLabel => 'Määrä:';

  @override
  String daysOfSupply(int days) => '$days päivän annokset';

  @override
  String get addMedication => 'Lisää lääke';

  @override
  String get medicationName => 'Lääkkeen nimi';

  @override
  String get pleaseEnterMedicationName => 'Anna lääkkeen nimi';

  @override
  String get dosage => 'Annostus';

  @override
  String get pleaseEnterDosage => 'Anna annostus';

  @override
  String get saveMedication => 'Tallenna lääke';

  @override
  String get quantity => 'Määrä';

  @override
  String get pleaseEnterTheQuantity => 'Anna määrä';

  @override
  String get pleaseEnterAValidNumber => 'Anna kelvollinen luku';

  @override
  String get pleaseEnterFrequency => 'Anna taajuus';

  @override
  String get frequency => 'Taajuus';

  @override
  String get selectReminderTime => 'Valitse muistutusaika';

  @override
  String get save => 'Tallenna';

  @override
  String get saveAndAddMore => 'Tallenna ja lisää toinen';

  @override
  String get medicationSavedAddAnother =>
      'Lääke tallennettu. Lisätäänkö toinen?';

  @override
  String failedToSaveMedication(String error) =>
      'Lääkkeen tallennus epäonnistui: $error';

  @override
  String get myMedications => 'Omat lääkkeet';

  @override
  String get noMedicationsYet => 'Ei vielä lääkkeitä.';

  @override
  String get tapThePlusButtonToAdd =>
      'Napauta +-painiketta lisätäksesi lääkkeen.';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get english => 'Englanti';

  @override
  String get finnish => 'Suomi';

  @override
  String get swedish => 'Ruotsi';

  @override
  String get german => 'Saksa';

  @override
  String get spanish => 'Espanja';

  @override
  String get appLanguage => 'Sovelluksen kieli';

  @override
  String get deviceLanguage => 'Laitteen kieli';

  @override
  String get language => 'Kieli';

  @override
  String get theme => 'Teema';

  @override
  String get followSystem => 'Seuraa järjestelmää';

  @override
  String get light => 'Vaalea';

  @override
  String get dark => 'Tumma';

  @override
  String get deleteMedication => 'Poista lääke';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Haluatko varmasti poistaa tämän lääkkeen?';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get error => 'Virhe';

  @override
  String get add => 'Lisää';

  @override
  String markedAsTaken(String name) => '$name merkitty otetuksi';

  @override
  String noMedicationLeftInStock(String name) =>
      'Varastossa ei ole lääkettä $name';

  @override
  String get setReminderFeatureComingSoon =>
      'Muistutusominaisuus on tulossa pian';

  @override
  String get selectMedication => 'Valitse lääke';

  @override
  String get todaysMedications => 'Tämän päivän lääkkeet';

  @override
  String takenOf(int taken, int total) => 'Otettu $taken / $total';

  @override
  String get takeAll => 'Ota kaikki';

  @override
  String get noMedicationsScheduledForToday =>
      'Ei tälle päivälle ajastettuja lääkkeitä.';

  @override
  String get settings => 'Asetukset';

  @override
  String get about => 'Tietoja';

  @override
  String get version => 'Versio';

  @override
  String get privacyPolicy => 'Tietosuojaseloste';

  @override
  String get medicationLogs => 'Lääkeloki';

  @override
  String get noLogsYet => 'Ei vielä merkintöjä.';

  @override
  String get time => 'Aika';

  @override
  String get medicationAdherence => 'Lääkkeiden ottoaste';

  @override
  String get noDataAvailable => 'Ei tietoja saatavilla';

  @override
  String get noMedicationLogsYet => 'Ei vielä lokimerkintöjä';

  @override
  String get adherenceStatistics => 'Tilastot';

  @override
  String get last7Days => 'Viimeiset 7 päivää';

  @override
  String get last30Days => 'Viimeiset 30 päivää';

  @override
  String get overallAdherence => 'Kokonaisaste';

  @override
  String get dosesTaken => 'Otettu';

  @override
  String get dosesMissed => 'Väliin jäänyt';

  @override
  String get weeklyView => 'Viikkonäkymä';

  @override
  String get monthlyView => 'Kuukausinäkymä';

  @override
  String get daily => 'Päivittäin';

  @override
  String get specificDays => 'Tiettyinä päivinä';

  @override
  String get everyNDays => 'N päivän välein';

  @override
  String get selectDays => 'Valitse päivät';

  @override
  String get every => 'Joka';

  @override
  String get day => 'päivä';

  @override
  String get days => 'päivää';

  @override
  String get timesPerDay => 'kertaa päivässä';

  @override
  String timesDaily(int times) =>
      times == 1 ? 'Kerran päivässä' : '$times kertaa päivässä';

  @override
  String onDays(String days) => days;

  @override
  String timesOnDays(int times, String days) =>
      times == 1 ? days : '$times kertaa $days';

  @override
  String everyIntervalDays(int days) =>
      days == 1 ? 'Joka päivä' : 'Joka $days. päivä';

  @override
  String get everyDay => 'Joka päivä';

  @override
  String get synchronization => 'Synkronointi';

  @override
  String get blueskySynchronization => 'BlueSky-synkronointi';

  @override
  String get enableBlueSkySync => 'Ota käyttöön BlueSky-synkronointi';

  @override
  String get blueSkyHandle => 'BlueSky-tunnus';

  @override
  String get yourHandleBskySocial => 'tunnuksesi.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle => 'Anna BlueSky-tunnuksesi';

  @override
  String get personalDataServerPDSURL => 'Personal Data Server (PDS) URL';

  @override
  String get yourPdsExampleCom => 'pds.esimerkki.com';

  @override
  String get pleaseEnterYourPDSURL => 'Anna PDS URL';

  @override
  String get pleaseEnterAValidURL => 'Anna kelvollinen URL';

  @override
  String get enabling => 'Otetaan käyttöön...';

  @override
  String get appPassword => 'Sovellussalasana';

  @override
  String get disableSync => 'Poista synkronointi';

  @override
  String get disableBlueSkySync => 'Poista BlueSky-synkronointi';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Haluatko varmasti poistaa BlueSky-synkronoinnin käytöstä?';

  @override
  String get disable => 'Poista käytöstä';

  @override
  String get status => 'Tila';

  @override
  String get syncDisabled => 'Synkronointi pois käytöstä';

  @override
  String get loggedIn => 'Kirjautuneena';

  @override
  String get loggedOut => 'Kirjautuneena ulos';

  @override
  String get lastSyncedAt => 'Viimeksi synkronoitu';

  @override
  String get syncNow => 'Synkronoi nyt';

  @override
  String get login => 'Kirjaudu sisään';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get disconnect => 'Katkaise yhteys';

  @override
  String get confirmLogout => 'Vahvista uloskirjautuminen';

  @override
  String get areYouSureYouWantToLogoutFromBlueSky =>
      'Haluatko varmasti kirjautua ulos BlueSkysta?';

  @override
  String connectedAs(String name) => 'Kirjautuneena nimellä $name';

  @override
  String get dataManagement => 'Tietojen hallinta';

  @override
  String get googleDriveBackup => 'Google Drive -varmuuskopiointi';

  @override
  String get backupToGoogleDrive => 'Varmuuskopiointi Google Driveen';

  @override
  String get lastBackupAt => 'Viimeisin varmuuskopio';

  @override
  String get backupNow => 'Varmuuskopioi nyt';

  @override
  String get restoreNow => 'Palauta nyt';

  @override
  String get restoreNowButton => 'Palauta nyt';

  @override
  String get connectToGoogleDrive => 'Yhdistä Google Driveen';

  @override
  String get disconnectGoogleDrive => 'Katkaise yhteys Google Driveen';

  @override
  String get backupSuccessful => 'Varmuuskopiointi onnistui';

  @override
  String backupFailed(String error) => 'Varmuuskopiointi epäonnistui: $error';

  @override
  String get restoreFromGoogleDrive => 'Palauta Google Drivesta';

  @override
  String get restoreSuccessful => 'Palautus onnistui';

  @override
  String restoreFailed(String error) => 'Palautus epäonnistui: $error';

  @override
  String get autoRestoreFromBackup => 'Automaattinen palautus varmuuskopiosta';

  @override
  String get restoreNewerBackupOnStartup =>
      'Palauta uudempi varmuuskopio käynnistyksen yhteydessä';

  @override
  String get noBackupFound => 'Varmuuskopiota ei löytynyt';

  @override
  String get dataExportedTo => 'Tiedot viety kohteeseen';

  @override
  String failedToExportData(String error) =>
      'Tietojen vienti epäonnistui: $error';

  @override
  String get dataExportedSuccessfully => 'Tiedot viety onnistuneesti';

  @override
  String get dataImportedSuccessfully => 'Tiedot tuotu onnistuneesti';

  @override
  String failedToImportData(String error) =>
      'Tietojen tuonti epäonnistui: $error';

  @override
  String get exportData => 'Vie tiedot';

  @override
  String get importData => 'Tuo tiedot';

  @override
  String get aboutBlueSkyIntegration => 'Tietoja BlueSky-integraatiosta';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills käyttää BlueSky AT -protokollaa tietojen synkronointiin laitteiden välillä.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Tietosi tallennetaan turvallisesti omalle Personal Data Serverillesi (PDS).';

  @override
  String get licenseAndLegal => 'Lisenssit ja lakitiedot';

  @override
  String get mitLicense => 'MIT-lisenssi';

  @override
  String get medicalDisclaimer => 'Lääketieteellinen vastuuvapauslauseke';

  @override
  String get medicalDisclaimerDescription =>
      'Tämä sovellus on tarkoitettu vain tiedonhallintaan. Keskustele aina lääkärisi kanssa ennen lääkityksen muuttamista.';

  @override
  String get syncModeLocalOnlyDescription => 'Vain paikallinen tallennus';

  @override
  String get syncModeSyncEnabledDescription => 'Synkronointi käytössä';

  @override
  String get syncModeSyncOnlyDescription => 'Vain synkronointi';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String get testNotification => 'Testaa ilmoitusta';

  @override
  String get notificationSent => 'Testi-ilmoitus lähetetty';

  @override
  String get medicationReminders => 'Lääkemuistutukset';

  @override
  String get remindersToTakeYourMedication => 'Muistutukset lääkkeiden otosta';

  @override
  String get timeToTakeYour => 'Aika ottaa';

  @override
  String get editMedication => 'Muokkaa lääkettä';

  @override
  String get medicationDetails => 'Lääkkeen tiedot';

  @override
  String get addStock => 'Lisää varastoa';

  @override
  String get currentQuantity => 'Nykyinen määrä';

  @override
  String get quantityToAdd => 'Lisättävä määrä';

  @override
  String get confirmAddStock => 'Vahvista varaston lisäys';

  @override
  String get stockAddedSuccessfully => 'Varastoa lisätty onnistuneesti';

  @override
  String get saveStock => 'Tallenna varasto';

  @override
  String addStockFor(String medicationName) =>
      'Lisää varastoa: $medicationName';

  @override
  String get dailyMedications => 'Päivittäiset lääkkeet';

  @override
  String get allMedications => 'Kaikki lääkkeet';

  @override
  String get showLowStock => 'Näytä vähäinen varasto';

  @override
  String get showExpiringSoon => 'Näytä pian vanhentuvat';

  @override
  String get expirationDate => 'Viimeinen käyttöpäivä';

  @override
  String get expirationDateLabel => 'Viimeinen käyttöpäivä';

  @override
  String get expiresLabel => 'Vanhentuu:';

  @override
  String get selectExpirationDateOptional =>
      'Valitse viimeinen käyttöpäivä (valinnainen)';

  @override
  String get clearExpirationDate => 'Tyhjennä viimeinen käyttöpäivä';

  @override
  String get syncCompletedSuccessfully => 'Synkronointi onnistui';

  @override
  String syncFailed(String error) => 'Synkronointi epäonnistui: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-synkronointi otettu käyttöön';

  @override
  String failedToEnableSync(String error) =>
      'Synkronoinnin käyttöönotto epäonnistui: $error';

  @override
  String get blueskySyncDisabled => 'BlueSky-synkronointi poistettu käytöstä';

  @override
  String failedToDisableSync(String error) =>
      'Synkronoinnin poisto epäonnistui: $error';

  @override
  String criticallyLowStock(int count) => 'Erittäin vähäinen varasto ($count)';

  @override
  String get dismiss => 'Hylkää';

  @override
  String get setReminder => 'Aseta muistutus';

  @override
  String get logDose => 'Kirjaa annos';

  @override
  String get newMedication => 'Uusi lääke';

  @override
  String reminderSetFor(String name, String time) =>
      'Muistutus lääkkeelle $name asetettu kello $time';

  @override
  String loggedDoseFor(String name) => 'Annos kirjattu lääkkeelle $name';

  @override
  String get onceDaily => 'Kerran päivässä';

  @override
  String get twiceDaily => 'Kahdesti päivässä';

  @override
  String get threeTimesDaily => 'Kolmesti päivässä';

  @override
  String get asNeeded => 'Tarvittaessa';

  @override
  String get monday => 'Maanantai';

  @override
  String get tuesday => 'Tiistai';

  @override
  String get wednesday => 'Keskiviikko';

  @override
  String get thursday => 'Torstai';

  @override
  String get friday => 'Perjantai';

  @override
  String get saturday => 'Lauantai';

  @override
  String get sunday => 'Sunnuntai';

  @override
  String get mon => 'Ma';

  @override
  String get tue => 'Ti';

  @override
  String get wed => 'Ke';

  @override
  String get thu => 'To';

  @override
  String get fri => 'Pe';

  @override
  String get sat => 'La';

  @override
  String get sun => 'Su';

  @override
  String get timesPerDayLabel => 'kertaa päivässä';

  @override
  String get everyDayLabel => 'joka päivä';

  @override
  String get everyNDaysLabel => 'joka N. päivä';

  @override
  String get intervalDaysLabel => 'päivän välein';

  @override
  String get pleaseSelectAFrequencyPattern => 'Valitse taajuuskuvio';

  @override
  String get pleaseSelectAtLeastOneDay => 'Valitse vähintään yksi päivä';

  @override
  String get useAdvancedFrequency => 'Käytä edistynyttä taajuutta';

  @override
  String get selectSpecificDaysAndPatterns => 'Valitse tietyt päivät ja kuviot';

  @override
  String get useSimpleTextFrequency => 'Käytä yksinkertaista tekstitaajuutta';

  @override
  String get frequencyPattern => 'Taajuuskuvio';

  @override
  String get reminderTime => 'Muistutusaika';

  @override
  String get noMedicationsAvailable => 'Ei lääkkeitä saatavilla';

  @override
  String get storageLocation => 'Säilytyspaikka';

  @override
  String get storageLocationLabel => 'Säilytyspaikka';

  @override
  String get asNeededLabel => 'Tarvittaessa (PRN)';

  @override
  String get asNeededDescription => 'Ei kiinteää aikataulua';

  @override
  String get lastTaken => 'Viimeksi otettu';

  @override
  String lastTakenDaysAgo(int days) => days == 0
      ? 'Viimeksi otettu: Tänään'
      : 'Viimeksi otettu: $days päivää sitten';

  @override
  String get selectLocation => 'Valitse paikka';

  @override
  String get medicineCabinet => 'Lääkekaappi';

  @override
  String get bedroom => 'Makuuhuone';

  @override
  String get kitchen => 'Keittiö';

  @override
  String get car => 'Auto';

  @override
  String get office => 'Toimisto';

  @override
  String get purseBag => 'Laukku';
}
