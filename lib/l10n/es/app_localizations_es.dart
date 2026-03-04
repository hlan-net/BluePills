/// Spanish localization strings for the BluePills application.
///
/// This library provides Spanish translations for all user-facing text
/// in the application.
library;

import '../app_localizations.dart';

/// Spanish implementation of [AppLocalizations].
class AppLocalizationsEs extends AppLocalizations {
  const AppLocalizationsEs();

  @override
  String get appTitle => 'BluePills';

  @override
  String get dosageLabel => 'Dosis:';

  @override
  String get frequencyLabel => 'Frecuencia:';

  @override
  String get quantityLabel => 'Cantidad:';

  @override
  String daysOfSupply(int days) => '$days días de suministro';

  @override
  String get addMedication => 'Añadir medicamento';

  @override
  String get medicationName => 'Nombre del medicamento';

  @override
  String get pleaseEnterMedicationName =>
      'Por favor, introduce el nombre del medicamento';

  @override
  String get dosage => 'Dosis';

  @override
  String get pleaseEnterDosage => 'Por favor, introduce la dosis';

  @override
  String get saveMedication => 'Guardar medicamento';

  @override
  String get quantity => 'Cantidad';

  @override
  String get pleaseEnterTheQuantity => 'Por favor, introduzca la cantidad';

  @override
  String get pleaseEnterAValidNumber => 'Por favor, introduzca un número válido';

  @override
  String get pleaseEnterFrequency => 'Por favor, introduzca la frecuencia';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get selectReminderTime => 'Seleccionar hora de recordatorio';

  @override
  String get save => 'Guardar';

  @override
  String get saveAndAddMore => 'Guardar y añadir otro';

  @override
  String get medicationSavedAddAnother => 'Medicamento guardado. ¿Añadir otro?';

  @override
  String failedToSaveMedication(String error) =>
      'Error al guardar el medicamento: $error';

  @override
  String get myMedications => 'Mis medicamentos';

  @override
  String get noMedicationsYet => 'No hay medicamentos todavía.';

  @override
  String get tapThePlusButtonToAdd => 'Toca el botón + para añadir uno.';

  @override
  String get selectLanguage => 'Seleccionar idioma';

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
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get deviceLanguage => 'Idioma del dispositivo';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get followSystem => 'Seguir sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get deleteMedication => 'Eliminar medicamento';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      '¿Estás seguro de que quieres eliminar este medicamento?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get error => 'Error';

  @override
  String get add => 'Añadir';

  @override
  String markedAsTaken(String name) => '$name marcado como tomado';

  @override
  String noMedicationLeftInStock(String name) => 'No queda $name en stock';

  @override
  String get setReminderFeatureComingSoon =>
      'La función de recordatorio llegará pronto';

  @override
  String get selectMedication => 'Seleccionar medicamento';

  @override
  String get todaysMedications => 'Medicamentos de hoy';

  @override
  String takenOf(int taken, int total) => 'Tomado $taken de $total';

  @override
  String get takeAll => 'Tomar todos';

  @override
  String get noMedicationsScheduledForToday =>
      'No hay medicamentos programados para hoy.';

  @override
  String get settings => 'Ajustes';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get medicationLogs => 'Registros de medicamentos';

  @override
  String get noLogsYet => 'No hay registros todavía.';

  @override
  String get time => 'Hora';

  @override
  String get medicationAdherence => 'Adherencia a la medicación';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get noMedicationLogsYet => 'No hay registros todavía';

  @override
  String get adherenceStatistics => 'Estadísticas de adherencia';

  @override
  String get last7Days => 'Últimos 7 días';

  @override
  String get last30Days => 'Últimos 30 días';

  @override
  String get overallAdherence => 'Adherencia general';

  @override
  String get dosesTaken => 'Dosis tomadas';

  @override
  String get dosesMissed => 'Dosis perdidas';

  @override
  String get weeklyView => 'Vista semanal';

  @override
  String get monthlyView => 'Vista mensual';

  @override
  String get daily => 'Diario';

  @override
  String get specificDays => 'Días específicos';

  @override
  String get everyNDays => 'Cada N días';

  @override
  String get selectDays => 'Seleccionar días';

  @override
  String get every => 'Cada';

  @override
  String get day => 'día';

  @override
  String get days => 'días';

  @override
  String get timesPerDay => 'veces al día';

  @override
  String timesDaily(int times) =>
      times == 1 ? 'Una vez al día' : '$times veces al día';

  @override
  String onDays(String days) => 'En $days';

  @override
  String timesOnDays(int times, String days) =>
      times == 1 ? 'En $days' : '$times veces en $days';

  @override
  String everyIntervalDays(int days) =>
      days == 1 ? 'Cada día' : 'Cada $days días';

  @override
  String get everyDay => 'Cada día';

