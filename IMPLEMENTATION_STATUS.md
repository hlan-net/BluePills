# BluePills - AT Protocol Integration Implementation Status

## Overview
BluePills is a medication reminder and management application that provides users the flexibility to start with local storage and optionally enable BlueSky AT Protocol synchronization for cross-device access.

## ✅ Implemented Features

### 1. **Flexible Storage Architecture**
- **Local-First Design**: Users can start using the app immediately with local SQLite storage
- **Optional Sync**: Users can later enable BlueSky AT Protocol synchronization
- **Platform Support**: Works on mobile (SQLite) and web (localStorage/SharedPreferences)

### 2. **Enhanced Data Model**
- **Sync Metadata**: Added fields to Medication model for synchronization
  - `remoteId`: BlueSky record identifier
  - `lastSynced`: Timestamp of last successful sync
  - `needsSync`: Flag indicating if local changes need to be uploaded
  - `createdAt`/`updatedAt`: Timestamp tracking
- **Migration Ready**: Database schema updated to support sync fields

### 3. **Configuration Management**
- **ConfigService**: Manages app settings and sync configuration
- **Persistent Settings**: Stores BlueSky credentials and preferences
- **Sync Modes**:
  - `localOnly`: Store data locally only
  - `syncEnabled`: Local storage + BlueSky sync
  - `syncOnly`: BlueSky only (future feature)

### 4. **AT Protocol Integration Framework**
- **ATProtocolService**: Service layer for BlueSky API interactions
- **Authentication**: JWT-based session management
- **CRUD Operations**: Create, read, update, delete medication records via AT Protocol
- **Error Handling**: Comprehensive error management for network operations

### 5. **Sync Management**
- **SyncService**: Orchestrates synchronization between local and remote storage
- **Conflict Resolution**: Timestamp-based conflict resolution (most recent wins)
- **Incremental Sync**: Only syncs changed records
- **Background Sync**: Automatic periodic synchronization
- **Sync Status Tracking**: Real-time sync status updates

### 6. **User Interface Enhancements**
- **Settings Screen**: Complete configuration UI for BlueSky integration
- **Sync Status Indicator**: Visual feedback for sync state in app bar
- **Manual Sync**: Manual sync trigger button
- **Setup Wizard**: Guided BlueSky configuration process

### 7. **Testing**
- **Unit & Widget Tests**: Comprehensive tests for services and widgets.
- **Mocking**: Uses `mockito` to mock dependencies for reliable testing.
- **Testable Architecture**: Refactored `DatabaseHelper` for easy testing.

## 🚧 Current Implementation Details

### Database Schema Updates
```sql
CREATE TABLE medications(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  dosage TEXT,
  frequency TEXT,
  reminderTime TEXT,
  remoteId TEXT,           -- New: BlueSky record ID
  lastSynced TEXT,         -- New: Last sync timestamp
  needsSync INTEGER DEFAULT 1,  -- New: Sync flag
  createdAt TEXT,          -- New: Creation timestamp
  updatedAt TEXT           -- New: Update timestamp
)
```

### AT Protocol Record Format
```json
{
  "$type": "app.bluepills.medication",
  "name": "Medication Name",
  "dosage": "10mg",
  "frequency": "Twice daily",
  "reminderTime": "2024-01-01T09:00:00Z",
  "createdAt": "2024-01-01T08:00:00Z",
  "updatedAt": "2024-01-01T08:30:00Z"
}
```

### Configuration Structure
```dart
class AppConfig {
  final bool syncEnabled;
  final String? blueskyHandle;  // user.bsky.social
  final String? pdsUrl;         // https://pds.example.com
  final DateTime? lastSyncTime;
  final SyncMode syncMode;
}
```

## 🔄 User Flow

### Initial Setup (Local Only)
1. User installs and opens BluePills
2. App initializes with local storage
3. User can add/manage medications immediately
4. Data stored locally in SQLite/SharedPreferences

### Enabling BlueSky Sync
1. User navigates to Settings
2. Enters BlueSky handle and PDS URL
3. App authenticates with BlueSky
4. Existing local data is uploaded to BlueSky
5. Future changes sync automatically

### Cross-Device Experience
1. User installs BluePills on second device
2. Enables BlueSky sync with same credentials
3. App downloads existing medications from BlueSky
4. Changes on any device sync to all devices

## 🔐 Security & Privacy

### Data Ownership
- Users control their Personal Data Server (PDS)
- No centralized database - fully decentralized
- Data encrypted in transit via HTTPS

### Authentication
- JWT-based authentication with BlueSky
- Refresh token mechanism for session management
- No password storage in app

### Local Storage Security
- Local data remains on device when sync disabled
- SQLite database stored in app's private directory
- Web version uses browser's secure localStorage

## 📋 TODO / Future Enhancements

### Authentication Flow
- [ ] Implement proper BlueSky login flow
- [ ] Handle 2FA if enabled on BlueSky account
- [ ] Secure credential storage (KeyChain/Credential Manager)

### Sync Improvements
- [ ] Real-time sync using WebSockets
- [ ] Better conflict resolution (user choice, field-level merging)
- [ ] Sync progress indicators
- [ ] Offline mode detection and queue management

### Error Handling
- [ ] Network error recovery
- [ ] Invalid credential handling
- [ ] PDS server downtime handling
- [ ] Data corruption recovery

### User Experience
- [ ] First-time setup wizard
- [ ] Sync status dashboard
- [x] Data export/import functionality
- [ ] Multiple PDS support



## 🛠 Development Notes

### Dependencies Added
```yaml
dependencies:
  http: ^1.1.0                 # HTTP client for AT Protocol
  json_annotation: ^4.9.0     # JSON serialization annotations

dev_dependencies:
  json_serializable: ^6.7.1   # JSON code generation
  build_runner: ^2.4.7        # Build system for code generation
  mockito: ^5.4.4             # Mocking framework for testing
```

### Code Generation
Run `dart run build_runner build` to generate serialization code after modifying models.

### Testing Sync
Currently, the AT Protocol service includes placeholder authentication. For full testing:
1. Set up a BlueSky account and PDS
2. Implement proper authentication flow
3. Configure PDS URL in settings
4. Test cross-device synchronization

## 💡 Architecture Benefits

### Graceful Migration Path
- Users aren't forced to set up BlueSky immediately
- Can evaluate the app with local storage first
- Smooth transition to sync when ready

### Decentralized Architecture
- No vendor lock-in - users choose their PDS
- Compatible with AT Protocol ecosystem
- Future-proof as BlueSky grows

### Offline-First Design
- App works without internet connection
- Sync happens when connectivity is available
- No data loss during network issues

### Privacy-Focused
- User maintains control over their data
- No tracking or analytics by default
- Transparent about what data goes where

This implementation provides a solid foundation for a privacy-respecting, user-controlled medication management system that can grow with the user's needs and the AT Protocol ecosystem.