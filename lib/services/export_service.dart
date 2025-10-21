import 'dart:convert';
import 'package:bluepills/database/database_helper.dart';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

/// Service for exporting medication data to JSON files.
///
/// This service handles the export of all medication data from the local database
/// to a JSON file that can be saved to the device's file system. The exported
/// data can later be imported using [ImportService].
class ExportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Exports all medications from the database to a JSON file.
  ///
  /// Retrieves all medications from the local database, converts them to JSON format,
  /// and saves them as a file named 'bluepills_export.json' using the device's
  /// file picker. The file can be saved to any location accessible by the user.
  ///
  /// Throws an exception if the export operation fails.
  ///
  /// Example:
  /// ```dart
  /// final exportService = ExportService();
  /// await exportService.exportMedications();
  /// ```
  Future<void> exportMedications() async {
    try {
      final medications = await _databaseHelper.getMedications();
      final jsonString = jsonEncode(medications.map((m) => m.toMap()).toList());

      // Use file_saver to save the file
      await FileSaver.instance.saveFile(
        name: 'bluepills_export.json',
        bytes: Uint8List.fromList(utf8.encode(jsonString)),
        mimeType: MimeType.json,
      );
    } catch (e) {
      // Handle exceptions
      debugPrint('Error exporting medications: $e');
      rethrow;
    }
  }
}
