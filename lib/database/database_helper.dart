/// Platform-agnostic database helper for medications.
///
/// This library provides a unified interface for database operations that
/// automatically selects the appropriate storage backend based on the platform
/// (SQLite for mobile/desktop, SharedPreferences for web).
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'database_adapter.dart';
import 'mobile_database_adapter.dart';
import 'web_database_adapter.dart';

/// Singleton database helper that abstracts platform-specific storage.
///
/// This class automatically selects the appropriate database adapter based
/// on the platform:
/// - Web: Uses [WebDatabaseAdapter] (SharedPreferences)
/// - Mobile/Desktop: Uses [MobileDatabaseAdapter] (SQLite)
///
/// Example usage:
/// ```dart
/// final dbHelper = DatabaseHelper();
/// await dbHelper.init();
/// final medications = await dbHelper.getMedications();
/// ```
class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal();
  late DatabaseAdapter _adapter;

  /// Returns the singleton instance of the DatabaseHelper.
  factory DatabaseHelper() {
    return _instance;
  }

  /// Allows setting a custom instance for testing purposes.
  @visibleForTesting
  static set instance(DatabaseHelper instance) {
    _instance = instance;
  }

  DatabaseHelper._internal() {
    if (kIsWeb) {
      _adapter = WebDatabaseAdapter();
    } else {
      _adapter = MobileDatabaseAdapter();
    }
  }

  /// Creates a DatabaseHelper with a custom adapter for testing.
  @visibleForTesting
  DatabaseHelper.withAdapter(this._adapter);

  /// Initializes the database adapter.
  ///
  /// Must be called before using any database operations.
  Future<void> init() async {
    await _adapter.init();
  }

  /// Inserts a new medication into the database.
  ///
  /// Returns the ID of the newly inserted medication.
  Future<int> insertMedication(Medication medication) async {
    return await _adapter.insertMedication(medication);
  }

  /// Retrieves all medications from the database.
  Future<List<Medication>> getMedications() async {
    return await _adapter.getMedications();
  }

  /// Updates an existing medication in the database.
  ///
  /// Returns the number of rows affected.
  Future<int> updateMedication(Medication medication) async {
    return await _adapter.updateMedication(medication);
  }

  /// Deletes a medication from the database by its ID.
  ///
  /// Returns the number of rows deleted.
  Future<int> deleteMedication(int id) async {
    return await _adapter.deleteMedication(id);
  }

  /// Inserts a new medication log entry into the database.
  Future<int> insertMedicationLog(MedicationLog log) async {
    return await _adapter.insertMedicationLog(log);
  }

  /// Retrieves a single medication by its ID.
  Future<Medication?> getMedication(int id) async {
    return await _adapter.getMedication(id);
  }

  /// Retrieves all medication logs for today.
  Future<List<MedicationLog>> getMedicationLogsForToday() async {
    return await _adapter.getMedicationLogsForToday();
  }
}
