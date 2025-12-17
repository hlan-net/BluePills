import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/config_service.dart';

class BackupService {
  final GoogleDriveService _driveService = GoogleDriveService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConfigService _configService = ConfigService();

  Future<void> backup() async {
    final dbPath = await _dbHelper.getDatabasePath();
    if (dbPath == null) {
      throw Exception('Backup not supported on this platform');
    }

    final file = File(dbPath);
    if (!await file.exists()) {
      throw Exception('Database file not found');
    }

    await _driveService.uploadBackup(file);
  }

  Future<bool> restore() async {
    final dbPath = await _dbHelper.getDatabasePath();
    if (dbPath == null) {
      throw Exception('Restore not supported on this platform');
    }

    final metadata = await _driveService.getBackupMetadata();
    if (metadata == null || metadata.id == null) {
      return false; // No backup found
    }

    final file = File(dbPath);
    
    await _driveService.downloadBackup(metadata.id!, file);
    
    return true;
  }

  Future<void> checkAndRestore() async {
    if (!_configService.config.autoRestoreEnabled) return;
    
    // Check if signed in
    final account = await _driveService.signInSilently();
    if (account == null) return;

    final metadata = await _driveService.getBackupMetadata();
    if (metadata == null) return;

    final dbPath = await _dbHelper.getDatabasePath();
    if (dbPath == null) return;
    
    final file = File(dbPath);
    DateTime localModified = DateTime.fromMillisecondsSinceEpoch(0);
    if (await file.exists()) {
      localModified = await file.lastModified();
    }

    if (metadata.modifiedTime != null && metadata.modifiedTime!.isAfter(localModified)) {
       debugPrint('Newer backup found. Restoring...');
       await restore();
    }
  }
}
