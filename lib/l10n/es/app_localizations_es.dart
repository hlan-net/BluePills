/// Spanish localization strings for the BluePills application.
///
/// This library provides Spanish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Spanish implementation of [AppLocalizations].
///
/// Provides all localized strings in Spanish for the BluePills application.
class AppLocalizationsEs extends AppLocalizations {
  @override
  String get appTitle => 'BluePills';

  @override
  String get myMedications => 'Mis Medicamentos';

  @override
  String get noMedicationsYet => 'Aún no se han añadido medicamentos.';

  @override
  String get addMedication => 'Añadir Medicamento';

  @override
  String get editMedication => 'Editar Medicamento';

  @override
  String get medicationName => 'Nombre del Medicamento';

  @override
  String get dosage => 'Dosis';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get reminderTime => 'Hora de Recordatorio';

  @override
  String get saveMedication => 'Guardar Medicamento';

  @override
  String get pleaseEnterMedicationName =>
      'Por favor, introduzca un nombre de medicamento';

  @override
  String get pleaseEnterDosage => 'Por favor, introduzca la dosis';

  @override
  String get pleaseEnterFrequency => 'Por favor, introduzca la frecuencia';

  @override
  String get error => 'Error';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get deviceLanguage => 'Idioma del dispositivo';

  @override
  String get english => 'Inglés';

  @override
  String get finnish => 'Finlandés';

  @override
  String get swedish => 'Sueco';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get noMedicationsAvailable =>
      'No hay medicamentos disponibles. Agregue un medicamento primero.';

  @override
  String get selectMedication => 'Seleccionar medicamento';

  @override
  String get cancel => 'Cancelar';

  @override
  String loggedDoseFor(String medicationName) =>
      'Dosis registrada para $medicationName';

  @override
  String noMedicationLeftInStock(String medicationName) =>
      'No queda $medicationName en stock';

  @override
  String get setReminderFeatureComingSoon =>
      'Función de recordatorio - ¡próximamente!';

  @override
  String get tapThePlusButtonToAdd =>
      'Toca el botón + para agregar tu primer medicamento';

  @override
  String get todaysMedications => "Medicamentos de hoy";

  @override
  String takenOf(int taken, int total) => '$taken de $total tomados';

  @override
  String markedAsTaken(String medicationName) =>
      '✓ $medicationName marcado como tomado';

  @override
  String get allMedications => 'Todos los medicamentos';

  @override
  String get deleteMedication => '¿Eliminar medicamento?';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      '¿Estás seguro de que quieres eliminar este medicamento?';

  @override
  String get delete => 'Eliminar';

  @override
  String get setReminder => 'Establecer recordatorio';

  @override
  String get logDose => 'Registrar dosis';

  @override
  String get newMedication => 'Nuevo medicamento';

  @override
  String get add => 'Añadir';

  @override
  String get pleaseSelectAFrequencyPattern =>
      'Por favor, seleccione un patrón de frecuencia';

  @override
  String get pleaseSelectAtLeastOneDay =>
      'Por favor, seleccione al menos un día';

  @override
  String get medicationSavedAddAnother => '¡Medicamento guardado! Añadir otro.';

  @override
  String failedToSaveMedication(String error) =>
      'Error al guardar el medicamento: $error';

  @override
  String get quantity => 'Cantidad';

  @override
  String get pleaseEnterTheQuantity => 'Por favor, introduzca la cantidad';

  @override
  String get pleaseEnterAValidNumber =>
      'Por favor, introduzca un número válido';

  @override
  String get useAdvancedFrequency => 'Usar frecuencia avanzada';

  @override
  String get selectSpecificDaysAndPatterns =>
      'Seleccionar días y patrones específicos';

  @override
  String get useSimpleTextFrequency => 'Usar frecuencia de texto simple';

  @override
  String get frequencyPattern => 'Patrón de frecuencia';

  @override
  String get save => 'Guardar';

  @override
  String get saveAndAddMore => 'Guardar y añadir más';

  @override
  String get onceDaily => 'Una vez al día';

  @override
  String get twiceDaily => 'Dos veces al día';

  @override
  String get threeTimesDaily => 'Tres veces al día';

  @override
  String get asNeeded => 'Según sea necesario';

  @override
  String get dosageLabel => 'Dosis:';

  @override
  String get frequencyLabel => 'Frecuencia:';

  @override
  String get quantityLabel => 'Cantidad:';

  @override
  String get addStock => 'Añadir existencias';

