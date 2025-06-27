
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/medication.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  late SharedPreferences _prefs;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<dynamic> get database async {
    if (kIsWeb) {
      // Web platform doesn't need initialization
      return null;
    } else {
      if (_database != null) {
        return _database!;
      }
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'medications.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dosage TEXT,
        frequency TEXT,
        reminderTime TEXT
      )
      '''
    );
  }
  
  // Helper methods for web storage
  void _saveToLocalStorage(List<Map<String, dynamic>> medications) {
    if (kIsWeb) {
      final String data = jsonEncode(medications);
      _prefs.setString('medications', data);
    }
  }

  List<Map<String, dynamic>> _getFromLocalStorage() {
    if (kIsWeb) {
      final String? data = _prefs.getString('medications');
      if (data != null && data.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(data);
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    }
    return [];
  }

  Future<int> insertMedication(Medication medication) async {
    if (kIsWeb) {
      final List<Map<String, dynamic>> medications = _getFromLocalStorage();
      
      // Generate a new ID
      int newId = 1;
      if (medications.isNotEmpty) {
        newId = medications.map<int>((m) => m['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
      }
      
      medication.id = newId;
      final Map<String, dynamic> medicationMap = medication.toMap();
      medications.add(medicationMap);
      
      _saveToLocalStorage(medications);
      return newId;
    } else {
      Database db = await database as Database;
      return await db.insert('medications', medication.toMap());
    }
  }

  Future<List<Medication>> getMedications() async {
    if (kIsWeb) {
      final List<Map<String, dynamic>> medications = _getFromLocalStorage();
      return medications.map((map) => Medication.fromMap(map)).toList();
    } else {
      Database db = await database as Database;
      final List<Map<String, dynamic>> maps = await db.query('medications');
      return List.generate(maps.length, (i) {
        return Medication.fromMap(maps[i]);
      });
    }
  }

  Future<int> updateMedication(Medication medication) async {
    if (kIsWeb) {
      final List<Map<String, dynamic>> medications = _getFromLocalStorage();
      int index = medications.indexWhere((m) => m['id'] == medication.id);
      
      if (index >= 0) {
        medications[index] = medication.toMap();
        _saveToLocalStorage(medications);
        return 1;
      }
      return 0;
    } else {
      Database db = await database as Database;
      return await db.update(
        'medications',
        medication.toMap(),
        where: 'id = ?',
        whereArgs: [medication.id],
      );
    }
  }

  Future<int> deleteMedication(int id) async {
    if (kIsWeb) {
      final List<Map<String, dynamic>> medications = _getFromLocalStorage();
      int initialLength = medications.length;
      medications.removeWhere((m) => m['id'] == id);
      _saveToLocalStorage(medications);
      return initialLength - medications.length;
    } else {
      Database db = await database as Database;
      return await db.delete(
        'medications',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
