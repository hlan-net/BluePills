# User Story: Google Drive Backup & Restore

## Description
As a user, I want to use my personal Google Drive to backup my data so that I can restore it on another device or after reinstalling the app.
I also want the app to automatically restore the backup if a newer one is found on startup, with an option to opt-out.

## Acceptance Criteria
1.  **Google Sign-In**: User can sign in/out of their Google account in Settings.
2.  **Manual Backup**: User can manually trigger a backup to Google Drive.
3.  **Manual Restore**: User can manually trigger a restore from Google Drive.
4.  **Automatic Restore**:
    *   On app startup, check for a backup in Google Drive.
    *   If a remote backup exists and is newer than the local data (or local is empty), restore it automatically.
    *   This behavior is enabled by default but can be disabled in Settings.
5.  **Settings UI**:
    *   "Google Drive Backup" section.
    *   "Connect Google Account" button (changes to "Disconnect" + User email when connected).
    *   "Backup Now" button (enabled only when connected).
    *   "Restore Now" button (enabled only when connected).
    *   "Auto-restore from backup" switch (enabled only when connected).
6.  **Data**: Backup should include the SQLite database.

## Technical Notes
*   Use `google_sign_in` for authentication.
*   Use `googleapis` (Drive API v3) for file operations.
*   Store backup in a specific folder (e.g., `appDataFolder` or a named folder in root if `appDataFolder` is too hidden for user visibility - `appDataFolder` is better for privacy/cleanliness).
*   Backup file name: `bluepills_backup.db` (or similar).
*   Metadata: Store timestamp to compare versions.
