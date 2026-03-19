/// Configuration model for BluePills application settings.
///
/// This library defines the application configuration model including
/// BlueSky sync settings and serialization support.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:bluepills/l10n/app_localizations.dart';

part 'app_config.g.dart';

/// Application configuration containing sync and BlueSky integration settings.
@JsonSerializable()
class AppConfig {
  /// Whether synchronization with BlueSky is enabled.
  final bool syncEnabled;

  /// The user's BlueSky handle (e.g., "user.bsky.social").
  final String? blueskyHandle;

  /// The URL of the Personal Data Server (PDS) for AT Protocol.
  final String? pdsUrl;

  /// The timestamp of the last successful sync operation.
  final DateTime? lastSyncTime;

  /// The timestamp of the last successful backup operation.
  final DateTime? lastBackupTime;

  /// The current synchronization mode.
  final SyncMode syncMode;

  /// Whether automatic restore from Google Drive is enabled.
  final bool autoRestoreEnabled;

  /// The selected language code. If null, the device language is used.
  final String? languageCode;

  /// Creates a new [AppConfig] instance with default values.
  const AppConfig({
    this.syncEnabled = false,
    this.blueskyHandle,
    this.pdsUrl,
    this.lastSyncTime,
    this.lastBackupTime,
    this.syncMode = SyncMode.localOnly,
    this.autoRestoreEnabled = true,
    this.languageCode,
  });

  /// Creates an [AppConfig] instance from JSON data.
  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  /// Converts this configuration to JSON data.
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  /// Creates a copy of this configuration with optional field updates.
  AppConfig copyWith({
    bool? syncEnabled,
    String? blueskyHandle,
    String? pdsUrl,
    AppConfigTimestamps? timestamps,
    SyncMode? syncMode,
    bool? autoRestoreEnabled,
    String? languageCode,
  }) {
    return AppConfig(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      blueskyHandle: blueskyHandle ?? this.blueskyHandle,
      pdsUrl: pdsUrl ?? this.pdsUrl,
      lastSyncTime: timestamps?.lastSyncTime ?? lastSyncTime,
      lastBackupTime: timestamps?.lastBackupTime ?? lastBackupTime,
      syncMode: syncMode ?? this.syncMode,
      autoRestoreEnabled: autoRestoreEnabled ?? this.autoRestoreEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

/// Holds optional timestamp overrides for [AppConfig.copyWith].
class AppConfigTimestamps {
  /// Updated last successful sync time.
  final DateTime? lastSyncTime;

  /// Updated last backup time.
  final DateTime? lastBackupTime;

  const AppConfigTimestamps({this.lastSyncTime, this.lastBackupTime});
}

/// Defines the different modes for data synchronization.
enum SyncMode { localOnly, syncEnabled, syncOnly }

/// Extension methods for [SyncMode] to provide user-friendly display strings.
extension SyncModeExtension on SyncMode {
  /// Returns a human-readable display name for this sync mode.
  String get displayName {
    switch (this) {
      case SyncMode.localOnly:
        return 'Local Only';
      case SyncMode.syncEnabled:
        return 'Sync Enabled';
      case SyncMode.syncOnly:
        return 'Sync Only';
    }
  }

  /// Returns a detailed description of what this sync mode does.
  String description(AppLocalizations localizations) {
    switch (this) {
      case SyncMode.localOnly:
        return localizations.syncModeLocalOnlyDescription;
      case SyncMode.syncEnabled:
        return localizations.syncModeSyncEnabledDescription;
      case SyncMode.syncOnly:
        return localizations.syncModeSyncOnlyDescription;
    }
  }
}
