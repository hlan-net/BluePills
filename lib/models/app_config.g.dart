// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
  syncEnabled: json['syncEnabled'] as bool? ?? false,
  blueskyHandle: json['blueskyHandle'] as String?,
  pdsUrl: json['pdsUrl'] as String?,
  lastSyncTime: json['lastSyncTime'] == null
      ? null
      : DateTime.parse(json['lastSyncTime'] as String),
  syncMode:
      $enumDecodeNullable(_$SyncModeEnumMap, json['syncMode']) ??
      SyncMode.localOnly,
  autoRestoreEnabled: json['autoRestoreEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'syncEnabled': instance.syncEnabled,
  'blueskyHandle': instance.blueskyHandle,
  'pdsUrl': instance.pdsUrl,
  'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
  'syncMode': _$SyncModeEnumMap[instance.syncMode]!,
  'autoRestoreEnabled': instance.autoRestoreEnabled,
};

const _$SyncModeEnumMap = {
  SyncMode.localOnly: 'localOnly',
  SyncMode.syncEnabled: 'syncEnabled',
  SyncMode.syncOnly: 'syncOnly',
};
