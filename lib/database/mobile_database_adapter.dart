
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bluepills/models/medication.dart';
import 'database_adapter.dart';

class MobileDatabaseAdapter extends DatabaseAdapter {
  static Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) {
      return;
    }
    _database = await _initDatabase();
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
        reminderTime TEXT,
        remoteId TEXT,
        lastSynced TEXT,
        needsSync INTEGER DEFAULT 1,
        createdAt TEXT,
        updatedAt TEXT
      )
      '''
    );
  }

  @override
  Future<int> insertMedication(Medication medication) async {
    final db = await database;
    return await db.insert('medications', medication.toMap());
  }

  @override
  Future<List<Medication>> getMedications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateMedication(Medication medication) async {
    final db = await database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  @override
  Future<int> deleteMedication(int id) async {
    final db = await database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
