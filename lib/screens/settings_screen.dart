library;

import 'package:bluepills/services/export_service.dart';
import 'package:bluepills/services/import_service.dart';
import 'package:bluepills/services/google_drive_service.dart';
import 'package:bluepills/services/backup_service.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/models/app_config.dart';

/// A stateful widget that displays the settings screen.
///
/// Allows users to configure BlueSky synchronization settings including
/// their BlueSky handle, Personal Data Server URL, and sync mode.
/// Also displays license and medical disclaimer information.
class SettingsScreen extends StatefulWidget {
  final ConfigService configService;
  final ExportService exportService;
  final ImportService importService;
  final GoogleDriveService driveService;
  final BackupService backupService;

  SettingsScreen({
    super.key,
    ConfigService? configService,
    ExportService? exportService,
    ImportService? importService,
    GoogleDriveService? driveService,
    BackupService? backupService,
  }) : configService = configService ?? ConfigService(),
       exportService = exportService ?? ExportService(),
       importService = importService ?? ImportService(),
       driveService = driveService ?? GoogleDriveService(),
       backupService = backupService ?? BackupService();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/// State class for the settings screen.
///
/// Manages form validation, configuration updates, and UI state
/// for enabling/disabling BlueSky synchronization.
class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _handleController = TextEditingController();
  final _pdsUrlController = TextEditingController();
  bool _isLoading = false;

