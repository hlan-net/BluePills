
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/medication.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
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

  Future<int> insertMedication(Medication medication) async {
    Database db = await database;
    return await db.insert('medications', medication.toMap());
  }

  Future<List<Medication>> getMedications() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<int> updateMedication(Medication medication) async {
    Database db = await database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  Future<int> deleteMedication(int id) async {
    Database db = await database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
