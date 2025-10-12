library;

import 'package:bluepills/services/export_service.dart';
import 'package:bluepills/services/import_service.dart';
import 'package:flutter/material.dart';
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

  SettingsScreen({
    super.key,
    ConfigService? configService,
    ExportService? exportService,
    ImportService? importService,
  })  : configService = configService ?? ConfigService(),
        exportService = exportService ?? ExportService(),
        importService = importService ?? ImportService();

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

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
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

    try {
      await widget.configService.enableSync(
        blueskyHandle: _handleController.text.trim(),
        pdsUrl: _pdsUrlController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('BlueSky sync enabled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable sync: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableSync() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable BlueSky Sync'),
        content: const Text(
          'This will disable synchronization with BlueSky. '
          'Your data will remain stored locally. '
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disable'),
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
            const SnackBar(
              content: Text('BlueSky sync disabled'),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to disable sync: $e'),
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
    try {
      await widget.importService.importMedications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data imported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import data: $e'),
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
    try {
      await widget.exportService.exportMedications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.configService.config;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                            'BlueSky Synchronization',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        config.syncMode.description,
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
                          decoration: const InputDecoration(
                            labelText: 'BlueSky Handle',
                            hintText: 'your.handle.bsky.social',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Please enter your BlueSky handle';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pdsUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Personal Data Server (PDS) URL',
                            hintText: 'https://your-pds.example.com',
                            prefixIcon: Icon(Icons.cloud),
                          ),
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Please enter your PDS URL';
                            }
                            final uri = Uri.tryParse(value!);
                            if (uri == null || !uri.hasScheme) {
                              return 'Please enter a valid URL';
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
                                  ? 'Enabling...'
                                  : 'Enable BlueSky Sync',
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _disableSync,
                            icon: const Icon(Icons.sync_disabled),
                            label: const Text('Disable Sync'),
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
                      Text(
                        'Data Management',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _importData,
                            icon: const Icon(Icons.file_upload),
                            label: const Text('Import Data'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _exportData,
                            icon: const Icon(Icons.file_download),
                            label: const Text('Export Data'),
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
                        'About BlueSky Integration',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'BluePills uses the AT Protocol to sync your medication data '
                        'with your personal BlueSky account. This allows you to access '
                        'your medications from any device while maintaining full control '
                        'over your data.',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your medication data will be stored securely on your chosen '
                        'Personal Data Server (PDS) and synchronized across all your devices.',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'License & Legal',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'BluePills is open source software licensed under the MIT License.',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Medical Disclaimer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'This software is for informational purposes only and is not intended to replace professional medical advice, diagnosis, or treatment. Always consult healthcare professionals regarding your medications.',
                              style: TextStyle(fontSize: 12),
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
