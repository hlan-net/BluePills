import 'dart:convert';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ImportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
