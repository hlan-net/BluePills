/// Service for managing database backup and restore operations.
///
/// This library provides functionality to backup the local database to
/// Google Drive and restore it when needed. It integrates with
/// [GoogleDriveService] for cloud storage and handles automatic restore
/// when a newer backup is available.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/config_service.dart';

/// Service for backing up and restoring the BluePills database.
///
/// This service manages backup operations to Google Drive and automatic
/// restore functionality. It checks for newer backups on startup and
/// can automatically restore them based on user preferences.
///
/// Example usage:
/// ```dart
/// final backupService = BackupService();
///
/// // Create a backup
/// await backupService.backup();
///
/// // Restore from backup
/// final success = await backupService.restore();
/// ```
class BackupService {
  final GoogleDriveService _driveService = GoogleDriveService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConfigService _configService = ConfigService();

  /// Backs up the local database to Google Drive.
  ///
  /// Uploads the current database file to Google Drive's app data folder.
  /// The user must be signed in to Google Drive for this operation to succeed.
  ///
  /// Throws an [Exception] if:
  /// - Backup is not supported on the current platform
  /// - The database file is not found
  /// - The upload to Google Drive fails
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

  /// Restores the database from a Google Drive backup.
  ///
  /// Downloads the backup file from Google Drive and replaces the local
  /// database with the backup contents. Returns true if a backup was found
  /// and restored successfully, false if no backup exists.
  ///
  /// Throws an [Exception] if:
  /// - Restore is not supported on the current platform
  /// - The download from Google Drive fails
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

  /// Checks for a newer backup on Google Drive and restores it if available.
  ///
  /// This method is typically called on app startup. It will:
  /// 1. Check if auto-restore is enabled in the app configuration
  /// 2. Attempt silent sign-in to Google Drive
  /// 3. Compare the modification times of local and remote databases
  /// 4. Restore the backup if the remote version is newer
  ///
  /// This operation silently fails if auto-restore is disabled, the user
  /// is not signed in, or no backup is found.
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

    if (metadata.modifiedTime != null &&
        metadata.modifiedTime!.isAfter(localModified)) {
      debugPrint('Newer backup found. Restoring...');
      await restore();
    }
  }
}
