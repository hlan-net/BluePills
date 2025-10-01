import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:bluepills/models/medication.dart';
import 'database_adapter.dart';
import 'mobile_database_adapter.dart';
import 'web_database_adapter.dart';

class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal();
  late DatabaseAdapter _adapter;

  factory DatabaseHelper() {
    return _instance;
  }

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

  @visibleForTesting
  DatabaseHelper.withAdapter(this._adapter);

  Future<void> init() async {
    await _adapter.init();
  }

  Future<int> insertMedication(Medication medication) async {
    return await _adapter.insertMedication(medication);
  }

  Future<List<Medication>> getMedications() async {
    return await _adapter.getMedications();
  }

  Future<int> updateMedication(Medication medication) async {
    return await _adapter.updateMedication(medication);
  }

  Future<int> deleteMedication(int id) async {
    return await _adapter.deleteMedication(id);
  }
}
