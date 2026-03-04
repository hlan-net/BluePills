library;

import 'package:bluepills/services/export_service.dart';
import 'package:bluepills/services/import_service.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/sync_service.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/notifications/notification_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ConfigService _configService = ConfigService();
  final SyncService _syncService = SyncService();
  final BackupService _backupService = BackupService();
  final GoogleDriveService _googleDriveService = GoogleDriveService();
  final ExportService _exportService = ExportService();
  final ImportService _importService = ImportService();

  final _formKey = GlobalKey<FormState>();
  final _handleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pdsController = TextEditingController();

  bool _isGoogleAuthenticated = false;
  String? _googleUser;

  @override
  void initState() {
    super.initState();
    final config = _configService.config;
    _handleController.text = config.blueskyHandle ?? '';
    _pdsController.text = config.pdsUrl ?? 'https://bsky.social';
    _checkGoogleStatus();
  }

  Future<void> _checkGoogleStatus() async {
    final isAuthenticated = await _googleDriveService.isAuthenticated();
    final user = await _googleDriveService.getUserEmail();
    if (mounted) {
      setState(() {
        _isGoogleAuthenticated = isAuthenticated;
        _googleUser = user;
      });
    }
  }

  @override
  void dispose() {
    _handleController.dispose();
    _passwordController.dispose();
    _pdsController.dispose();
    super.dispose();
  }

  void _saveSyncSettings() async {
    if (_formKey.currentState!.validate()) {
      final localizations = AppLocalizations.of(context)!;
      try {
        await _configService.updateSyncConfig(
          syncEnabled: true,
          blueskyHandle: _handleController.text.trim(),
          appPassword: _passwordController.text,
          pdsUrl: _pdsController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.blueskySyncEnabledSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          _passwordController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.failedToEnableSync(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _disableSync() async {
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.disableBlueSkySync),
            content: Text(localizations.disableBlueSkySyncConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(localizations.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  localizations.disable,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _configService.updateSyncConfig(syncEnabled: false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.blueskySyncDisabled)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.failedToDisableSync(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _backupNow() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await _backupService.backup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.backupSuccessful),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.backupFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreNow() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final success = await _backupService.restore();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.restoreSuccessful),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.noBackupFound),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.restoreFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportData() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await _exportService.exportMedications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.dataExportedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.failedToExportData(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await _importService.importMedications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.dataImportedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.failedToImportData(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final config = _configService.config;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // BlueSky Sync Section
          _buildSectionHeader(localizations.blueskySynchronization),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                config.syncEnabled
                    ? Card(
                      color: Colors.green.withValues(alpha: 0.1),
                      child: ListTile(
                        leading: const Icon(Icons.sync, color: Colors.green),
                        title: Text(localizations.status),
                        subtitle: Text(localizations.loggedIn),
                        trailing: TextButton(
                          onPressed: _disableSync,
                          child: Text(localizations.logout),
                        ),
                      ),
                    )
                    : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _handleController,
                            decoration: InputDecoration(
                              labelText: localizations.blueSkyHandle,
                              hintText: localizations.yourHandleBskySocial,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations
                                    .pleaseEnterYourBlueskyHandle;
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: localizations.appPassword,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your app password';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _pdsController,
                            decoration: InputDecoration(
                              labelText: localizations.personalDataServerPDSURL,
                              hintText: localizations.yourPdsExampleCom,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.pleaseEnterYourPDSURL;
                              }
                              if (!value.startsWith('http')) {
                                return localizations.pleaseEnterAValidURL;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _saveSyncSettings,
                            child: Text(localizations.login),
                          ),
                        ],
                      ),
                    ),
          ),
          if (config.syncEnabled)
            ListTile(
              title: Text(localizations.lastSyncedAt),
              subtitle: Text(
                config.lastSyncTime != null
                    ? config.lastSyncTime.toString()
                    : 'Never',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _syncService.performFullSync();
                },
              ),
            ),

          const Divider(),

          // Backup Section
          _buildSectionHeader(localizations.googleDriveBackup),
          if (!_isGoogleAuthenticated)
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: Text(localizations.connectToGoogleDrive),
              onTap: () async {
                await _googleDriveService.authenticate();
                _checkGoogleStatus();
              },
            )
          else
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_done, color: Colors.blue),
                  title: Text(localizations.status),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.loggedIn),
                      if (_googleUser != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _googleUser!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await _googleDriveService.signOut();
                      _checkGoogleStatus();
                    },
                    child: Text(localizations.disconnect),
                  ),
                ),
                ListTile(
                  title: Text(localizations.lastBackupAt),
                  subtitle: Text(
                    config.lastBackupTime != null
                        ? _formatDateTime(config.lastBackupTime!)
                        : 'Never',
                  ),
                  trailing: ElevatedButton(
                    onPressed: _backupNow,
                    child: Text(localizations.backupNow),
                  ),
                ),
                ListTile(
                  title: Text(localizations.restoreFromGoogleDrive),
                  trailing: ElevatedButton(
                    onPressed: _restoreNow,
                    child: Text(localizations.restoreNow),
                  ),
                ),
              ],
            ),

          const Divider(),

          // Data Management Section
          _buildSectionHeader(localizations.dataManagement),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: Text(localizations.exportData),
            onTap: _exportData,
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: Text(localizations.importData),
            onTap: _importData,
          ),

          const Divider(),

          // Language Section
          _buildSectionHeader(localizations.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              initialValue: config.languageCode,
              decoration: InputDecoration(
                labelText: localizations.selectLanguage,
              ),
              items:
                  AppLocalizations.supportedLocales.map((locale) {
                    return DropdownMenuItem<String>(
                      value: locale.languageCode,
                      child: Text(
                        {
                              'en': localizations.english,
                              'fi': localizations.finnish,
                              'sv': localizations.swedish,
                              'de': localizations.german,
                              'es': localizations.spanish,
                            }[locale.languageCode] ??
                            locale.languageCode,
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _configService.updateLanguage(value);
                }
              },
            ),
          ),

          const Divider(),

          // Notification Test Section
          _buildSectionHeader(localizations.notifications),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(localizations.testNotification),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              await NotificationHelper().scheduleNotification(
                id: 999,
                title: 'Test Notification',
                body: 'This is a test notification from BluePills',
                scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
              );
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(content: Text(localizations.notificationSent)),
                );
              }
            },
          ),

          const Divider(),

          // About Section
          _buildSectionHeader(localizations.about),
          ListTile(
            title: Text(localizations.version),
            subtitle: const Text('1.6.1'),
          ),
          ListTile(
            title: Text(localizations.privacyPolicy),
            onTap: () async {
              final url = Uri.parse('https://bluepills.app/privacy');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
