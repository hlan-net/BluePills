import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/services/config_service.dart';

class ATProtocolService {
  static final ATProtocolService _instance = ATProtocolService._internal();
  factory ATProtocolService() => _instance;
  ATProtocolService._internal();

  final ConfigService _configService = ConfigService();
  String? _accessJwt;
  String? _refreshJwt;

  Future<bool> authenticate(String handle, String password) async {
    try {
      final config = _configService.config;
      if (config.pdsUrl == null) {
        throw Exception('PDS URL not configured');
      }

      final response = await http.post(
        Uri.parse('${config.pdsUrl}/xrpc/com.atproto.server.createSession'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': handle, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessJwt = data['accessJwt'];
        _refreshJwt = data['refreshJwt'];
        return true;
      } else {
        throw Exception('Authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    }
  }

  Future<List<Medication>> fetchMedications() async {
    try {
      if (_accessJwt == null) {
        throw Exception('Not authenticated');
      }

      final config = _configService.config;
      final response = await http.get(
        Uri.parse('${config.pdsUrl}/xrpc/com.atproto.repo.listRecords').replace(
          queryParameters: {
            'repo': config.blueskyHandle,
            'collection': 'app.bluepills.medication',
          },
        ),
        headers: {
          'Authorization': 'Bearer $_accessJwt',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['records'] as List;

        return records.map((record) {
          final medication = _parseATProtoRecord(record);
          return medication;
        }).toList();
      } else {
        throw Exception('Failed to fetch medications: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch medications error: $e');
      return [];
    }
  }

  Future<bool> syncMedication(Medication medication) async {
    try {
      if (_accessJwt == null) {
        throw Exception('Not authenticated');
      }

      final config = _configService.config;
      final record = _buildATProtoRecord(medication);

      final response = await http.post(
        Uri.parse('${config.pdsUrl}/xrpc/com.atproto.repo.putRecord'),
        headers: {
          'Authorization': 'Bearer $_accessJwt',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'repo': config.blueskyHandle,
          'collection': 'app.bluepills.medication',
          'rkey': medication.remoteId ?? _generateRKey(),
          'record': record,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update medication with remote ID if this was a new record
        medication.remoteId ??= data['uri']?.split('/').last;
        return true;
      } else {
        throw Exception('Failed to sync medication: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sync medication error: $e');
      return false;
    }
  }

  Future<bool> deleteMedication(String remoteId) async {
    try {
      if (_accessJwt == null) {
        throw Exception('Not authenticated');
      }

      final config = _configService.config;
      final response = await http.post(
        Uri.parse('${config.pdsUrl}/xrpc/com.atproto.repo.deleteRecord'),
        headers: {
          'Authorization': 'Bearer $_accessJwt',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'repo': config.blueskyHandle,
          'collection': 'app.bluepills.medication',
          'rkey': remoteId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Delete medication error: $e');
      return false;
    }
  }

  Map<String, dynamic> _buildATProtoRecord(Medication medication) {
    return {
      '\$type': 'app.bluepills.medication',
      'name': medication.name,
      'dosage': medication.dosage,
      'frequency': medication.frequency,
      'reminderTime': medication.reminderTime.toIso8601String(),
      'createdAt': medication.createdAt.toIso8601String(),
      'updatedAt': medication.updatedAt.toIso8601String(),
    };
  }

  Medication _parseATProtoRecord(Map<String, dynamic> record) {
    final value = record['value'];
    return Medication(
      remoteId: record['uri']?.split('/').last,
      name: value['name'],
      dosage: value['dosage'],
      frequency: value['frequency'],
      reminderTime: DateTime.parse(value['reminderTime']),
      createdAt: DateTime.parse(value['createdAt']),
      updatedAt: DateTime.parse(value['updatedAt']),
      needsSync: false, // Just fetched from remote
      lastSynced: DateTime.now(),
    );
  }

  String _generateRKey() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> refreshToken() async {
    if (_refreshJwt == null) return;

    try {
      final config = _configService.config;
      final response = await http.post(
        Uri.parse('${config.pdsUrl}/xrpc/com.atproto.server.refreshSession'),
        headers: {
          'Authorization': 'Bearer $_refreshJwt',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessJwt = data['accessJwt'];
        _refreshJwt = data['refreshJwt'];
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }

  bool get isAuthenticated => _accessJwt != null;
}
