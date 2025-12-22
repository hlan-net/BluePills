/// BluePills - Privacy-focused medication management application.
///
/// This is the main entry point for the BluePills application, which provides
/// medication tracking and reminder functionality with optional BlueSky sync.
///
/// The application supports:
/// - Local medication storage
/// - Medication reminders
/// - Optional BlueSky synchronization via AT Protocol
/// - Multi-language support (English and Finnish)
library;

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/screens/medication_form_screen.dart';
import 'package:bluepills/screens/settings_screen.dart';
import 'package:bluepills/screens/medication_details_screen.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:bluepills/services/backup_service.dart';

import 'package:bluepills/notifications/notification_helper.dart';

/// The main entry point for the BluePills application.
///
/// Initializes all required services before starting the app:
/// - Flutter binding
/// - SQLite database (using FFI for desktop support)
/// - Configuration service
/// - Database helper
/// - Notification system
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI for desktop platforms only
  // Android and iOS use native SQLite implementation
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize services with error handling
  try {
    await ConfigService().init();
    debugPrint('ConfigService initialized successfully');
  } catch (e) {
    debugPrint('Error initializing ConfigService: $e');
  }

  try {
    await BackupService().checkAndRestore();
    debugPrint('BackupService check completed');
  } catch (e) {
    debugPrint('Error checking backup: $e');
  }

  try {
    await DatabaseHelper().init();
    debugPrint('DatabaseHelper initialized successfully');
  } catch (e) {
    debugPrint('Error initializing DatabaseHelper: $e');
    // Show error to user that database failed
  }

  try {
    await NotificationHelper().init();
    debugPrint('NotificationHelper initialized successfully');
  } catch (e) {
    debugPrint('Error initializing NotificationHelper: $e');
    // Notifications are optional, continue even if they fail
  }

  runApp(const MyApp());
}

