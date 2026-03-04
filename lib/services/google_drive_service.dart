/// Service for integrating with Google Drive for backup functionality.
///
/// This library provides Google Drive backup and restore capabilities using
/// the Google Drive API and OAuth 2.0 authentication.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

/// Google Cloud Console OAuth 2.0 credentials for Google Drive integration.
const String _kGoogleClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
const String _kGoogleClientSecret = 'YOUR_DESKTOP_CLIENT_SECRET';

/// HTTP client that adds Google OAuth 2.0 authentication headers to requests.
class GoogleAuthClient extends http.BaseClient {
  final String _accessToken;
  final String _idToken;
  final http.Client _inner;

  GoogleAuthClient(this._accessToken, this._idToken, [http.Client? inner])
    : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    request.headers['X-Identity-Token'] = _idToken;
    return _inner.send(request);
  }
}

/// Singleton service for Google Drive backup and restore operations.
class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveAppdataScope];

  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;

  final GoogleSignIn _googleSignIn;
  final BehaviorSubject<GoogleSignInCredentials?> _currentCredentials;

  GoogleDriveService._internal()
    : _googleSignIn = GoogleSignIn(
        params: GoogleSignInParams(
          clientId: _kGoogleClientId,
          clientSecret: _kGoogleClientSecret,
          scopes: _scopes,
        ),
      ),
      _currentCredentials = BehaviorSubject<GoogleSignInCredentials?>.seeded(
        null,
      ) {
    _googleSignIn.authenticationState.listen((credentials) {
      _currentCredentials.add(credentials);
    });
  }

  /// Returns true if the user is currently authenticated.
  Future<bool> isAuthenticated() async {
    return _currentCredentials.value != null;
  }

  /// Returns the email address of the currently signed-in user.
  Future<String?> getUserEmail() async {
    // Note: The google_sign_in_all_platforms might not directly provide email in credentials
    // For now returning a placeholder or null if not authenticated
    return _currentCredentials.value != null ? 'Google User' : null;
  }

  /// Authenticates the user.
  Future<void> authenticate() async {
    await signIn();
  }

  /// Returns the currently signed-in user's credentials, or null if not signed in.
  GoogleSignInCredentials? get currentUser => _currentCredentials.value;

  /// Stream of authentication state changes.
  Stream<GoogleSignInCredentials?> get onCurrentUserChanged =>
      _currentCredentials.stream;

  /// Signs in the user to their Google account.
  Future<GoogleSignInCredentials?> signIn() async {
    try {
      final credentials = await _googleSignIn.signIn();
      return credentials;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  /// Attempts to sign in silently using cached credentials.
  Future<GoogleSignInCredentials?> signInSilently() async {
    try {
      final credentials = await _googleSignIn.silentSignIn();
      return credentials;
    } catch (e) {
      debugPrint('Error signing in silently: $e');
      return null;
    }
  }

  /// Signs the user out of their Google account.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final credentials = _currentCredentials.value;
    if (credentials == null) return null;

    final client = GoogleAuthClient(
      credentials.accessToken,
      credentials.idToken ?? '',
    );
    return drive.DriveApi(client);
  }

  /// Uploads a database backup file to Google Drive.
  Future<void> uploadBackup(File file) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not signed in');

    final files = await api.files.list(
      q: "name = 'bluepills_backup.db' and 'appDataFolder' in parents",
      spaces: 'appDataFolder',
    );

    final media = drive.Media(file.openRead(), file.lengthSync());
    final driveFile = drive.File()..name = 'bluepills_backup.db';

    if (files.files != null && files.files!.isNotEmpty) {
      final fileId = files.files!.first.id!;
      await api.files.update(driveFile, fileId, uploadMedia: media);
    } else {
      driveFile.parents = ['appDataFolder'];
      await api.files.create(driveFile, uploadMedia: media);
    }
  }

  /// Retrieves metadata for the backup file from Google Drive.
  Future<drive.File?> getBackupMetadata() async {
    final api = await _getDriveApi();
    if (api == null) return null;

    final files = await api.files.list(
      q: "name = 'bluepills_backup.db' and 'appDataFolder' in parents",
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime, size)',
    );

    if (files.files != null && files.files!.isNotEmpty) {
      return files.files!.first;
    }
    return null;
  }

  /// Downloads a backup file from Google Drive to the local device.
  Future<void> downloadBackup(String fileId, File targetFile) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not signed in');

    final media =
        await api.files.get(
              fileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final sink = targetFile.openWrite();
    await media.stream.pipe(sink);
    await sink.close();
  }
}
