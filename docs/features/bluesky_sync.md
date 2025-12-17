# User Story: BlueSky Synchronization

## Description
As a user, I want to synchronize my medication data with my BlueSky account (via AT Protocol) so that I can access my data across multiple devices and have a remote backup in my Personal Data Server (PDS).

## Acceptance Criteria
1.  **Enable Sync**:
    *   User can enable sync in Settings.
    *   Requires entering BlueSky Handle and PDS URL.
2.  **Sync Process**:
    *   **Full Sync**: Can be triggered manually or automatically.
    *   **Upload**: Local changes (creates, updates, deletes) are uploaded to the PDS.
    *   **Download**: Remote changes are downloaded and merged into the local database.
    *   **Conflict Resolution**: Simple "last write wins" or "remote wins if local never synced" logic.
3.  **Sync Status**:
    *   UI indicates sync status (success/error).
    *   Last sync timestamp is displayed in Settings.
4.  **Disable Sync**:
    *   User can disable sync to revert to local-only mode.

## Technical Notes
*   **Protocol**: AT Protocol (atproto).
*   **Services**:
    *   `SyncService`: Orchestrates the sync process (upload/download/merge).
    *   `ATProtocolService`: Handles low-level AT Protocol communication (authentication, record CRUD).
    *   `ConfigService`: Manages sync settings (`AppConfig`).
*   **Data Model**: `Medication` model includes `remoteId`, `lastSynced`, and `needsSync` fields.
*   **Collections**: Uses a specific collection (e.g., `net.hlan.bluepills.medication`) in the user's repository.
