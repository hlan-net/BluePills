import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart'; // Import for BehaviorSubject

/// TODO: Replace with your actual Google Cloud Console credentials
/// Create OAuth 2.0 Client IDs for 'Web application' and 'Desktop app'.
/// The Web application Client ID is used for `clientId`.
/// The Desktop app Client Secret is used for `clientSecret` (only for desktop platforms).
const String _kGoogleClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
const String _kGoogleClientSecret = 'YOUR_DESKTOP_CLIENT_SECRET'; // Only for desktop

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
        _currentCredentials = BehaviorSubject<GoogleSignInCredentials?>.seeded(null) {
    _googleSignIn.authenticationState.listen((credentials) {
      _currentCredentials.add(credentials);
    });
  }

  GoogleSignInCredentials? get currentUser => _currentCredentials.value;
  Stream<GoogleSignInCredentials?> get onCurrentUserChanged => _currentCredentials.stream;

  Future<GoogleSignInCredentials?> signIn() async {
    try {
      final credentials = await _googleSignIn.signIn();
      return credentials;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  Future<GoogleSignInCredentials?> signInSilently() async {
    try {
      final credentials = await _googleSignIn.silentSignIn();
      return credentials;
    } catch (e) {
      debugPrint('Error signing in silently: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final credentials = _currentCredentials.value;
    if (credentials == null || credentials.accessToken == null) return null;

    final client = GoogleAuthClient(credentials.accessToken!, credentials.idToken ?? '');
    return drive.DriveApi(client);
  }

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

  Future<void> downloadBackup(String fileId, File targetFile) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not signed in');

    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final sink = targetFile.openWrite();
    await media.stream.pipe(sink);
    await sink.close();
  }
}