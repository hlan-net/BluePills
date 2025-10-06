/// Service for managing application configuration and settings.
///
/// This library provides a singleton service for loading, saving, and updating
/// the application configuration including BlueSky sync settings.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluepills/models/app_config.dart';

/// Singleton service for managing application configuration.
///
/// This service handles loading and saving application settings to persistent
/// storage using SharedPreferences. It provides methods to enable/disable
/// BlueSky synchronization and update sync-related settings.
///
/// Example usage:
/// ```dart
/// final configService = ConfigService();
/// await configService.init();
///
/// // Enable sync
/// await configService.enableSync(
///   blueskyHandle: 'user.bsky.social',
///   pdsUrl: 'https://pds.example.com',
/// );
/// ```
class ConfigService {
  /// The key used to store configuration in SharedPreferences.
  static const String _configKey = 'app_config';

  static final ConfigService _instance = ConfigService._internal();

  /// Returns the singleton instance of the ConfigService.
  factory ConfigService() => _instance;

  ConfigService._internal();

  SharedPreferences? _prefs;
  AppConfig _config = const AppConfig();

  /// Returns the current application configuration.
  AppConfig get config => _config;

  /// Initializes the ConfigService by loading SharedPreferences and the saved configuration.
  ///
  /// This method must be called before using any other methods of this service.
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
        // If config is corrupted, start with default
        _config = const AppConfig();
      }
    }
  }

  /// Updates the application configuration with new values.
  ///
  /// The new configuration is immediately saved to persistent storage.
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
    await _saveConfig();
  }

  Future<void> _saveConfig() async {
    final configJson = jsonEncode(_config.toJson());
    await _prefs?.setString(_configKey, configJson);
  }

  /// Enables BlueSky synchronization with the provided credentials.
  ///
  /// Parameters:
  /// - [blueskyHandle]: The user's BlueSky handle (e.g., "user.bsky.social")
  /// - [pdsUrl]: The URL of the Personal Data Server
  Future<void> enableSync({
    required String blueskyHandle,
    required String pdsUrl,
  }) async {
    final newConfig = _config.copyWith(
      syncEnabled: true,
      blueskyHandle: blueskyHandle,
      pdsUrl: pdsUrl,
      syncMode: SyncMode.syncEnabled,
    );
    await updateConfig(newConfig);
  }

  /// Disables BlueSky synchronization and sets the mode to local-only.
  Future<void> disableSync() async {
    final newConfig = _config.copyWith(
      syncEnabled: false,
      syncMode: SyncMode.localOnly,
    );
    await updateConfig(newConfig);
  }

  /// Updates the last sync time in the configuration.
  ///
  /// If no time is provided, uses the current time.
  Future<void> updateLastSyncTime([DateTime? time]) async {
    final newConfig = _config.copyWith(lastSyncTime: time ?? DateTime.now());
    await updateConfig(newConfig);
  }

  /// Returns true if synchronization is currently enabled.
  bool get isSyncEnabled => _config.syncEnabled;

  /// Returns true if the sync configuration has valid handle and PDS URL.
  bool get hasValidSyncConfig =>
      _config.blueskyHandle?.isNotEmpty == true &&
      _config.pdsUrl?.isNotEmpty == true;
}
