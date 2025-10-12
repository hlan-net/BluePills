import 'dart:convert';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class ExportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
