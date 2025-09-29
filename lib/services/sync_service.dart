import 'package:bluepills/models/medication.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/services/at_protocol_service.dart';
import 'package:bluepills/services/config_service.dart';

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ATProtocolService _atProtocolService = ATProtocolService();
  final ConfigService _configService = ConfigService();

  SyncStatus _syncStatus = SyncStatus.idle;
  String? _lastError;
  
  SyncStatus get syncStatus => _syncStatus;
  String? get lastError => _lastError;

  Future<bool> performFullSync() async {
    if (!_configService.isSyncEnabled || !_configService.hasValidSyncConfig) {
      return false;
    }

    _syncStatus = SyncStatus.syncing;
    _lastError = null;

    try {
      // Step 1: Authenticate if needed
      if (!_atProtocolService.isAuthenticated) {
        // This would typically require user credentials
        // For now, we'll assume authentication is handled elsewhere
        throw Exception('Not authenticated with BlueSky');
      }

      // Step 2: Fetch remote medications
      final remoteMedications = await _atProtocolService.fetchMedications();
      
      // Step 3: Get local medications that need sync
      final localMedications = await _databaseHelper.getMedications();
      final localMedicationsNeedingSync = localMedications
          .where((m) => m.needsSync)
          .toList();

      // Step 4: Upload local changes
      for (final medication in localMedicationsNeedingSync) {
        final success = await _atProtocolService.syncMedication(medication);
        if (success) {
          // Mark as synced locally
          final updatedMedication = medication.copyWith(
            needsSync: false,
            lastSynced: DateTime.now(),
          );
          await _databaseHelper.updateMedication(updatedMedication);
        }
      }

      // Step 5: Download and merge remote changes
      await _mergeRemoteMedications(remoteMedications, localMedications);

      // Step 6: Update last sync time
      await _configService.updateLastSyncTime();

      _syncStatus = SyncStatus.success;
      return true;
    } catch (e) {
      _lastError = e.toString();
      _syncStatus = SyncStatus.error;
      print('Sync error: $e');
      return false;
    }
  }

  Future<void> _mergeRemoteMedications(
    List<Medication> remoteMedications,
    List<Medication> localMedications,
  ) async {
    for (final remoteMedication in remoteMedications) {
      // Find corresponding local medication by remoteId
      final localMedication = localMedications
          .where((m) => m.remoteId == remoteMedication.remoteId)
          .firstOrNull;

      if (localMedication == null) {
        // New medication from remote - add to local
        await _databaseHelper.insertMedication(remoteMedication);
      } else {
        // Existing medication - check for conflicts
        final shouldUpdateLocal = _shouldUpdateFromRemote(
          localMedication,
          remoteMedication,
        );
        
        if (shouldUpdateLocal) {
          // Update local with remote data
          final mergedMedication = localMedication.copyWith(
            name: remoteMedication.name,
            dosage: remoteMedication.dosage,
            frequency: remoteMedication.frequency,
            reminderTime: remoteMedication.reminderTime,
            updatedAt: remoteMedication.updatedAt,
            lastSynced: DateTime.now(),
            needsSync: false,
          );
          await _databaseHelper.updateMedication(mergedMedication);
        }
      }
    }

    // Handle deletions: local medications that don't exist remotely
    // This is more complex and depends on your deletion strategy
    // For now, we'll skip this to avoid accidental data loss
  }

  bool _shouldUpdateFromRemote(
    Medication local,
    Medication remote,
  ) {
    // Simple conflict resolution: use the most recently updated
    // In a more sophisticated system, you might want to:
    // 1. Prompt the user for conflict resolution
    // 2. Use a more complex merge strategy
    // 3. Keep both versions and let the user decide
    
    if (local.lastSynced == null) {
      // Local was never synced, prioritize remote
      return true;
    }
    
    return remote.updatedAt.isAfter(local.updatedAt);
  }

  Future<bool> syncSingleMedication(Medication medication) async {
    if (!_configService.isSyncEnabled) {
      return false;
    }

    try {
      final success = await _atProtocolService.syncMedication(medication);
      if (success) {
        // Update local medication to mark as synced
        final updatedMedication = medication.copyWith(
          needsSync: false,
          lastSynced: DateTime.now(),
        );
        await _databaseHelper.updateMedication(updatedMedication);
      }
      return success;
    } catch (e) {
      print('Single medication sync error: $e');
      return false;
    }
  }

  Future<bool> deleteMedicationFromSync(Medication medication) async {
    if (!_configService.isSyncEnabled || medication.remoteId == null) {
      return false;
    }

    try {
      return await _atProtocolService.deleteMedication(medication.remoteId!);
    } catch (e) {
      print('Delete medication from sync error: $e');
      return false;
    }
  }

  Future<void> markMedicationForSync(int medicationId) async {
    final medications = await _databaseHelper.getMedications();
    final medication = medications.where((m) => m.id == medicationId).firstOrNull;
    
    if (medication != null) {
      final updatedMedication = medication.copyWith(needsSync: true);
      await _databaseHelper.updateMedication(updatedMedication);
    }
  }

  /// Perform a background sync if conditions are met
  Future<void> performBackgroundSync() async {
    if (_syncStatus == SyncStatus.syncing) {
      return; // Already syncing
    }

    final config = _configService.config;
    if (!config.syncEnabled) {
      return;
    }

    // Only sync if it's been more than 5 minutes since last sync
    if (config.lastSyncTime != null) {
      final timeSinceLastSync = DateTime.now().difference(config.lastSyncTime!);
      if (timeSinceLastSync.inMinutes < 5) {
        return;
      }
    }

    await performFullSync();
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}