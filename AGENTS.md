# BluePills Agent Guide

This document provides essential information for AI agents working on the BluePills codebase.

## 1. Build, Test, and Lint Commands

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies. |
| `dart run build_runner build --delete-conflicting-outputs` | Generate code (JSON serialization, mocks). Run after modifying models or mocks. |
| `flutter analyze` | Run the linter to check for static analysis issues. |
| `flutter test` | Run all unit and widget tests. |
| `flutter test test/path/to/file_test.dart` | Run tests in a specific file. |
| `flutter test --coverage` | Run tests with coverage reporting. |
| `flutter run` | Build and run the app on a connected device/emulator. |
| `./scripts/security-check.sh` | Run security checks (if available). |

## 2. Project Architecture & Conventions

### Core Philosophy
- **Privacy-First:** User data stays on-device unless "Sync Enabled". **NO analytics or telemetry.**
- **Local-First:** Functional without internet. Data syncs when possible.
- **Cross-Platform:** Android, Web, Linux, Windows, macOS.

### Architecture Patterns
- **State Management:** `StatefulWidget` + `setState` for local UI state.
- **Async UI:** Extensive use of `FutureBuilder` for loading data from DB/Services.
- **Services:** Singleton pattern (e.g., `DatabaseHelper`, `ConfigService`). Accessed directly or via `GetIt` if introduced later (currently direct instance access).
- **Data Layer:** `sqflite` (Mobile/Desktop), `shared_preferences`/`localstorage` (Web).
- **Sync:** AT Protocol (BlueSky) integration with timestamp-based conflict resolution.
- **UI:** Material Design 3 (`useMaterial3: true`).

### File Structure
- `lib/main.dart`: Entry point. Initializes services.
- `lib/models/`: Data models (e.g., `Medication`). Use manual `toMap`/`fromMap` for DB, `json_serializable` for API.
- `lib/services/`: Singleton services (business logic, data access).
- `lib/screens/`: UI screens.
- `lib/widgets/`: Reusable UI components.
- `test/`: Unit and widget tests.

## 3. Code Style Guidelines

### Imports
- **Prefer Absolute Imports:** Use `package:bluepills/...` for internal files.
  ```dart
  import 'package:bluepills/models/medication.dart'; // Good
  // import '../models/medication.dart'; // Avoid
  ```
- **Order:** Dart core -> Flutter -> Third-party -> Internal.

### Formatting & Syntax
- **Indentation:** 2 spaces.
- **Line Length:** 80 characters (standard Dart).
- **Trailing Commas:** Use extensively in widget trees and long argument lists to enforce cleaner formatting.
  ```dart
  Medication(
    name: 'Aspirin',
    dosage: '100mg', // Trailing comma
  );
  ```
- **Null Safety:** Strict null safety. Use `required` for non-nullable named parameters.

### Naming
- **Classes/Enums:** `PascalCase` (e.g., `DatabaseHelper`, `Medication`).
- **Variables/Functions:** `camelCase` (e.g., `insertMedication`, `needsSync`).
- **Private Members:** Prefix with `_` (e.g., `_instance`, `_updateLocale`).
- **Files:** `snake_case` (e.g., `database_helper.dart`).

### Error Handling
- Use `try-catch` blocks for async operations (DB, Network).
- Log errors using `debugPrint` (avoid `print` in production code).
- UI: Show user-friendly errors using `ScaffoldMessenger` (SnackBars).

### Testing
- **Framework:** `flutter_test`, `mockito`.
- **Mocks:** Generate mocks using `build_runner`. Use `@GenerateMocks([ClassToMock])`.
- **Structure:** `setUp` for initialization, `testWidgets` for UI/Integration, `test` for unit logic.

## 4. Copilot/Cursor Specific Rules

*Derived from .github/copilot-instructions.md*

- **Flutter Version:** 3.38.9 (stable).
- **Date Handling:** Use `timezone` package for scheduling.
- **Localization:** Use `AppLocalizations`.
  ```dart
  final localizations = AppLocalizations.of(context)!;
  Text(localizations.myMedications);
  ```
- **Async/Await:** Use extensively for DB/Network.
- **Environment:** Configuration via `.env`.

## 5. Development Workflow
1.  **Analyze:** Understand the task and relevant files.
2.  **Edit:** Make changes adhering to the style above.
3.  **Generate:** If models changed, run `dart run build_runner build --delete-conflicting-outputs`.
4.  **Lint:** Run `flutter analyze` and fix warnings.
5.  **Test:** Run relevant tests using `flutter test path/to/test.dart`.