  @override
  String get synchronization => 'Sincronización';

  @override
  String get blueskySynchronization => 'Sincronización BlueSky';

  @override
  String get enableBlueSkySync => 'Habilitar sincronización con BlueSky';

  @override
  String get blueSkyHandle => 'Nombre de usuario de BlueSky';

  @override
  String get yourHandleBskySocial => 'tuusuario.bsky.social';

  @override
  String get pleaseEnterYourBlueskyHandle =>
      'Por favor, introduce tu nombre de usuario de BlueSky';

  @override
  String get personalDataServerPDSURL => 'URL del servidor de datos personales (PDS)';

  @override
  String get yourPdsExampleCom => 'pds.ejemplo.com';

  @override
  String get pleaseEnterYourPDSURL => 'Por favor, introduce la URL del PDS';

  @override
  String get pleaseEnterAValidURL => 'Por favor, introduce una URL válida';

  @override
  String get enabling => 'Habilitando...';

  @override
  String get appPassword => 'Contraseña de la aplicación';

  @override
  String get disableSync => 'Deshabilitar sincronización';

  @override
  String get disableBlueSkySync => 'Deshabilitar sincronización con BlueSky';

  @override
  String get disableBlueSkySyncConfirmation =>
      '¿Estás seguro de que quieres deshabilitar la sincronización con BlueSky?';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get status => 'Estado';

  @override
  String get syncDisabled => 'Sincronización deshabilitada';

  @override
  String get loggedIn => 'Sesión iniciada';

  @override
  String get loggedOut => 'Sesión cerrada';

  @override
  String get lastSyncedAt => 'Última sincronización';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get confirmLogout => 'Confirmar cierre de sesión';

  @override
  String get areYouSureYouWantToLogoutFromBlueSky =>
      '¿Estás seguro de que quieres cerrar la sesión de BlueSky?';

  @override
  String connectedAs(String name) => 'Conectado como $name';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get googleDriveBackup => 'Copia de seguridad en Google Drive';

  @override
  String get backupToGoogleDrive => 'Copia de seguridad en Google Drive';

  @override
  String get lastBackupAt => 'Última copia de seguridad';

  @override
  String get backupNow => 'Hacer copia de seguridad ahora';

  @override
  String get restoreNow => 'Restaurar ahora';

  @override
  String get restoreNowButton => 'Restaurar ahora';

  @override
  String get connectToGoogleDrive => 'Conectar a Google Drive';

  @override
  String get disconnectGoogleDrive => 'Desconectar de Google Drive';

  @override
  String get backupSuccessful => 'Copia de seguridad completada con éxito';

  @override
  String backupFailed(String error) => 'Error en la copia de seguridad: $error';

  @override
  String get restoreFromGoogleDrive => 'Restaurar de Google Drive';

  @override
  String get restoreSuccessful => 'Restauración completada con éxito';

  @override
  String restoreFailed(String error) => 'Error en la restauración: $error';

  @override
  String get autoRestoreFromBackup => 'Restauración automática desde copia de seguridad';

  @override
  String get restoreNewerBackupOnStartup =>
      'Restaurar copia de seguridad más reciente al iniciar';

  @override
  String get noBackupFound => 'No se encontró ninguna copia de seguridad';

  @override
  String get dataExportedTo => 'Datos exportados a';

  @override
  String failedToExportData(String error) => 'Error al exportar datos: $error';

  @override
  String get dataExportedSuccessfully => 'Datos exportados con éxito';

  @override
  String get dataImportedSuccessfully => 'Datos importados con éxito';

  @override
  String failedToImportData(String error) => 'Error al importar datos: $error';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get importData => 'Importar datos';

  @override
  String get aboutBlueSkyIntegration => 'Acerca de la integración con BlueSky';

  @override
  String get aboutBlueSkyIntegrationDescription =>
      'BluePills utiliza el protocolo BlueSky AT para sincronizar tus datos entre dispositivos.';

  @override
  String get aboutBlueSkyIntegrationDescription2 =>
      'Tus datos se almacenan de forma segura en tu propio Servidor de Datos Personales (PDS).';

  @override
  String get licenseAndLegal => 'Licencias y legal';

  @override
  String get mitLicense => 'Licencia MIT';

  @override
  String get medicalDisclaimer => 'Descargo de responsabilidad médica';

  @override
  String get medicalDisclaimerDescription =>
      'Esta aplicación es solo para la gestión de información. Consulta siempre a tu médico antes de cambiar tu medicación.';

  @override
  String get syncModeLocalOnlyDescription => 'Solo almacenamiento local';

  @override
  String get syncModeSyncEnabledDescription => 'Sincronización habilitada';

  @override
  String get syncModeSyncOnlyDescription => 'Solo sincronización';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get testNotification => 'Probar notificación';

  @override
  String get notificationSent => 'Notificación de prueba enviada';

