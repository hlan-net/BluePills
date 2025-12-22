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
import 'package:rxdart/rxdart.dart'; // Import for BehaviorSubject

/// Google Cloud Console OAuth 2.0 credentials for Google Drive integration.
///
/// To use Google Drive backup functionality, you need to:
/// 1. Create OAuth 2.0 Client IDs in Google Cloud Console
/// 2. Create a 'Web application' Client ID for [_kGoogleClientId]
/// 3. Create a 'Desktop app' Client Secret for [_kGoogleClientSecret] (desktop platforms only)
/// 4. Replace the placeholder values below with your actual credentials
const String _kGoogleClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
const String _kGoogleClientSecret =
    'YOUR_DESKTOP_CLIENT_SECRET'; // Only for desktop

/// HTTP client that adds Google OAuth 2.0 authentication headers to requests.
///
/// This client wraps a standard HTTP client and automatically adds the
/// Authorization and X-Identity-Token headers required for Google API requests.
class GoogleAuthClient extends http.BaseClient {
  final String _accessToken;
  final String _idToken;
  final http.Client _inner;

  /// Creates a new [GoogleAuthClient] with the provided OAuth tokens.
  ///
  /// Parameters:
  /// - [accessToken]: The OAuth 2.0 access token
  /// - [idToken]: The OpenID Connect ID token
  /// - [inner]: Optional HTTP client to wrap (defaults to a new [http.Client])
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
///
/// This service manages Google Sign-In authentication and provides methods
/// to backup and restore the BluePills database to/from Google Drive's
/// app data folder. All backups are stored in the private app data folder,
/// which is not accessible to users or other applications.
///
/// Example usage:
/// ```dart
/// final driveService = GoogleDriveService();
///
/// // Sign in to Google
/// final credentials = await driveService.signIn();
///
/// // Upload backup
/// if (credentials != null) {
///   await driveService.uploadBackup(databaseFile);
/// }
/// ```
class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveAppdataScope];

  // Use a lazy singleton pattern
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;

  final GoogleSignIn _googleSignIn;
  final BehaviorSubject<GoogleSignInCredentials?> _currentCredentials;

  GoogleDriveService._internal()
    : _googleSignIn = GoogleSignIn(
        params: GoogleSignInParams(
          clientId: _kGoogleClientId,
          clientSecret: _kGoogleClientSecret, // Required for desktop
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

  /// Returns the currently signed-in user's credentials, or null if not signed in.
  GoogleSignInCredentials? get currentUser => _currentCredentials.value;

  /// Stream of authentication state changes.
  ///
  /// Emits the current user's credentials whenever the sign-in state changes.
  Stream<GoogleSignInCredentials?> get onCurrentUserChanged =>
      _currentCredentials.stream;

  /// Signs in the user to their Google account.
  ///
  /// Shows the Google Sign-In UI and requests permission to access the
  /// Drive app data folder. Returns the user's credentials if successful,
  /// or null if the sign-in was cancelled or failed.
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
  ///
  /// This method tries to authenticate without showing any UI, using
  /// previously saved credentials. Returns the user's credentials if
  /// successful, or null if silent sign-in is not possible.
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
  ///
  /// Clears all cached credentials and revokes access to the app.
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
  ///
  /// The backup is stored in the app's private data folder on Google Drive
  /// with the filename 'bluepills_backup.db'. If a backup already exists,
  /// it will be updated with the new file contents.
  ///
  /// Throws an [Exception] if the user is not signed in.
  ///
  /// Parameters:
  /// - [file]: The database file to upload
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
      // Update existing file
      final fileId = files.files!.first.id!;
      await api.files.update(driveFile, fileId, uploadMedia: media);
    } else {
      // Create new file
      driveFile.parents = ['appDataFolder'];
      await api.files.create(driveFile, uploadMedia: media);
    }
  }

  /// Retrieves metadata for the backup file from Google Drive.
  ///
  /// Returns information about the backup including its ID, name, modification
  /// time, and size. Returns null if no backup exists or the user is not signed in.
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
  ///
  /// Retrieves the backup file with the specified ID from Google Drive
  /// and saves it to the target file location.
  ///
  /// Throws an [Exception] if the user is not signed in.
  ///
  /// Parameters:
  /// - [fileId]: The Google Drive file ID of the backup
  /// - [targetFile]: The local file where the backup will be saved
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