/// The root widget of the BluePills application.
///
/// Configures the MaterialApp with:
/// - Material Design 3 theming
/// - Localization support for English and Finnish
/// - The medication list as the home screen
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConfigService _configService = ConfigService();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _updateLocale();
    // This is a bit of a hack. A better solution would be to use a state management solution.
    // For the sake of this exercise, we'll just re-read the config every second.
    // A better solution would be to have the ConfigService be a listenable.
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _updateLocale();
      }
      return mounted;
    });
  }

  void _updateLocale() {
    final languageCode = _configService.config.languageCode;
    if (languageCode != null && languageCode.isNotEmpty) {
      setState(() {
        _locale = Locale(languageCode);
      });
    } else {
      setState(() {
        _locale = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BluePills',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const MedicationListScreen(),
    );
  }
}

/// The main screen displaying the list of medications.
///
/// This stateful widget shows all saved medications and provides
/// functionality to add, edit, delete medications, and trigger sync
/// with BlueSky if enabled.
class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

/// State class for the medication list screen.
///
/// Manages the list of medications, handles user interactions for
/// adding, editing, and deleting medications, and manages sync operations.
class _MedicationListScreenState extends State<MedicationListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Medication>> _medications;
  bool _isSpeedDialOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  String _getFrequencyText(Frequency frequency, AppLocalizations localizations) {
    switch (frequency) {
      case Frequency.onceDaily:
        return localizations.onceDaily;
      case Frequency.twiceDaily:
        return localizations.twiceDaily;
      case Frequency.threeTimesDaily:
        return localizations.threeTimesDaily;
      case Frequency.asNeeded:
        return localizations.asNeeded;
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshMedicationList();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshMedicationList() {
    setState(() {
      _medications = DatabaseHelper().getMedications();
    });
  }

  void _toggleSpeedDial() {
    setState(() {
      _isSpeedDialOpen = !_isSpeedDialOpen;
      if (_isSpeedDialOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeSpeedDial() {
    setState(() {
      _isSpeedDialOpen = false;
      _animationController.reverse();
    });
  }

  Future<void> _addNewMedication() async {
    _closeSpeedDial();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicationFormScreen()),
    );
    if (result == true) {
      _refreshMedicationList();
    }
  }

  Future<void> _addDose() async {
    _closeSpeedDial();
    // Show dialog to select medication and add dose
    final medications = await DatabaseHelper().getMedications();
    if (!mounted) return;

    final localizations = AppLocalizations.of(context)!;

    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.noMedicationsAvailable,
          ),
        ),
      );
      return;
    }

    final selectedMed = await showDialog<Medication>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.selectMedication),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: medications.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.medical_services),
                title: Text(medications[index].name),
                subtitle: Text(medications[index].dosage),
                onTap: () => Navigator.pop(context, medications[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );

    if (selectedMed != null && mounted) {
      if (selectedMed.quantity > 0) {
        final updatedMedication = selectedMed.copyWith(
          quantity: selectedMed.quantity - 1,
        );
        await DatabaseHelper().updateMedication(updatedMedication);
        await DatabaseHelper().insertMedicationLog(
          MedicationLog(
            medicationId: selectedMed.id!,
            timestamp: DateTime.now(),
          ),
        );
        _refreshMedicationList();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.loggedDoseFor(selectedMed.name)),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.noMedicationLeftInStock(selectedMed.name)),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _setReminder() async {
    _closeSpeedDial();
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.setReminderFeatureComingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final configService = ConfigService();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.myMedications),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Sync status indicator
          if (configService.isSyncEnabled)
            IconButton(
              icon: Icon(Icons.sync, color: Colors.green),
              onPressed: () async {
                final syncService = SyncService();
                await syncService.performFullSync();
                if (!context.mounted) return;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      syncService.syncStatus == SyncStatus.success
                          ? 'Sync completed successfully'
                          : 'Sync failed: ${syncService.lastError ?? 'Unknown error'}',
                    ),
                    backgroundColor:
                        syncService.syncStatus == SyncStatus.success
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
            ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ).then(
                (_) => setState(() {}),
              ); // Refresh when returning from settings
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Medication>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${localizations.error}: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.noMedicationsYet,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.tapThePlusButtonToAdd,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          } else {
            final medications = snapshot.data!;
            return ListView(
              children: [
                // Today's Medications Section
                if (medications.isNotEmpty)
                  FutureBuilder<List<MedicationLog>>(
                    future: DatabaseHelper().getMedicationLogsForToday(),
                    builder: (context, logsSnapshot) {
                      if (!logsSnapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final logsToday = logsSnapshot.data!;
                      final takenCount = logsToday.length;
                      final totalCount = medications.length;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(16),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localizations.todaysMedications,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: takenCount == totalCount
                                          ? Colors.green
                                          : Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      localizations.takenOf(takenCount, totalCount),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...medications.map((med) {
                                final isTaken = logsToday.any(
                                  (log) => log.medicationId == med.id,
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isTaken
                                            ? Icons.check_circle
                                            : Icons.schedule,
                                        color: isTaken
                                            ? Colors.green
                                            : Colors.orange,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          med.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration: isTaken
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                      if (!isTaken)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            if (med.quantity > 0) {
                                              final updatedMedication = med
                                                  .copyWith(
                                                    quantity: med.quantity - 1,
                                                  );
                                              await DatabaseHelper()
                                                  .updateMedication(
                                                    updatedMedication,
                                                  );
                                              await DatabaseHelper()
                                                  .insertMedicationLog(
                                                    MedicationLog(
                                                      medicationId: med.id!,
                                                      timestamp: DateTime.now(),
                                                    ),
                                                  );
                                              _refreshMedicationList();
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    localizations.markedAsTaken(med.name),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                // All Medications List
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    localizations.allMedications,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(medications.length, (index) {
                  final medication = medications[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        medication.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${localizations.dosageLabel} ${medication.dosage} - ${localizations.frequencyLabel} ${_getFrequencyText(medication.frequency, localizations)} - ${localizations.quantityLabel} ${medication.quantity}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () async {
                              if (medication.quantity > 0) {
                                final updatedMedication = medication.copyWith(
                                  quantity: medication.quantity - 1,
                                );
                                await DatabaseHelper().updateMedication(
                                  updatedMedication,
                                );
                                await DatabaseHelper().insertMedicationLog(
                                  MedicationLog(
                                    medicationId: medication.id!,
                                    timestamp: DateTime.now(),
                                  ),
                                );
                                _refreshMedicationList();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(localizations.deleteMedication),
                                  content: Text(
                                    localizations.areYouSureYouWantToDeleteThisMedication,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(localizations.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(localizations.delete),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await DatabaseHelper().deleteMedication(
                                  medication.id!,
                                );
                                _refreshMedicationList();
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MedicationDetailsScreen(medication: medication),
                          ),
                        );
                        if (result == true) {
                          _refreshMedicationList();
                        }
                      },
                    ),
                  );
                }),
              ],
            );
          }
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Speed dial options
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Set Reminder option
              ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          localizations.setReminder,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        heroTag: 'reminder',
                        mini: true,
                        onPressed: _setReminder,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.alarm),
                      ),
                    ],
                  ),
                ),
              ),
              // Add Dose option
              ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          localizations.logDose,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        heroTag: 'dose',
                        mini: true,
                        onPressed: _addDose,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.check_circle),
                      ),
                    ],
                  ),
                ),
              ),
              // Add Medication option
              ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          localizations.newMedication,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        heroTag: 'medication',
                        mini: true,
                        onPressed: _addNewMedication,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.medical_services),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Main FAB
              FloatingActionButton(
                heroTag: 'main',
                onPressed: _toggleSpeedDial,
                tooltip: localizations.add,
                child: AnimatedRotation(
                  turns: _isSpeedDialOpen ? 0.125 : 0, // 45 degree rotation
                  duration: const Duration(milliseconds: 200),
                  child: Icon(_isSpeedDialOpen ? Icons.close : Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
