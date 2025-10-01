import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

@JsonSerializable()
class AppConfig {
  final bool syncEnabled;
  final String? blueskyHandle;
  final String? pdsUrl;
  final DateTime? lastSyncTime;
  final SyncMode syncMode;

  const AppConfig({
    this.syncEnabled = false,
    this.blueskyHandle,
    this.pdsUrl,
    this.lastSyncTime,
    this.syncMode = SyncMode.localOnly,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  AppConfig copyWith({
    bool? syncEnabled,
    String? blueskyHandle,
    String? pdsUrl,
    DateTime? lastSyncTime,
    SyncMode? syncMode,
  }) {
    return AppConfig(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      blueskyHandle: blueskyHandle ?? this.blueskyHandle,
      pdsUrl: pdsUrl ?? this.pdsUrl,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncMode: syncMode ?? this.syncMode,
    );
  }
}

enum SyncMode { localOnly, syncEnabled, syncOnly }

extension SyncModeExtension on SyncMode {
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

  String get description {
    switch (this) {
      case SyncMode.localOnly:
        return 'Store data locally on this device only';
      case SyncMode.syncEnabled:
        return 'Store locally and sync with BlueSky';
      case SyncMode.syncOnly:
        return 'Store only on BlueSky (requires internet)';
    }
  }
}
