# BluePills Copilot Instructions

## Build, Test, and Lint

- **Flutter Version**: Project uses Flutter 3.38.9 (stable channel).
- **Code Generation**: Run `dart run build_runner build --delete-conflicting-outputs` after modifying models in `lib/models/app_config.dart` or other files with `@JsonSerializable` or `@GenerateMocks`.
- **Lint**: Run `flutter analyze` to check for issues.
- **Test**:
  - Run all tests: `flutter test`
  - Run single test file: `flutter test test/path/to/test.dart`
  - Coverage: `flutter test --coverage`
- **Run**: `flutter run` (select device/emulator).
- **Check Security**: Run `./scripts/security-check.sh` (if available per README) or `npm audit` if relevant for web parts.

## Architecture

- **Core Philosophy**: Privacy-first, local-first. Data is stored locally (SQLite/SharedPrefs) and optionally synced to BlueSky (AT Protocol).
- **Data Layer**:
  - **Mobile/Desktop**: Uses `sqflite` (via `sqflite_common_ffi` on desktop) for structured data (medications, logs).
  - **Web**: Uses `localstorage`/`shared_preferences`.
  - **Sync**: `SyncService` handles conflict resolution (timestamp-based) with PDS.
- **State Management**:
  - Uses `StatefulWidget` and `setState` for UI state.
  - Services (e.g., `ConfigService`, `DatabaseHelper`) are Singletons initialized in `main.dart`.
  - `DatabaseHelper` abstracts platform-specific storage.
- **UI Layer**:
  - Material Design 3 (`uses-material-design: true`).
  - Responsive layout for Mobile, Web, and Desktop.
- **Localization**: Uses `flutter_localizations` with `AppLocalizations`.

## Key Conventions

- **Privacy**: **Strictly NO analytics or telemetry.** User data must stay on device unless "Sync Enabled" is active.
- **Code Generation**: `AppConfig` uses `json_serializable`. Core entities like `Medication` may use manual `toMap`/`fromMap` for SQLite compatibility.
- **Async/Await**: extensively used for DB and Network operations.
- **Mocking**: Use `mockito` for unit tests.
- **Dates**: Use `timezone` package for scheduling notifications.
- **Environment**: Configuration via `.env` files (template `.env.example`).
