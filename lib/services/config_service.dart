/// Service for managing application configuration and settings.
///
/// This library provides a singleton service for loading, saving, and updating
/// the application configuration including BlueSky sync settings.
library;

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluepills/models/app_config.dart';

/// Singleton service for managing application configuration.
class ConfigService {
  /// The key used to store configuration in SharedPreferences.
  static const String _configKey = 'app_config';

  static ConfigService _instance = ConfigService._internal();

  /// Returns the singleton instance of the ConfigService.
  factory ConfigService() => _instance;

  /// Sets the singleton instance of the ConfigService (used for testing).
  @visibleForTesting
  static set instance(ConfigService service) => _instance = service;

  ConfigService._internal();

  SharedPreferences? _prefs;
  AppConfig _config = const AppConfig();

  /// Returns the current application configuration.
  AppConfig get config => _config;

  /// Initializes the ConfigService by loading SharedPreferences and the saved configuration.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    final configJson = _prefs?.getString(_configKey);
    if (configJson != null) {
      try {
        final configMap = jsonDecode(configJson) as Map<String, dynamic>;
        _config = AppConfig.fromJson(configMap);
      } catch (e) {
        _config = const AppConfig();
      }
    }
  }

  /// Updates the application configuration with new values.
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
    await _saveConfig();
  }

  Future<void> _saveConfig() async {
    final configJson = jsonEncode(_config.toJson());
    await _prefs?.setString(_configKey, configJson);
  }

  /// Updates synchronization configuration.
  Future<void> updateSyncConfig({
    required bool syncEnabled,
    String? blueskyHandle,
    String? appPassword,
    String? pdsUrl,
  }) async {
    final newConfig = _config.copyWith(
      syncEnabled: syncEnabled,
      blueskyHandle: blueskyHandle ?? _config.blueskyHandle,
      pdsUrl: pdsUrl ?? _config.pdsUrl,
      syncMode: syncEnabled ? SyncMode.syncEnabled : SyncMode.localOnly,
    );
    await updateConfig(newConfig);
  }

  /// Updates the application language.
  Future<void> updateLanguage(String languageCode) async {
    final newConfig = _config.copyWith(languageCode: languageCode);
    await updateConfig(newConfig);
  }

  /// Updates the last sync time in the configuration.
  Future<void> updateLastSyncTime([DateTime? time]) async {
    final newConfig = _config.copyWith(
      timestamps: AppConfigTimestamps(lastSyncTime: time ?? DateTime.now()),
    );
    await updateConfig(newConfig);
  }

  /// Updates the last backup time in the configuration.
  Future<void> updateLastBackupTime([DateTime? time]) async {
    final newConfig = _config.copyWith(
      timestamps: AppConfigTimestamps(lastBackupTime: time ?? DateTime.now()),
    );
    await updateConfig(newConfig);
  }

  /// Returns true if synchronization is currently enabled.
  bool get isSyncEnabled => _config.syncEnabled;

  /// Returns true if the sync configuration has valid handle and PDS URL.
  bool get hasValidSyncConfig =>
      _config.blueskyHandle?.isNotEmpty == true &&
      _config.pdsUrl?.isNotEmpty == true;
}
