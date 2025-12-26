/// Finnish localization strings for the BluePills application.
///
/// This library provides Finnish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Finnish implementation of [AppLocalizations].
///
/// Provides all localized strings in Finnish (Suomi) for the BluePills application.
class AppLocalizationsFi extends AppLocalizations {
  @override
  String get appTitle => 'SinisetPillerit';

  @override
  String get myMedications => 'Minun lääkkeeni';

  @override
  String get noMedicationsYet => 'Lääkkeitä ei ole vielä lisätty.';

  @override
  String get addMedication => 'Lisää lääke';

  @override
  String get editMedication => 'Muokkaa lääkettä';

  @override
  String get medicationName => 'Lääkkeen nimi';

  @override
  String get dosage => 'Annostus';

  @override
  String get frequency => 'Taajuus';

  @override
  String get reminderTime => 'Muistutusaika';

  @override
  String get saveMedication => 'Tallenna lääke';

  @override
  String get pleaseEnterMedicationName => 'Syötä lääkkeen nimi';

  @override
  String get pleaseEnterDosage => 'Syötä annostus';

  @override
  String get pleaseEnterFrequency => 'Syötä taajuus';

  @override
  String get error => 'Virhe';

  @override
  String get settings => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get appLanguage => 'Sovelluksen kieli';

  @override
  String get deviceLanguage => 'Laitteen kieli';

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
  String get noMedicationsAvailable =>
      'Lääkkeitä ei ole saatavilla. Lisää ensin lääke.';

  @override
  String get selectMedication => 'Valitse lääke';

  @override
  String get cancel => 'Peruuta';

  @override
  String loggedDoseFor(String medicationName) =>
      'Annos kirjattu lääkkeelle $medicationName';

  @override
  String noMedicationLeftInStock(String medicationName) =>
      '$medicationName on loppu varastosta';

  @override
  String get setReminderFeatureComingSoon =>
      'Aseta muistutus -ominaisuus - tulossa pian!';

  @override
  String get tapThePlusButtonToAdd =>
      'Napauta + -painiketta lisätäksesi ensimmäisen lääkkeesi';

  @override
  String get todaysMedications => "Tämän päivän lääkkeet";

  @override
  String takenOf(int taken, int total) => '$taken/$total otettu';

  @override
  String markedAsTaken(String medicationName) =>
      '✓ $medicationName merkitty otetuksi';

  @override
  String get allMedications => 'Kaikki lääkkeet';

  @override
  String get deleteMedication => 'Poista lääke?';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Haluatko varmasti poistaa tämän lääkkeen?';

  @override
  String get delete => 'Poista';

  @override
  String get setReminder => 'Aseta muistutus';

  @override
  String get logDose => 'Kirjaa annos';

  @override
  String get newMedication => 'Uusi lääke';

  @override
  String get add => 'Lisää';

  @override
  String get pleaseSelectAFrequencyPattern => 'Valitse toistokuvio';

  @override
  String get pleaseSelectAtLeastOneDay => 'Valitse vähintään yksi päivä';

  @override
  String get medicationSavedAddAnother => 'Lääke tallennettu! Lisää toinen.';

  @override
  String failedToSaveMedication(String error) =>
      'Lääkkeen tallentaminen epäonnistui: $error';

  @override
  String get quantity => 'Määrä';

  @override
  String get pleaseEnterTheQuantity => 'Syötä määrä';

  @override
  String get pleaseEnterAValidNumber => 'Syötä kelvollinen numero';

  @override
  String get useAdvancedFrequency => 'Käytä edistynyttä toistuvuutta';

  @override
  String get selectSpecificDaysAndPatterns => 'Valitse tietyt päivät ja kuviot';

  @override
  String get useSimpleTextFrequency =>
      'Käytä yksinkertaista tekstitoistuvuutta';

  @override
  String get frequencyPattern => 'Toistokuvio';

  @override
  String get save => 'Tallenna';

  @override
  String get saveAndAddMore => 'Tallenna ja lisää lisää';

  @override
  String get onceDaily => 'Kerran päivässä';

  @override
  String get twiceDaily => 'Kahdesti päivässä';

  @override
  String get threeTimesDaily => 'Kolmesti päivässä';

  @override
  String get asNeeded => 'Tarvittaessa';

  @override
  String get dosageLabel => 'Annostus:';

  @override
  String get frequencyLabel => 'Taajuus:';

  @override
  String get quantityLabel => 'Määrä:';

  @override
  String get addStock => 'Lisää varastoon';

  @override
  String addStockFor(String medicationName) =>
      'Lisää varastoon lääkettä $medicationName';

  @override
  String get saveStock => 'Tallenna varasto';

  @override
  String get blueskySynchronization => 'BlueSky-synkronointi';

  @override
  String get blueskyHandle => 'BlueSky-kahva';

  @override
  String get yourHandleBskySocial => 'sinun.kahva.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle => 'Anna BlueSky-kahvasi';

  @override
  String get personalDataServerPDSURL =>
      'Henkilökohtaisen datapalvelimen (PDS) URL-osoite';

  @override
  String get yourPdsExampleCom => 'https://sinun-pds.esimerkki.com';

  @override
  String get pleaseEnterYourPDSURL => 'Anna PDS-URL-osoitteesi';

  @override
  String get pleaseEnterAValidURL => 'Anna kelvollinen URL-osoite';

  @override
  String get enabling => 'Käytössä...';

  @override
  String get enableBlueSkySync => 'Ota BlueSky-synkronointi käyttöön';

