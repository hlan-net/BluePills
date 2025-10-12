/// Abstract interface for database adapters.
///
/// This library defines the interface that all database adapters must implement,
/// allowing the application to use different storage backends (SQLite for mobile,
/// SharedPreferences for web) with a unified API.
library;

import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';

/// Abstract interface for database operations on medications.
///
/// Implementations of this interface provide platform-specific storage
/// solutions while maintaining a consistent API for the application.
///
/// Current implementations:
/// - [MobileDatabaseAdapter]: Uses SQLite for mobile and desktop platforms
/// - [WebDatabaseAdapter]: Uses SharedPreferences for web platform
abstract class DatabaseAdapter {
  /// Initializes the database adapter.
  ///
  /// Must be called before any other operations.
  Future<void> init();

  /// Inserts a new medication into the database.
  ///
  /// Returns the ID of the inserted medication.
  Future<int> insertMedication(Medication medication);

  /// Retrieves all medications from the database.
  ///
  /// Returns a list of all stored medications.
  Future<List<Medication>> getMedications();

  /// Updates an existing medication in the database.
  ///
  /// Returns the number of rows affected (typically 1).
  Future<int> updateMedication(Medication medication);

  /// Deletes a medication from the database by its ID.
  ///
  /// Returns the number of rows deleted (typically 1).
  Future<int> deleteMedication(int id);

  /// Inserts a new medication log entry into the database.
  Future<int> insertMedicationLog(MedicationLog log);

  /// Retrieves all medication log entries for a given medication ID.
  Future<List<MedicationLog>> getMedicationLogs(int medicationId);

  /// Retrieves a single medication by its ID.
  Future<Medication?> getMedication(int id);

  /// Retrieves the last time a dose was taken for a given medication ID.
  Future<DateTime?> getLastTakenTime(int medicationId);
}
