import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveAppdataScope];
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
  
  Stream<GoogleSignInAccount?> get onCurrentUserChanged => _googleSignIn.onCurrentUserChanged;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('Error signing in silently: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return null;
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
