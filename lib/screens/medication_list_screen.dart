import 'package:flutter/material.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/screens/medication_form_screen.dart';
import 'package:bluepills/screens/settings_screen.dart';
import 'package:bluepills/screens/medication_details_screen.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:bluepills/widgets/today_medications_widget.dart';
import 'package:bluepills/screens/adherence_screen.dart';
import 'package:bluepills/notifications/notification_helper.dart';

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
  bool _showOnlyLowStock = false;
  bool _showOnlyExpiringSoon = false;

  String _getFrequencyText(
    Frequency frequency,
    AppLocalizations localizations,
  ) {
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

  Color _getExpirationColor(int? days) {
    if (days == null) return Colors.grey;
    if (days < 7) return Colors.red;
    if (days < 30) return Colors.orange;
    if (days < 60) return Colors.amber;
    return Colors.green;
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

  Future<void> _takeMedication(Medication med) async {
    if (med.quantity <= 0) {
      if (!mounted) return;
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.noMedicationLeftInStock(med.name)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final updatedMedication = med.copyWith(quantity: med.quantity - 1);
    await DatabaseHelper().updateMedication(updatedMedication);
    await DatabaseHelper().insertMedicationLog(
      MedicationLog(medicationId: med.id!, timestamp: DateTime.now()),
    );

    if (!mounted) return;

    _refreshMedicationList();
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.markedAsTaken(med.name)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _takeAllMedications() async {
    final medications = await _medications;
    final logs = await DatabaseHelper().getMedicationLogsForToday();
    final todaysMedications = medications
        .where((m) => m.shouldTakeToday())
        .toList();
    for (final med in todaysMedications) {
      if (!med.isTakenToday(logs)) {
        await _takeMedication(med);
      }
    }
  }

  Future<void> _addNewMedication() async {
    _closeSpeedDial();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicationFormScreen()),
    );
    if (result == true) {
      _refreshMedicationList();
    }
  }

  Future<Medication?> _selectMedication() async {
    final medications = await DatabaseHelper().getMedications();
    if (!mounted) return null;

    final localizations = AppLocalizations.of(context)!;

    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.noMedicationsAvailable)),
      );
      return null;
    }

    return showDialog<Medication>(
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
  }

  Future<void> _addDose() async {
    _closeSpeedDial();
    final selectedMed = await _selectMedication();
    if (selectedMed == null || !mounted) return;

    if (selectedMed.quantity <= 0) {
      if (!mounted) return;
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.noMedicationLeftInStock(selectedMed.name),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final updatedMedication = selectedMed.copyWith(
      quantity: selectedMed.quantity - 1,
    );
    await DatabaseHelper().updateMedication(updatedMedication);
    await DatabaseHelper().insertMedicationLog(
      MedicationLog(medicationId: selectedMed.id!, timestamp: DateTime.now()),
    );

    if (!mounted) return;

    _refreshMedicationList();
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.loggedDoseFor(selectedMed.name)),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _setReminder() async {
    _closeSpeedDial();
    final selectedMed = await _selectMedication();
    if (selectedMed == null || !mounted) return;

    final localizations = AppLocalizations.of(context)!;

    // Pick reminder time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedMed.reminderTime),
      helpText: localizations.selectReminderTime,
    );

    if (pickedTime == null || !mounted) return;

    // Build the scheduled DateTime (today's date with picked time).
    // NotificationHelper handles bumping past times to the next day.
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Update medication reminder time
    final updatedMed = selectedMed.copyWith(reminderTime: scheduledTime);
    await DatabaseHelper().updateMedication(updatedMed);

    // Schedule the notification
    try {
      await NotificationHelper().scheduleNotification(
        selectedMed.id!,
        selectedMed.name,
        '${localizations.reminderTime}: ${selectedMed.dosage}',
        scheduledTime,
        frequencyPattern: selectedMed.frequencyPattern,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }

    if (!mounted) return;
    _refreshMedicationList();

    final timeStr =
        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.reminderSetFor(selectedMed.name, timeStr)),
        backgroundColor: Colors.green,
      ),
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
          // Low stock filter button
          IconButton(
            icon: Icon(
              _showOnlyLowStock ? Icons.inventory : Icons.inventory_2_outlined,
              color: _showOnlyLowStock ? Colors.orange : null,
            ),
            tooltip: localizations.showLowStock,
            onPressed: () {
              setState(() {
                _showOnlyLowStock = !_showOnlyLowStock;
                if (_showOnlyLowStock) _showOnlyExpiringSoon = false;
              });
            },
          ),
          // Expiring soon filter button
          IconButton(
            icon: Icon(
              _showOnlyExpiringSoon ? Icons.event_busy : Icons.event_available,
              color: _showOnlyExpiringSoon ? Colors.red : null,
            ),
            tooltip: localizations.showExpiringSoon,
            onPressed: () {
              setState(() {
                _showOnlyExpiringSoon = !_showOnlyExpiringSoon;
                if (_showOnlyExpiringSoon) _showOnlyLowStock = false;
              });
            },
          ),
          // Adherence screen button
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdherenceScreen(),
                ),
              );
            },
          ),
          // Sync status indicator
          if (configService.isSyncEnabled)
            IconButton(
              icon: const Icon(Icons.sync, color: Colors.green),
              onPressed: () async {
                final syncService = SyncService();
                await syncService.performFullSync();
                if (!context.mounted) return;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      syncService.syncStatus == SyncStatus.success
                          ? localizations.syncCompletedSuccessfully
                          : localizations.syncFailed(
                              syncService.lastError ?? 'Unknown error',
                            ),
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
              ).then((_) {
                if (mounted) setState(() {});
              }); // Refresh when returning from settings
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
              child: Text('${localizations.error}: ${snapshot.error}'),
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
            var displayMedications = snapshot.data!; // Original unfiltered list

            // Filter for low stock if needed
            if (_showOnlyLowStock) {
              displayMedications = displayMedications
                  .where((med) => med.getDaysOfSupply() < 7)
                  .toList();
            }

            // Filter for expiring soon if needed
            if (_showOnlyExpiringSoon) {
              displayMedications = displayMedications.where((med) {
                final days = med.getDaysUntilExpiration();
                return days != null && days < 30;
              }).toList();
            }

            // Identify critically low stock for banner
            final criticallyLowStockMeds = displayMedications
                .where((med) => med.getDaysOfSupply() < 3)
                .toList();

            return Column(
              children: [
                if (criticallyLowStockMeds.isNotEmpty)
                  MaterialBanner(
                    padding: const EdgeInsets.all(16),
                    content: Text(
                      localizations.criticallyLowStock(
                        criticallyLowStockMeds.length,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    actions: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).hideCurrentMaterialBanner();
                        },
                        child: Text(
                          localizations.dismiss,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView(
                    children: [
                      // Today's Medications Section
                      FutureBuilder<List<MedicationLog>>(
                        future: DatabaseHelper().getMedicationLogsForToday(),
                        builder: (context, logsSnapshot) {
                          if (!logsSnapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          final logsToday = logsSnapshot.data!;
                          final todaysMedicationsForWidget = snapshot
                              .data! // Use original unfiltered list
                              .where((m) => m.shouldTakeToday())
                              .toList();
                          if (todaysMedicationsForWidget.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return TodayMedicationsWidget(
                            medications: todaysMedicationsForWidget,
                            logs: logsToday,
                            onTakeMedication: _takeMedication,
                            onTakeAll: _takeAllMedications,
                          );
                        },
                      ),
                      // All Medications List
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          localizations.allMedications,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...List.generate(displayMedications.length, (index) {
                        final medication = displayMedications[index];
                        final daysUntilExpiration = medication
                            .getDaysUntilExpiration();
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: const Icon(
                                Icons.medical_services,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              medication.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${localizations.dosageLabel} ${medication.dosage} - ${localizations.frequencyLabel} ${_getFrequencyText(medication.frequency, localizations)} - ${localizations.quantityLabel} ${medication.quantity}'
                                  '${medication.getDaysOfSupply() < 9999 ? ' (${localizations.daysOfSupply(medication.getDaysOfSupply())})' : ''}',
                                ),
                                if (medication.expirationDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.event,
                                          size: 14,
                                          color: _getExpirationColor(
                                            daysUntilExpiration,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${localizations.expiresLabel} ${MaterialLocalizations.of(context).formatMediumDate(medication.expirationDate!)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _getExpirationColor(
                                              daysUntilExpiration,
                                            ),
                                            fontWeight:
                                                (daysUntilExpiration != null &&
                                                    daysUntilExpiration < 7)
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (medication.getDaysOfSupply() < 3)
                                  const Icon(Icons.error, color: Colors.red)
                                else if (medication.getDaysOfSupply() < 7)
                                  const Icon(
                                    Icons.warning,
                                    color: Colors.amber,
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () => _takeMedication(medication),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          localizations.deleteMedication,
                                        ),
                                        content: Text(
                                          localizations
                                              .areYouSureYouWantToDeleteThisMedication,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
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
                                  builder: (context) => MedicationDetailsScreen(
                                    medication: medication,
                                  ),
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
                  ),
                ),
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
              _buildSpeedDialOption(
                label: localizations.setReminder,
                icon: Icons.alarm,
                color: Colors.orange,
                onPressed: _setReminder,
                heroTag: 'reminder',
              ),
              _buildSpeedDialOption(
                label: localizations.logDose,
                icon: Icons.check_circle,
                color: Colors.green,
                onPressed: _addDose,
                heroTag: 'dose',
              ),
              _buildSpeedDialOption(
                label: localizations.newMedication,
                icon: Icons.medical_services,
                color: Colors.blue,
                onPressed: _addNewMedication,
                heroTag: 'medication',
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

  Widget _buildSpeedDialOption({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return ScaleTransition(
      scale: _animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: heroTag,
              mini: true,
              onPressed: onPressed,
              backgroundColor: color,
              child: Icon(icon),
            ),
          ],
        ),
      ),
    );
  }
}
