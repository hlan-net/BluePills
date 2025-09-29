import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/screens/medication_form_screen.dart';
import 'package:bluepills/screens/settings_screen.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';

import 'package:bluepills/notifications/notification_helper.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize sqflite for desktop
  databaseFactory = databaseFactoryFfi;
  
  // Initialize services
  await ConfigService().init();
  await DatabaseHelper().init();
  await NotificationHelper().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // Force English locale to effectively "translate" from Finnish
      locale: const Locale('en', 'US'),
      home: const MedicationListScreen(),
    );
  }
}

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _refreshMedicationList();
  }

  void _refreshMedicationList() {
    setState(() {
      _medications = DatabaseHelper().getMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final configService = ConfigService();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.myMedications ?? 'My Medications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Sync status indicator
          if (configService.isSyncEnabled)
            IconButton(
              icon: Icon(
                Icons.sync,
                color: Colors.green,
              ),
              onPressed: () async {
                final syncService = SyncService();
                await syncService.performFullSync();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(syncService.syncStatus == SyncStatus.success 
                          ? 'Sync completed successfully'
                          : 'Sync failed: ${syncService.lastError ?? 'Unknown error'}'),
                      backgroundColor: syncService.syncStatus == SyncStatus.success 
                          ? Colors.green 
                          : Colors.red,
                    ),
                  );
                }
              },
            ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) => setState(() {})); // Refresh when returning from settings
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
            return Center(child: Text('${localizations?.error ?? 'Error'}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(localizations?.noMedicationsYet ?? 'No medications added yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Medication medication = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.medical_services, color: Colors.white),
                    ),
                    title: Text(medication.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${medication.dosage} - ${medication.frequency}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Medication?'),
                            content: const Text('Are you sure you want to delete this medication?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await DatabaseHelper().deleteMedication(medication.id!);
                          _refreshMedicationList();
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationFormScreen(medication: medication),
                        ),
                      );
                      if (result == true) {
                        _refreshMedicationList();
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicationFormScreen()),
          );
          if (result == true) {
            _refreshMedicationList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
