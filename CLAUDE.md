# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | Install dependencies |
| `dart run build_runner build --delete-conflicting-outputs` | Generate code (JSON serialization, mocks). Run after modifying `@JsonSerializable` or `@GenerateMocks` annotations. |
| `flutter analyze` | Lint / static analysis |
| `flutter test` | Run all tests |
| `flutter test test/path/to/file_test.dart` | Run a single test file |
| `flutter test --coverage` | Tests with coverage report |
| `flutter run` | Run app on connected device/emulator |

**Flutter version:** 3.38.9 (stable)

## Architecture

**BluePills** is a privacy-focused medication tracker built with Flutter. Data is stored locally and optionally synced via BlueSky's AT Protocol.

### Core Principles
- **Privacy-first:** NO analytics or telemetry. Data stays on-device unless user explicitly enables sync.
- **Local-first:** Fully functional offline. Sync is opt-in.
- **Cross-platform:** Android, Web, Linux, Windows, macOS from a single codebase.

### Data Layer
- **Mobile/Desktop:** `sqflite` (SQLite via `sqflite_common_ffi` on desktop)
- **Web:** `shared_preferences` / `localstorage`
- **Abstraction:** `DatabaseHelper` singleton detects platform (`kIsWeb`) and delegates to the appropriate adapter (`mobile_database_adapter.dart` or `web_database_adapter.dart`)

### State & Services
- **State management:** `StatefulWidget` + `setState` (no Provider/Riverpod)
- **Async UI:** `FutureBuilder` for DB/network operations
- **Services:** Singleton pattern with `factory` constructor returning `_instance` (e.g., `ConfigService`, `DatabaseHelper`, `SyncService`)
- **Sync:** AT Protocol integration with timestamp-based conflict resolution via `SyncService`

### Key Directories
- `lib/models/` — Data models. `Medication` uses manual `toMap`/`fromMap` for SQLite; `AppConfig` uses `@JsonSerializable`
- `lib/services/` — Singleton business logic services
- `lib/database/` — Storage abstraction layer (adapter pattern)
- `lib/screens/` — UI pages
- `lib/widgets/` — Reusable components
- `lib/l10n/` — Localization (en, fi, sv, de, es)
- `test/` — Unit and widget tests (`flutter_test` + `mockito`)

## Code Style

- **Imports:** Use absolute `package:bluepills/...` imports. Order: Dart core → Flutter → Third-party → Internal.
- **Formatting:** 2-space indent, 80-char line length, trailing commas in widget trees.
- **Naming:** `PascalCase` classes, `camelCase` functions/variables, `_prefix` privates, `snake_case` files.
- **Error handling:** `try-catch` with `debugPrint` (not `print`). User-facing errors via `ScaffoldMessenger` SnackBars.
- **Localization:** Always use `AppLocalizations.of(context)!` for user-visible strings.
- **Dates:** Use the `timezone` package for notification scheduling.

## Development Workflow

1. Make changes following conventions above
2. If models changed: `dart run build_runner build --delete-conflicting-outputs`
3. `flutter analyze` — fix any warnings
4. `flutter test` — run relevant tests