  @override
  String get medicationReminders => 'Recordatorios de medicamentos';

  @override
  String get remindersToTakeYourMedication =>
      'Recordatorios para tomar su medicamento';

  @override
  String get timeToTakeYour => 'Hora de tomar su';

  @override
  String get editMedication => 'Editar medicamento';

  @override
  String get medicationDetails => 'Detalles del medicamento';

  @override
  String get addStock => 'Añadir stock';

  @override
  String get currentQuantity => 'Cantidad actual';

  @override
  String get quantityToAdd => 'Cantidad a añadir';

  @override
  String get confirmAddStock => 'Confirmar añadir stock';

  @override
  String get stockAddedSuccessfully => 'Stock añadido con éxito';

  @override
  String get saveStock => 'Guardar stock';

  @override
  String addStockFor(String medicationName) => 'Añadir stock para: $medicationName';

  @override
  String get dailyMedications => 'Medicamentos diarios';

  @override
  String get allMedications => 'Todos los medicamentos';

  @override
  String get showLowStock => 'Mostrar stock bajo';

  @override
  String get showExpiringSoon => 'Mostrar pronto a vencer';

  @override
  String get expirationDate => 'Fecha de vencimiento';

  @override
  String get expirationDateLabel => 'Fecha de vencimiento';

  @override
  String get expiresLabel => 'Vence:';

  @override
  String get selectExpirationDateOptional =>
      'Seleccionar fecha de vencimiento (Opcional)';

  @override
  String get clearExpirationDate => 'Borrar fecha de vencimiento';

  @override
  String get syncCompletedSuccessfully => 'Sincronización completada con éxito';

  @override
  String syncFailed(String error) => 'Sincronización fallida: $error';

  @override
  String get blueskySyncEnabledSuccessfully => 'Sincronización BlueSky habilitada con éxito';

  @override
  String failedToEnableSync(String error) => 'Error al habilitar la sincronización: $error';

  @override
  String get blueskySyncDisabled => 'Sincronización BlueSky deshabilitada';

  @override
  String failedToDisableSync(String error) => 'Error al deshabilitar la sincronización: $error';

  @override
  String criticallyLowStock(int count) => 'Stock críticamente bajo ($count)';

  @override
  String get dismiss => 'Descartar';

  @override
  String get setReminder => 'Establecer recordatorio';

  @override
  String get logDose => 'Registrar dosis';

  @override
  String get newMedication => 'Nuevo medicamento';

  @override
  String reminderSetFor(String name, String time) =>
      'Recordatorio de $name establecido para las $time';

  @override
  String loggedDoseFor(String name) => 'Dosis de $name registrada';

  @override
  String get onceDaily => 'Una vez al día';

  @override
  String get twiceDaily => 'Dos veces al día';

  @override
  String get threeTimesDaily => 'Tres veces al día';

  @override
  String get asNeeded => 'Según sea necesario';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mié';

  @override
  String get thu => 'Jue';

  @override
  String get fri => 'Vie';

  @override
  String get sat => 'Sáb';

  @override
  String get sun => 'Dom';

  @override
  String get timesPerDayLabel => 'veces por día';

  @override
  String get everyDayLabel => 'cada día';

  @override
  String get everyNDaysLabel => 'cada N días';

  @override
  String get intervalDaysLabel => 'días de intervalo';

  @override
  String get pleaseSelectAFrequencyPattern => 'Por favor seleccione un patrón de frecuencia';

  @override
  String get pleaseSelectAtLeastOneDay => 'Por favor seleccione al menos un día';

  @override
  String get useAdvancedFrequency => 'Usar frecuencia avanzada';

  @override
  String get selectSpecificDaysAndPatterns => 'Seleccionar días y patrones específicos';

  @override
  String get useSimpleTextFrequency => 'Usar frecuencia de texto simple';

  @override
  String get frequencyPattern => 'Patrón de frecuencia';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get noMedicationsAvailable => 'No hay medicamentos disponibles';

  @override
  String get storageLocation => 'Ubicación';

  @override
  String get storageLocationLabel => 'Ubicación';

  @override
  String get asNeededLabel => 'Según sea necesario (PRN)';

  @override
  String get asNeededDescription => 'Sin horario fijo';

  @override
  String get lastTaken => 'Última toma';

  @override
  String lastTakenDaysAgo(int days) =>
      days == 0 ? 'Última toma: Hoy' : 'Última toma: hace $days días';

  @override
  String get selectLocation => 'Seleccionar ubicación';

  @override
  String get medicineCabinet => 'Botiquín';

  @override
  String get bedroom => 'Dormitorio';

  @override
  String get kitchen => 'Cocina';

  @override
  String get car => 'Coche';

  @override
  String get office => 'Oficina';

  @override
  String get purseBag => 'Bolso';
}