  GoogleSignInCredentials? _googleUser;
  bool _isBackupLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
    widget.driveService.onCurrentUserChanged.listen((
      GoogleSignInCredentials? account,
    ) {
      setState(() {
        _googleUser = account;
      });
    });
    widget.driveService.signInSilently();
  }

  @override
  void dispose() {
    _handleController.dispose();
    _pdsUrlController.dispose();
    super.dispose();
  }

  void _loadCurrentConfig() {
    final config = widget.configService.config;
    _handleController.text = config.blueskyHandle ?? '';
    _pdsUrlController.text = config.pdsUrl ?? '';
  }

  Future<void> _enableSync() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final localizations = AppLocalizations.of(context)!;

    try {
      await widget.configService.enableSync(
        blueskyHandle: _handleController.text.trim(),
        pdsUrl: _pdsUrlController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.blueskySyncEnabledSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
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
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableSync() async {
    final localizations = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.disableBlueSkySync),
        content: Text(localizations.disableBlueSkySyncConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.disable),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await widget.configService.disableSync();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.blueskySyncDisabled),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {});
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
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _importData() async {
    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context)!;
    try {
      await widget.importService.importMedications();
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
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportData() async {
    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context)!;
    try {
      await widget.exportService.exportMedications();
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
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _connectGoogle() async {
    setState(() => _isBackupLoading = true);
    try {
      await widget.driveService.signIn();
    } finally {
      setState(() => _isBackupLoading = false);
    }
  }

  Future<void> _disconnectGoogle() async {
    setState(() => _isBackupLoading = true);
    try {
      await widget.driveService.signOut();
    } finally {
      setState(() => _isBackupLoading = false);
    }
  }

  Future<void> _backupToDrive() async {
    setState(() => _isBackupLoading = true);
    final localizations = AppLocalizations.of(context)!;
    try {
      await widget.backupService.backup();
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
    } finally {
      setState(() => _isBackupLoading = false);
    }
  }

  Future<void> _restoreFromDrive() async {
    setState(() => _isBackupLoading = true);
    final localizations = AppLocalizations.of(context)!;
    try {
      final success = await widget.backupService.restore();
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
    } finally {
      setState(() => _isBackupLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.configService.config;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.sync,
                            color: config.syncEnabled
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.blueskySynchronization,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        config.syncMode.description(localizations),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (config.syncEnabled) ...[
                        _buildSyncStatusInfo(config),
                        const SizedBox(height: 16),
                      ],
                      if (!config.syncEnabled) ...[
                        TextFormField(
                          controller: _handleController,
                          decoration: InputDecoration(
                            labelText: localizations.blueskyHandle,
                            hintText: localizations.yourHandleBskySocial,
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return localizations.pleaseEnterYourBlueskyHandle;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pdsUrlController,
                          decoration: InputDecoration(
                            labelText: localizations.personalDataServerPDSURL,
                            hintText: localizations.yourPdsExampleCom,
                            prefixIcon: const Icon(Icons.cloud),
                          ),
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return localizations.pleaseEnterYourPDSURL;
                            }
                            final uri = Uri.tryParse(value!);
                            if (uri == null || !uri.hasScheme) {
                              return localizations.pleaseEnterAValidURL;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _enableSync,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.sync),
                            label: Text(
                              _isLoading
                                  ? localizations.enabling
                                  : localizations.enableBlueSkySync,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _disableSync,
                            icon: const Icon(Icons.sync_disabled),
                            label: Text(localizations.disableSync),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.backup,
                                  color: _googleUser != null
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    localizations.googleDriveBackup,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _googleUser != null,
                            onChanged: (bool value) {
                              if (value) {
                                _connectGoogle();
                              } else {
                                _disconnectGoogle();
                              }
                            },
                          ),
                        ],
                      ),
                      if (_googleUser != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          localizations.connectedAs(
                            _googleUser!.idToken != null
                                ? "User with ID Token"
                                : "User (No ID Token)",
                          ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: Text(localizations.autoRestoreFromBackup),
                          subtitle: Text(
                            localizations.restoreNewerBackupOnStartup,
                          ),
                          value: config.autoRestoreEnabled,
                          onChanged: (value) async {
                            await widget.configService.updateConfig(
                              config.copyWith(autoRestoreEnabled: value),
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isBackupLoading
                                  ? null
                                  : _backupToDrive,
                              icon: const Icon(Icons.cloud_upload),
                              label: Text(localizations.backupNow),
                            ),
                            ElevatedButton.icon(
                              onPressed: _isBackupLoading
                                  ? null
                                  : _restoreFromDrive,
                              icon: const Icon(Icons.cloud_download),
                              label: Text(localizations.restoreNow),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isBackupLoading
                                ? null
                                : _disconnectGoogle,
                            icon: const Icon(Icons.logout),
                            label: Text(localizations.disconnect),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.dataManagement,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _importData,
                            icon: const Icon(Icons.file_upload),
                            label: Text(localizations.importData),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _exportData,
                            icon: const Icon(Icons.file_download),
                            label: Text(localizations.exportData),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.language,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: config.languageCode ?? '',
                        decoration: InputDecoration(
                          labelText: localizations.appLanguage,
                          prefixIcon: const Icon(Icons.language),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(localizations.deviceLanguage),
                          ),
                          ...AppLocalizations.supportedLocales.map((locale) {
                            return DropdownMenuItem(
                              value: locale.languageCode,
                              child: Text(
                                {
                                  'en': localizations.english,
                                  'fi': localizations.finnish,
                                  'sv': localizations.swedish,
                                  'de': localizations.german,
                                  'es': localizations.spanish,
                                }[locale.languageCode]!,
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) async {
                          await widget.configService.updateConfig(
                            config.copyWith(languageCode: value),
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.aboutBlueSkyIntegration,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(localizations.aboutBlueSkyIntegrationDescription),
                      const SizedBox(height: 8),
                      Text(
                        localizations.aboutBlueSkyIntegrationDescription2,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        localizations.licenseAndLegal,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.mitLicense,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.medicalDisclaimer,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations.medicalDisclaimerDescription,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusInfo(AppConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text('Handle: ${config.blueskyHandle ?? 'Not set'}'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.cloud, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(child: Text('PDS: ${config.pdsUrl ?? 'Not set'}')),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.schedule, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Last sync: ${config.lastSyncTime != null ? _formatDateTime(config.lastSyncTime!) : 'Never'}',
            ),
          ],
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
