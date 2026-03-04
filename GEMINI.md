# GEMINI.md - BluePills Development Context

This file provides essential instructional context for AI agents working on the BluePills project.

## 🚀 Project Overview

**BluePills** is a privacy-focused, local-first medication management application built with **Flutter**. It allows users to track medications, set reminders, and optionally synchronize data across devices using the **BlueSky AT Protocol** or **Google Drive**.

-   **Main Technologies:** Flutter (3.8+), Dart, SQLite (via `sqflite`), AT Protocol, Google Drive API.
-   **Architecture:** Layer-based architecture with models, services, database adapters (mobile/web), and Material Design 3 UI.
-   **Key Philosophies:** Privacy-first, offline-first, decentralized sync, multi-platform support.

## 🛠️ Building and Running

### Prerequisites
-   Flutter SDK (3.8 or higher)
-   Dart SDK

### Key Commands
-   **Initialize Project:** `flutter pub get`
-   **Code Generation:** `dart run build_runner build` (Essential for JSON serialization and mocks)
-   **Run Application:** `flutter run` (Supports `-d chrome`, `-d linux`, etc.)
-   **Run Tests:** `flutter test`
-   **Automated Setup:** `./setup-automation.sh`
-   **Security Check:** `./scripts/security-check.sh`

## 📂 Project Structure

-   `lib/models/`: Core data entities (`Medication`, `MedicationLog`, `FrequencyPattern`).
-   `lib/services/`: Business logic for sync (`SyncService`), AT Protocol (`AtProtocolService`), backup (`BackupService`, `GoogleDriveService`), and configuration (`ConfigService`).
-   `lib/database/`: Cross-platform storage layer using an adapter pattern (`MobileDatabaseAdapter` vs. `WebDatabaseAdapter`).
-   `lib/notifications/`: Local notification management.
-   `lib/screens/` & `lib/widgets/`: Material 3 UI components.
-   `docs/`: Comprehensive documentation including a detailed `ROADMAP.md` and user stories.

## ⚖️ Development Conventions

-   **Linting:** Adheres to standard `flutter_lints` as defined in `analysis_options.yaml`.
-   **Testing:** Uses `mockito` for service mocking. Always run `flutter test` before submitting changes.
-   **State Management:** Currently uses basic `StatefulWidget` and service-based state (e.g., `ConfigService` singleton).
-   **Sync Strategy:** Local-first with timestamp-based conflict resolution. Metadata (`remoteId`, `lastSynced`, `needsSync`) is tracked per medication.
-   **Localization:** Supports multiple languages (English, Finnish, Swedish, German, Spanish). Use `AppLocalizations` for all UI strings.
-   **Assets:** Icons and images are located in `assets/`. Use `flutter_launcher_icons` and `flutter_native_splash` for branding.

## 🎯 Current Focus (Roadmap)
-   Improving "Today's Medications" dashboard.
-   Enhancing complex prescription patterns.
-   Refining low-stock and expiration warnings.
-   Implementing adherence history tracking.

---
*Note: This file is intended for AI assistance. Always verify commands and paths against the current state of the repository.*
