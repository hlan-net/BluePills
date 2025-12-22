/// Configuration model for BluePills application settings.
///
/// This library defines the application configuration model including
/// BlueSky sync settings and serialization support.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:bluepills/l10n/app_localizations.dart';

part 'app_config.g.dart';

/// Application configuration containing sync and BlueSky integration settings.
///
/// This class stores the user's preferences for data synchronization with
/// BlueSky using the AT Protocol. It supports JSON serialization for
/// persistent storage.
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

  /// The current synchronization mode.
  final SyncMode syncMode;

  /// Whether automatic restore from Google Drive is enabled.
  final bool autoRestoreEnabled;

  /// The selected language code. If null, the device language is used.
  final String? languageCode;

  /// Creates a new [AppConfig] instance with default values.
  ///
  /// By default, sync is disabled and the sync mode is set to [SyncMode.localOnly].
  const AppConfig({
    this.syncEnabled = false,
    this.blueskyHandle,
    this.pdsUrl,
    this.lastSyncTime,
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
  ///
  /// Any field that is provided will replace the existing value.
  /// Fields that are not provided will retain their current values.
  AppConfig copyWith({
    bool? syncEnabled,
    String? blueskyHandle,
    String? pdsUrl,
    DateTime? lastSyncTime,
    SyncMode? syncMode,
    bool? autoRestoreEnabled,
    String? languageCode,
  }) {
    return AppConfig(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      blueskyHandle: blueskyHandle ?? this.blueskyHandle,
      pdsUrl: pdsUrl ?? this.pdsUrl,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncMode: syncMode ?? this.syncMode,
      autoRestoreEnabled: autoRestoreEnabled ?? this.autoRestoreEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

/// Defines the different modes for data synchronization.
///
/// - [localOnly]: Store data only on the local device (no sync)
/// - [syncEnabled]: Store data locally and synchronize with BlueSky
/// - [syncOnly]: Store data only on BlueSky (requires internet connection)
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
