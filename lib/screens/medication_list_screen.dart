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
class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Medication>> _medications;
  bool _isSpeedDialOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showOnlyLowStock = false;
  bool _showOnlyExpiringSoon = false;
  bool _showOnlyExpired = false;
  bool _sortByExpiration = false;

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
    if (days < 0) return Colors.red;
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
        id: selectedMed.id!,
        title: selectedMed.name,
        body: '${localizations.reminderTime}: ${selectedMed.dosage}',
        scheduledTime: scheduledTime,
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

    return Scaffold(
      appBar: _buildAppBar(context, localizations),
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
            return _buildEmptyState(localizations);
          } else {
            return _buildMedicationList(context, localizations, snapshot.data!);
          }
        },
      ),
      floatingActionButton: _buildSpeedDial(localizations),
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations localizations) {
    final configService = ConfigService();
    return AppBar(
      title: Text(localizations.myMedications),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        _buildSortAction(),
        _buildLowStockAction(localizations),
        _buildExpiringSoonAction(localizations),
        _buildAdherenceAction(context),
        if (configService.isSyncEnabled)
          _buildSyncAction(context, localizations),
        _buildSettingsAction(context),
      ],
    );
  }

  Widget _buildSortAction() {
    return IconButton(
      icon: Icon(
        _sortByExpiration ? Icons.sort_by_alpha : Icons.history,
        color: _sortByExpiration ? Colors.white : null,
      ),
      tooltip: 'Sort by Expiration',
      onPressed: _toggleSortByExpiration,
    );
  }

  Widget _buildLowStockAction(AppLocalizations localizations) {
    return IconButton(
      icon: Icon(
        _showOnlyLowStock ? Icons.inventory : Icons.inventory_2_outlined,
        color: _showOnlyLowStock ? Colors.orange : null,
      ),
      tooltip: localizations.showLowStock,
      onPressed: _toggleLowStockFilter,
    );
  }

  Widget _buildExpiringSoonAction(AppLocalizations localizations) {
    return IconButton(
      icon: Icon(
        _showOnlyExpiringSoon ? Icons.event_busy : Icons.event_available,
        color: _showOnlyExpiringSoon ? Colors.red : null,
      ),
      tooltip: localizations.showExpiringSoon,
      onPressed: _toggleExpiringSoonFilter,
    );
  }

  Widget _buildAdherenceAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdherenceScreen()),
        );
      },
    );
  }

  Widget _buildSyncAction(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return IconButton(
      icon: const Icon(Icons.sync, color: Colors.green),
      onPressed: () => _performSync(context, localizations),
    );
  }

  Widget _buildSettingsAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => _openSettings(context),
    );
  }

  void _toggleSortByExpiration() {
    setState(() {
      _sortByExpiration = !_sortByExpiration;
    });
  }

  void _toggleLowStockFilter() {
    setState(() {
      _showOnlyLowStock = !_showOnlyLowStock;
      if (_showOnlyLowStock) {
        _showOnlyExpiringSoon = false;
        _showOnlyExpired = false;
      }
    });
  }

  void _toggleExpiringSoonFilter() {
    setState(() {
      _showOnlyExpiringSoon = !_showOnlyExpiringSoon;
      if (_showOnlyExpiringSoon) {
        _showOnlyLowStock = false;
        _showOnlyExpired = false;
      }
    });
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _performSync(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
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
        backgroundColor: syncService.syncStatus == SyncStatus.success
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
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
  }

  Widget _buildMedicationList(
    BuildContext context,
    AppLocalizations localizations,
    List<Medication> medications,
  ) {
    final displayMedications = _prepareDisplayMedications(medications);
    final hasCriticalStock = displayMedications.any(
      (med) => med.getDaysOfSupply() < 3,
    );

    return Column(
      children: [
        if (hasCriticalStock) _buildCriticalStockBanner(localizations),
        Expanded(
          child: ListView(
            children: [
              _buildTodaysMedicationsSection(medications),
              _buildAllMedicationsHeader(localizations),
              ...displayMedications.map(
                (med) => _buildMedicationCard(context, localizations, med),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Medication> _prepareDisplayMedications(List<Medication> medications) {
    var filtered = List<Medication>.from(medications);
    filtered = _applyFilter(filtered, _showOnlyLowStock, _isLowStock);
    filtered = _applyFilter(filtered, _showOnlyExpiringSoon, _isExpiringSoon);
    filtered = _applyFilter(filtered, _showOnlyExpired, _isExpired);

    if (_sortByExpiration) {
      filtered.sort(_compareByExpirationDate);
    }
    return filtered;
  }

  List<Medication> _applyFilter(
    List<Medication> medications,
    bool shouldFilter,
    bool Function(Medication) predicate,
  ) {
    return shouldFilter ? medications.where(predicate).toList() : medications;
  }

  bool _isLowStock(Medication medication) => medication.getDaysOfSupply() < 7;

  bool _isExpiringSoon(Medication medication) {
    final days = medication.getDaysUntilExpiration();
    return days != null && days >= 0 && days < 30;
  }

  bool _isExpired(Medication medication) {
    final days = medication.getDaysUntilExpiration();
    return days != null && days < 0;
  }

  int _compareByExpirationDate(Medication a, Medication b) {
    if (a.expirationDate == null && b.expirationDate == null) return 0;
    if (a.expirationDate == null) return 1;
    if (b.expirationDate == null) return -1;
    return a.expirationDate!.compareTo(b.expirationDate!);
  }

  Widget _buildCriticalStockBanner(AppLocalizations localizations) {
    return MaterialBanner(
      padding: const EdgeInsets.all(16),
      content: Text(
        localizations.criticallyLowStock(1),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            localizations.dismiss,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysMedicationsSection(List<Medication> medications) {
    return FutureBuilder<List<MedicationLog>>(
      future: DatabaseHelper().getMedicationLogsForToday(),
      builder: (context, logsSnapshot) {
        if (!logsSnapshot.hasData) {
          return const SizedBox.shrink();
        }
        final logsToday = logsSnapshot.data!;
        final todaysScheduled = medications
            .where((m) => m.shouldTakeToday())
            .toList();
        final asNeeded = medications.where((m) => m.isAsNeeded).toList();

        if (todaysScheduled.isEmpty && asNeeded.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            if (todaysScheduled.isNotEmpty)
              TodayMedicationsWidget(
                medications: todaysScheduled,
                logs: logsToday,
                onTakeMedication: _takeMedication,
                onTakeAll: _takeAllMedications,
              ),
            if (asNeeded.isNotEmpty)
              _buildAsNeededSection(context, asNeeded, logsToday),
          ],
        );
      },
    );
  }

  Widget _buildAsNeededSection(
    BuildContext context,
    List<Medication> asNeeded,
    List<MedicationLog> logsToday,
  ) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            localizations.asNeeded,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...asNeeded.map(
          (med) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.medical_information, color: Colors.white),
              ),
              title: Text(med.name),
              subtitle: Text(med.dosage),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _takeMedication(med),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllMedicationsHeader(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        localizations.allMedications,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMedicationCard(
    BuildContext context,
    AppLocalizations localizations,
    Medication medication,
  ) {
    final daysUntilExpiration = medication.getDaysUntilExpiration();
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            medication.isAsNeeded
                ? Icons.medical_information
                : Icons.medical_services,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                medication.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (medication.isAsNeeded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  localizations.asNeeded,
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${localizations.dosageLabel} ${medication.dosage}'
              '${medication.isAsNeeded ? '' : ' - ${localizations.frequencyLabel} ${_getFrequencyText(medication.frequency, localizations)}'}'
              ' - ${localizations.quantityLabel} ${medication.quantity}'
              '${!medication.isAsNeeded && medication.getDaysOfSupply() < 9999 ? ' (${localizations.daysOfSupply(medication.getDaysOfSupply())})' : ''}',
            ),
            if (medication.storageLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      medication.storageLocation!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            if (medication.expirationDate != null)
              _buildExpirationInfo(
                context,
                localizations,
                daysUntilExpiration,
                medication.expirationDate!,
              ),
          ],
        ),
        trailing: _buildCardTrailing(localizations, medication),
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
  }

  Widget _buildExpirationInfo(
    BuildContext context,
    AppLocalizations localizations,
    int? daysUntilExpiration,
    DateTime expirationDate,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.event,
            size: 14,
            color: _getExpirationColor(daysUntilExpiration),
          ),
          const SizedBox(width: 4),
          Text(
            '${localizations.expiresLabel} ${MaterialLocalizations.of(context).formatMediumDate(expirationDate)}',
            style: TextStyle(
              fontSize: 12,
              color: _getExpirationColor(daysUntilExpiration),
              fontWeight:
                  (daysUntilExpiration != null && daysUntilExpiration < 7)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTrailing(
    AppLocalizations localizations,
    Medication medication,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!medication.isAsNeeded) ...[
          if (medication.getDaysOfSupply() < 3)
            const Icon(Icons.error, color: Colors.red)
          else if (medication.getDaysOfSupply() < 7)
            const Icon(Icons.warning, color: Colors.amber),
        ],
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => _takeMedication(medication),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(localizations, medication),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    AppLocalizations localizations,
    Medication medication,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteMedication),
        content: Text(localizations.areYouSureYouWantToDeleteThisMedication),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper().deleteMedication(medication.id!);
      _refreshMedicationList();
    }
  }

  Widget _buildSpeedDial(AppLocalizations localizations) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
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
            FloatingActionButton(
              heroTag: 'main',
              onPressed: _toggleSpeedDial,
              tooltip: localizations.add,
              child: AnimatedRotation(
                turns: _isSpeedDialOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(_isSpeedDialOpen ? Icons.close : Icons.add),
              ),
            ),
          ],
        ),
      ],
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
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
