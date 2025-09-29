import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluepills/models/app_config.dart';

class ConfigService {
  static const String _configKey = 'app_config';
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  SharedPreferences? _prefs;
  AppConfig _config = const AppConfig();

  AppConfig get config => _config;

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

  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
    await _saveConfig();
  }

  Future<void> _saveConfig() async {
    final configJson = jsonEncode(_config.toJson());
    await _prefs?.setString(_configKey, configJson);
  }

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

  Future<void> disableSync() async {
    final newConfig = _config.copyWith(
      syncEnabled: false,
      syncMode: SyncMode.localOnly,
    );
    await updateConfig(newConfig);
  }

  Future<void> updateLastSyncTime([DateTime? time]) async {
    final newConfig = _config.copyWith(
      lastSyncTime: time ?? DateTime.now(),
    );
    await updateConfig(newConfig);
  }

  bool get isSyncEnabled => _config.syncEnabled;
  bool get hasValidSyncConfig => 
      _config.blueskyHandle?.isNotEmpty == true && 
      _config.pdsUrl?.isNotEmpty == true;
}