  @override
  String addStockFor(String medicationName) =>
      'Añadir existencias para $medicationName';

  @override
  String get saveStock => 'Guardar existencias';

  @override
  String get blueskySynchronization => 'Sincronización de BlueSky';

  @override
  String get blueskyHandle => 'Usuario de BlueSky';

  @override
  String get yourHandleBskySocial => 'tu.usuario.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle =>
      'Por favor, introduzca su usuario de BlueSky';

  @override
  String get personalDataServerPDSURL =>
      'URL del servidor de datos personales (PDS)';

  @override
  String get yourPdsExampleCom => 'https://tu-pds.ejemplo.com';

  @override
  String get pleaseEnterYourPDSURL => 'Por favor, introduzca la URL de su PDS';

  @override
  String get pleaseEnterAValidURL => 'Por favor, introduzca una URL válida';

  @override
  String get enabling => 'Habilitando...';

  @override
  String get enableBlueSkySync => 'Habilitar sincronización de BlueSky';

  @override
  String get disableSync => 'Deshabilitar sincronización';

  @override
  String get disableBlueSkySync => 'Deshabilitar sincronización de BlueSky';

  @override
  String get disableBlueSkySyncConfirmation =>
      'Esto deshabilitará la sincronización con BlueSky. Sus datos permanecerán almacenados localmente. ¿Está seguro de que desea continuar?';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get blueskySyncDisabled => 'Sincronización de BlueSky deshabilitada';

  @override
  String failedToDisableSync(String error) =>
      'Error al deshabilitar la sincronización: $error';

  @override
  String get blueskySyncEnabledSuccessfully =>
      '¡Sincronización de BlueSky habilitada con éxito!';

  @override
  String failedToEnableSync(String error) =>
      'Error al habilitar la sincronización: $error';

  @override
  String get googleDriveBackup => 'Copia de seguridad de Google Drive';

  @override
  String connectedAs(String userId) => 'Conectado como: $userId';

  @override
  String get autoRestoreFromBackup =>
      'Restauración automática desde la copia de seguridad';

  @override
  String get restoreNewerBackupOnStartup =>
      'Restaurar copia de seguridad más reciente al iniciar';

  @override
  String get backupNow => 'Hacer copia de seguridad ahora';

  @override
  String get restoreNow => 'Restaurar ahora';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get backupSuccessful => '¡Copia de seguridad exitosa!';

  @override
  String backupFailed(String error) => 'Error en la copia de seguridad: $error';

  @override
  String get restoreSuccessful =>
      '¡Restauración exitosa! Por favor, reinicie la aplicación.';

  @override
  String get noBackupFound => 'No se encontró ninguna copia de seguridad.';

  @override
  String restoreFailed(String error) => 'Error en la restauración: $error';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get importData => 'Importar datos';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get dataImportedSuccessfully => '¡Datos importados con éxito!';

  @override
  String failedToImportData(String error) => 'Error al importar datos: $error';

  @override
  String get dataExportedSuccessfully => '¡Datos exportados con éxito!';

  @override
  String failedToExportData(String error) => 'Error al exportar datos: $error';

  @override
  String get aboutBlueSkyIntegration => 'Acerca de la integración de BlueSky';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills utiliza el protocolo AT para sincronizar los datos de sus medicamentos con su cuenta personal de BlueSky. Esto le permite acceder a sus medicamentos desde cualquier dispositivo mientras mantiene el control total sobre sus datos.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Los datos de sus medicamentos se almacenarán de forma segura en su Servidor de datos personales (PDS) elegido y se sincronizarán en todos sus dispositivos.';

  @override
  String get licenseAndLegal => 'Licencia y legal';

  @override
  String get mitLicense =>
      'BluePills es un software de código abierto con licencia MIT.';

  @override
  String get medicalDisclaimer => 'Descargo de responsabilidad médica';

  @override
  String get medicalDisclaimerDescription =>
      'Este software es solo para fines informativos y no pretende reemplazar el consejo, diagnóstico o tratamiento médico profesional. Siempre consulte a profesionales de la salud con respecto a sus medicamentos.';

  @override
  String get syncModeLocalOnlyDescription =>
      'Almacenar datos solo localmente en este dispositivo';

  @override
  String get syncModeSyncEnabledDescription =>
      'Almacenar localmente y sincronizar con BlueSky';

  @override
  String get syncModeSyncOnlyDescription =>
      'Almacenar solo en BlueSky (requiere conexión a internet)';
}
