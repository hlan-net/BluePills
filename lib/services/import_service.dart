import 'dart:convert';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Service for importing medication data from JSON files.
///
/// This service handles the import of medication data from JSON files that were
/// previously exported using [ExportService]. It allows users to restore their
/// medication data or transfer it between devices.
class ImportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Imports medications from a JSON file selected by the user.
  ///
  /// Opens a file picker that allows the user to select a JSON file containing
  /// medication data. The medications are parsed and inserted into the local database.
  /// Each imported medication is assigned a new ID to prevent conflicts with existing data.
  ///
  /// Only JSON files are accepted by the file picker. The file must contain an array
  /// of medication objects in the format produced by [ExportService.exportMedications].
  ///
  /// Throws an exception if the import operation fails (e.g., invalid file format,
  /// database error).
  ///
  /// Example:
  /// ```dart
  /// final importService = ImportService();
  /// await importService.importMedications();
  /// ```
  Future<void> importMedications() async {
    try {
      // Use file_picker to select a file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.bytes != null) {
        final jsonString = utf8.decode(result.files.single.bytes!);
        final List<dynamic> jsonList = jsonDecode(jsonString);

        for (var jsonMed in jsonList) {
          final medication = Medication.fromMap(jsonMed);
          // Set id to null to ensure a new medication is created
          medication.id = null;
          await _databaseHelper.insertMedication(medication);
        }
      }
    } catch (e) {
      // Handle exceptions
      debugPrint('Error importing medications: $e');
      rethrow;
    }
  }
}
