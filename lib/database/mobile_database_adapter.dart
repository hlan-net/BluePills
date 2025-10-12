/// Mobile/Desktop database adapter using SQLite.
///
/// This library provides a database adapter for mobile and desktop platforms
/// that uses SQLite for persistent storage through the sqflite package.
library;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/models/medication_log.dart';
import 'database_adapter.dart';

/// Database adapter implementation for mobile and desktop platforms.
///
/// Uses SQLite through the sqflite package to provide robust, relational
/// database storage for medications. This adapter is automatically selected
/// when running on mobile or desktop platforms.
///
/// The database file is stored in the application's documents directory
/// and includes full support for sync metadata fields.
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

    // Delete the database file to force recreation with the new schema
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dosage TEXT,
        quantity INTEGER,
        frequency INTEGER,
        frequencyPatternType INTEGER,
        frequencyPatternDaysOfWeek TEXT,
        frequencyPatternIntervalDays INTEGER,
        frequencyPatternTimesPerDay INTEGER,
        frequencyPatternSpecificTimes TEXT,
        reminderTime TEXT,
        remoteId TEXT,
        lastSynced TEXT,
        needsSync INTEGER DEFAULT 1,
        createdAt TEXT,
        updatedAt TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE medication_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER,
        timestamp TEXT
      )
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new frequency pattern columns
      await db.execute(
        'ALTER TABLE medications ADD COLUMN frequencyPatternType INTEGER',
      );
      await db.execute(
        'ALTER TABLE medications ADD COLUMN frequencyPatternDaysOfWeek TEXT',
      );
      await db.execute(
        'ALTER TABLE medications ADD COLUMN frequencyPatternIntervalDays INTEGER',
      );
      await db.execute(
        'ALTER TABLE medications ADD COLUMN frequencyPatternTimesPerDay INTEGER',
      );
      await db.execute(
        'ALTER TABLE medications ADD COLUMN frequencyPatternSpecificTimes TEXT',
      );
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE medications ADD COLUMN quantity INTEGER');
      await db.execute('''
        CREATE TABLE medication_logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicationId INTEGER,
          timestamp TEXT
        )
        ''');
    }
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
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> insertMedicationLog(MedicationLog log) async {
    final db = await database;
    return await db.insert('medication_logs', log.toMap());
  }

  @override
  Future<List<MedicationLog>> getMedicationLogs(int medicationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_logs',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
    return List.generate(maps.length, (i) {
      return MedicationLog.fromMap(maps[i]);
    });
  }

  @override
  Future<Medication?> getMedication(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<DateTime?> getLastTakenTime(int medicationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_logs',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return DateTime.parse(maps.first['timestamp']);
    }
    return null;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
