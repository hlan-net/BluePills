/// Service for interacting with the AT Protocol and BlueSky.
///
/// This library provides functionality for authenticating with BlueSky,
/// syncing medication data using the AT Protocol, and managing remote
/// medication records.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/services/config_service.dart';

/// Singleton service for AT Protocol and BlueSky integration.
///
/// This service handles authentication, fetching, syncing, and deleting
/// medication records on a BlueSky Personal Data Server using the AT Protocol.
///
/// The service maintains JWT tokens for authenticated requests and provides
/// methods for all medication CRUD operations on the remote server.
///
/// Example usage:
/// ```dart
/// final atService = ATProtocolService();
/// await atService.authenticate('user.bsky.social', 'password');
/// final medications = await atService.fetchMedications();
/// ```
class ATProtocolService {
  static final ATProtocolService _instance = ATProtocolService._internal();
  
  /// Returns the singleton instance of the ATProtocolService.
  factory ATProtocolService() => _instance;
  
  ATProtocolService._internal();

  final ConfigService _configService = ConfigService();
  
  /// The JWT access token for authenticated requests.
  String? _accessJwt;
  
  /// The JWT refresh token for obtaining new access tokens.
  String? _refreshJwt;

  /// Authenticates with the BlueSky server using handle and password.
  ///
  /// Returns true if authentication was successful, false otherwise.
  /// Upon successful authentication, stores the access and refresh JWT tokens.
  ///
  /// Parameters:
  /// - [handle]: The user's BlueSky handle
  /// - [password]: The user's password
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

  /// Fetches all medication records from the BlueSky server.
  ///
  /// Returns a list of medications stored on the remote server.
  /// Returns an empty list if there's an error or no medications are found.
  ///
  /// Throws an exception if not authenticated.
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

  /// Syncs a medication to the BlueSky server.
  ///
  /// Creates a new record if the medication doesn't have a remoteId,
  /// or updates an existing record if it does.
  ///
  /// Returns true if the sync was successful, false otherwise.
  ///
  /// Parameters:
  /// - [medication]: The medication to sync
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

  /// Deletes a medication record from the BlueSky server.
  ///
  /// Returns true if the deletion was successful, false otherwise.
  ///
  /// Parameters:
  /// - [remoteId]: The remote ID (rkey) of the medication to delete
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

  /// Refreshes the authentication tokens using the refresh token.
  ///
  /// Should be called when the access token expires. Updates both
  /// the access and refresh tokens if successful.
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

  /// Returns true if the service has a valid access token.
  bool get isAuthenticated => _accessJwt != null;
}