  @override
  String get disableSync => 'Poista synkronointi käytöstä';

  @override
  String get disableBlueSkySync => 'Poista BlueSky-synkronointi käytöstä';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Tämä poistaa synkronoinnin BlueSkyn kanssa. Tietosi säilyvät paikallisesti. Haluatko varmasti jatkaa?';

  @override
  String get disable => 'Poista käytöstä';

  @override
  String get blueskySyncDisabled => 'BlueSky-synkronointi poistettu käytöstä';

  @override
  String failedToDisableSync(String error) =>
      'Synkronoinnin poistaminen käytöstä epäonnistui: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      'BlueSky-synkronointi otettu käyttöön onnistuneesti!';

  @override
  String failedToEnableSync(String error) =>
      'Synkronoinnin käyttöönotto epäonnistui: $error';

  @override
  String get googleDriveBackup => 'Google Drive -varmuuskopio';

  @override
  String connectedAs(String userId) => 'Yhdistetty nimellä: $userId';

  @override
  String get autoRestoreFromBackup => 'Automaattinen palautus varmuuskopiosta';

  @override
  String get restoreNewerBackupOnStartup =>
      'Palauta uudempi varmuuskopio käynnistyksen yhteydessä';

  @override
  String get backupNow => 'Varmuuskopioi nyt';

  @override
  String get restoreNow => 'Palauta nyt';

  @override
  String get disconnect => 'Katkaise yhteys';

  @override
  String get backupSuccessful => 'Varmuuskopiointi onnistui!';

  @override
  String backupFailed(String error) => 'Varmuuskopiointi epäonnistui: $error';

  @override
  String get restoreSuccessful =>
      'Palautus onnistui! Käynnistä sovellus uudelleen.';

  @override
  String get noBackupFound => 'Varmuuskopiota ei löytynyt.';

  @override
  String restoreFailed(String error) => 'Palautus epäonnistui: $error';

  @override
  String get dataManagement => 'Tietojen hallinta';

  @override
  String get importData => 'Tuo tiedot';

  @override
  String get exportData => 'Vie tiedot';

  @override
  String get dataImportedSuccessfully => 'Tiedot tuotu onnistuneesti!';

  @override
  String failedToImportData(String error) =>
      'Tietojen tuonti epäonnistui: $error';

  @override
  String get dataExportedSuccessfully => 'Tiedot viety onnistuneesti!';

  @override
  String failedToExportData(String error) =>
      'Tietojen vienti epäonnistui: $error';

  @override
  String get aboutBlueSkyIntegration => 'Tietoja BlueSky-integraatiosta';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills käyttää AT-protokollaa lääkitystietojesi synkronoimiseen henkilökohtaisen BlueSky-tilisi kanssa. Tämä antaa sinulle pääsyn lääkkeisiisi miltä tahansa laitteelta säilyttäen samalla täyden hallinnan tiedoistasi.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Lääkitystietosi tallennetaan turvallisesti valitsemallesi henkilökohtaiselle datapalvelimelle (PDS) ja synkronoidaan kaikkien laitteidesi välillä.';

  @override
  String get licenseAndLegal => 'Lisenssi ja lakiasiat';

  @override
  String get mitLicense =>
      'BluePills on avoimen lähdekoodin ohjelmisto, joka on lisensoitu MIT-lisenssillä.';

  @override
  String get medicalDisclaimer => 'Lääketieteellinen vastuuvapauslauseke';

  @override
  String get medicalDisclaimerDescription =>
      'Tämä ohjelmisto on tarkoitettu vain tiedoksi, eikä sitä ole tarkoitettu korvaamaan ammattimaista lääketieteellistä neuvontaa, diagnoosia tai hoitoa. Keskustele aina terveydenhuollon ammattilaisten kanssa lääkkeistäsi.';

  @override
  String get syncModeLocalOnlyDescription =>
      'Tallenna tiedot vain tähän laitteeseen paikallisesti';

  @override
  String get syncModeSyncEnabledDescription =>
      'Tallenna paikallisesti ja synkronoi BlueSkyn kanssa';

  @override
  String get syncModeSyncOnlyDescription =>
      'Tallenna vain BlueSkyyn (vaatii internetyhteyden)';

  // Low Stock & Dashboard
  @override
  String criticallyLowStock(int count) => '$count lääkettä on loppumassa!';

  @override
  String get dismiss => 'SULJE';

  @override
  String get takeAll => 'Ota kaikki';

  @override
  String get noMedicationsScheduledForToday => 'Ei lääkkeitä tälle päivälle.';

  // Adherence Screen
  @override
  String get medicationAdherence => 'Lääkityksen noudattaminen';

  @override
  String get noDataAvailable => 'Ei tietoja saatavilla.';

  @override
  String get noMedicationLogsYet => 'Ei lääkitysmerkintöjä vielä.';

  @override
  String get adherenceStatistics => 'Noudattamistilastot';

  @override
  String get last7Days => 'Viimeiset 7 päivää';

  @override
  String get last30Days => 'Viimeiset 30 päivää';

  // Frequency Selector & Patterns
  @override
  String get daily => 'Päivittäin';

  @override
  String get specificDays => 'Tietyt päivät';

  @override
  String get everyNDays => 'Joka N. päivä';

  @override
  String get selectDays => 'Valitse päivät:';

  @override
  String get every => 'Joka';

  @override
  String get day => 'päivä';

  @override
  String get days => 'päivää';

  @override
  String get timesPerDay => 'Kertaa päivässä:';

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
}
