import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluepills/models/medication.dart';
import 'database_adapter.dart';

class WebDatabaseAdapter extends DatabaseAdapter {
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<int> insertMedication(Medication medication) async {
    final List<Map<String, dynamic>> medications = _getFromLocalStorage();
    int newId = 1;
    if (medications.isNotEmpty) {
      newId =
          medications
              .map<int>((m) => m['id'] as int)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
    medication.id = newId;
    final Map<String, dynamic> medicationMap = medication.toMap();
    medications.add(medicationMap);
    _saveToLocalStorage(medications);
    return newId;
  }

  @override
  Future<List<Medication>> getMedications() async {
    final List<Map<String, dynamic>> medications = _getFromLocalStorage();
    return medications.map((map) => Medication.fromMap(map)).toList();
  }

  @override
  Future<int> updateMedication(Medication medication) async {
    final List<Map<String, dynamic>> medications = _getFromLocalStorage();
    int index = medications.indexWhere((m) => m['id'] == medication.id);
    if (index >= 0) {
      medications[index] = medication.toMap();
      _saveToLocalStorage(medications);
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteMedication(int id) async {
    final List<Map<String, dynamic>> medications = _getFromLocalStorage();
    int initialLength = medications.length;
    medications.removeWhere((m) => m['id'] == id);
    _saveToLocalStorage(medications);
    return initialLength - medications.length;
  }

  void _saveToLocalStorage(List<Map<String, dynamic>> medications) {
    final String data = jsonEncode(medications);
    _prefs.setString('medications', data);
  }

  List<Map<String, dynamic>> _getFromLocalStorage() {
    final String? data = _prefs.getString('medications');
    if (data != null && data.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }
}
