# BluePills Agent Handbook

This handbook keeps agentic contributors aligned on how the BluePills repo builds, lints, tests, and stays privacy-first. Read it once per session, then keep it open while you work.

## 1. Project Snapshot
- **Stack:** Flutter 3.38.9, Dart 3.x, Material Design 3 UI, sqflite/localstorage persistence, AT Protocol sync.
- **Platforms:** Android, Web/PWA, Linux, Windows, macOS (iOS planned). Ensure code stays platform-neutral when possible.
- **Philosophy:** Local-first and telemetry-free. Never add analytics, crash reporters, or ad SDKs.
- **Key Paths:** `lib/main.dart` bootstraps services; `lib/models/` holds persisted entities; `lib/services/` contains singletons; `lib/screens/` and `lib/widgets/` build UI; `test/` stores unit & widget suites.
- **Scripts Worth Knowing:** `./setup-automation.sh` (dev bootstrap), `./scripts/security-check.sh` (security scan), `.github/workflows/*.yml` (CI reference).

## 2. Tooling & Environment
- Install Flutter 3.38.9 (stable) plus matching Dart SDK; run `flutter doctor` before touching the code.
- Use `flutter pub get` after dependency or branch changes; never commit the `.pub-cache` contents.
- Secrets live in `.env`; copy from `.env.example` and avoid committing real credentials.
- Desktop builds rely on `sqflite_common_ffi`; web relies on `shared_preferences`/`localstorage`. Keep code paths guarded via `kIsWeb` or `Platform` checks when necessary.
- Localization strings come from `AppLocalizations`; do not hardcode text in widgets.

## 3. Build, Lint, and Test Reference
| Command | When to Run | Notes |
| --- | --- | --- |
| `flutter pub get` | After pulling or editing `pubspec.yaml` | Required before builds/tests. |
| `dart run build_runner build --delete-conflicting-outputs` | After editing `json_serializable` models, DTOs, or mocks | Cleans stale generated files. |
| `flutter analyze` | Before pushing or opening PRs | Must be clean; fix warnings instead of suppressing. |
| `flutter test` | Run entire test suite | Widget + unit coverage. |
| `flutter test test/path/to/file_test.dart` | Run a single test file | Use this during focused work or reproductions. |
| `flutter test --coverage` | Generate coverage locally | Outputs `coverage/lcov.info`. |
| `flutter run` | Manual device/web smoke test | Select target device or use `-d chrome`. |
| `./scripts/security-check.sh` | Security sweeps before release | Wraps dependency and secret scanners. |

## 4. Standard Workflow Checklist
1. Sync branch, then run `flutter pub get`.
2. Make minimal, focused edits (honor ASCII-only files unless already Unicode).
3. Update or generate files via `build_runner` whenever models/mocks change.
4. Keep the formatter happy with trailing commas and two-space indents (run `dart format .` if needed).
5. Run `flutter analyze` and the smallest meaningful subset of `flutter test`; finish with the full suite for PRs.
6. Never commit secrets, build artifacts, or generated files outside `lib/generated` equivalents.

## 5. Architecture Notes
- **Services:** `DatabaseHelper`, `ConfigService`, `SyncService`, and friends are singletons initiated in `main.dart`. Access them directly; do not introduce global mutable state elsewhere.
- **State Management:** Stick to `StatefulWidget` + `setState`, optionally combining with `FutureBuilder`/`StreamBuilder`. Avoid adding heavy frameworks unless explicitly requested.
- **Data Flow:** For SQLite, models expose `toMap`/`fromMap`; for sync/JSON, they may use `json_serializable`. Keep both pathways in sync when fields change.
- **Sync:** AT Protocol/BlueSky integration relies on timestamps for conflict resolution. Preserve and propagate `updatedAt` values when editing data or building new sync flows.
- **Notifications & Scheduling:** Use the `timezone` package when dealing with alarms or reminders; do not rely on system-local naive `DateTime` objects.

## 6. Code Style & Formatting
- **Imports:** Order as Dart SDK → Flutter → third-party → `package:bluepills/...`. Always prefer absolute package imports to relative ones. Remove unused imports immediately.
- **Indentation & Width:** Two spaces per indent; target 80 characters per line. Introduce line breaks and trailing commas in widget trees so `dart format` can keep consistent wrapping.
- **Null Safety:** All new APIs must be null-safe. Mark named parameters `required` where appropriate; favor non-nullable fields with sensible defaults.
- **Widgets:** Extract reusable UI into `lib/widgets/`. Keep build methods pure; side effects belong in `initState`, `didChangeDependencies`, or services.
- **Theming:** Honor Material 3 and the app theme. Use provided color/typography tokens rather than ad-hoc styles.
- **Documentation:** Use concise inline comments only when logic is non-obvious. Avoid block comments for simple code.

## 7. Naming & File Organization
- Use `PascalCase` for classes/enums (`Medication`, `SyncService`).
- Use `camelCase` for methods, variables, and parameters (`needsSync`, `fetchMedications`).
- Private members get the leading underscore (`_database`).
- File names stay `snake_case.dart`; keep one primary type per file.
- Keep `lib/widgets` for reusable UI, `lib/screens` for page-level widgets, `lib/services` for singletons, `lib/models` for data contracts, and `test/` mirroring lib structure.

## 8. Async, Errors, and Logging
- Always `await` futures; avoid chaining `.then` except in fluent builders.
- Wrap DB, network, and sync calls in `try/catch`; log failures with `debugPrint` (never `print`).
- Surface user-friendly messages via `ScaffoldMessenger.of(context).showSnackBar` or inline error widgets.
- When rethrowing, use `rethrow` to preserve stack traces. Convert errors to domain-specific failures before they cross service boundaries.
- Clean up resources in `dispose`; cancel timers/streams explicitly.

## 9. Localization & Accessibility
- Fetch strings through `AppLocalizations.of(context)!` and avoid bare literals.
- Pass localized copy down via constructors when building helper widgets.
- Use `Semantics` widgets for critical controls and ensure buttons have descriptive tooltips on desktop/web builds.

## 10. Testing Guidance
- **Unit Tests:** Target services/models; place files under `test/services/...` mirroring lib paths. Use `mockito`-generated mocks and the `@GenerateMocks` pattern.
- **Widget Tests:** Use `testWidgets` with `pumpWidget` plus localized `MaterialApp`. Mock services or provide fake data to keep tests deterministic.
- **Golden/Visual Tests:** Only add when assets stabilize; store artifacts under `test/goldens` if required.
- **Running a single test:** `flutter test test/screens/medication_list_test.dart` (swap path as needed). Use `--plain-name` to filter a single case if necessary.
- **Coverage:** Run `flutter test --coverage` before release branches; upload `lcov.info` to CI when needed.
- Keep tests hermetic: no network or file IO without explicit temp directories.

## 11. Data, Privacy, and Security Rules
- Never introduce analytics, crash reporting, or third-party telemetry. Respect the "privacy-first, local-first" pledge.
- When sync is involved, ensure data leaves the device only when the "Sync Enabled" toggle is true.
- Secure secrets: load from `.env`, and document any new keys inside `.env.example`.
- Run `./scripts/security-check.sh` (or at least `flutter analyze` + dependency scans) before tagging releases.
- Validate user inputs server-side analogues (if any) and sanitize log output so PHI never leaks.

## 12. Copilot / Cursor Rules (from .github/copilot-instructions.md)
- Stay on Flutter 3.38.9; do not bump the SDK without PM approval.
- Use `dart run build_runner build --delete-conflicting-outputs` whenever touching generated models or mocks.
- Favor async/await and avoid blocking calls on the UI thread.
- Handle dates/times through the `timezone` package for reminders/notifications.
- Continue using `AppLocalizations` for every user-visible string; never regress to hardcoded English.
- Configure runtime values through `.env` and documented config services rather than inline constants.

## 13. Contribution Etiquette
- Keep commits scoped; avoid sweeping refactors unless requested.
- Follow the repo's existing git hooks; never bypass them with `--no-verify`.
- When adding dependencies, justify them in PR descriptions and update `pubspec.yaml` plus `pubspec.lock` together.
- Coordinate schema changes with migrations and update any seed/mock data.
- Reference this handbook in PRs to show adherence to guidelines.

## 14. Final Checklist Before Opening a PR
1. Code formatted and warnings fixed (`flutter analyze`).
2. Relevant tests added/updated and executed (`flutter test` + targeted files as needed).
3. Secrets, logs, and temporary files excluded via `.gitignore`.
4. Documentation updated when behavior or commands change (README, docs/*, or this handbook).
5. Screenshots or recordings attached for notable UI changes across phone + desktop breakpoints.

## 15. Useful Flutter Commands
- `flutter devices` lists attached emulators/targets; pick one with `-d` when running or testing.
- `flutter clean` clears build artifacts when you hit stubborn cache issues; re-run `flutter pub get` afterward.
- `flutter pub run flutter_launcher_icons` or similar tool scripts should be invoked from docs—avoid ad-hoc asset tweaks.
- `dart format .` keeps styles consistent; run before large refactors.
- `dart analyze --fatal-infos` can help surface warnings treated as errors in CI.

## 16. Repository Structure Deep Dive
- `assets/` contains localized strings, icons, and configuration payloads that must be referenced via `pubspec.yaml`.
- `docs/` holds contributor guides, deployment notes, and security policies—keep them updated when behavior changes.
- `.github/` houses workflows plus `copilot-instructions.md`; modify workflows cautiously and document changes.
- `scripts/` includes bash helpers such as `setup-automation.sh` and `security-check.sh`; prefer updating scripts over duplicating logic in docs.
- Platform folders (`android/`, `ios/`, `linux/`, etc.) follow Flutter defaults; avoid editing them unless platform-specific bugs require it.

## 17. Platform-Specific Notes
- **Web:** Prefer `shared_preferences`/`localstorage` branches inside services; guard with `kIsWeb` checks to avoid platform exceptions.
- **Desktop:** Ensure `sqflite_common_ffi` initialization happens before DB access; follow existing pattern in `main.dart`.
- **Android/iOS:** Notification/permission changes belong in platform channels plus `android/app/src/main/AndroidManifest.xml` or iOS plist equivalents.
- **Windows/Linux:** Confirm file-system paths use `path_provider`; never assume POSIX-style separators.
- **Accessibility:** Large-screen layouts should respect pointer + keyboard navigation; test with Tab traversal on desktop/web builds.

## 18. Communication & Documentation
- Summarize rationale in PR descriptions: what changed, why, risks, and verification commands.
- Reference issue numbers or product requirements when applicable.
- When adding config keys, update `.env.example`, README sections, and any scripts that depend on them.
- Document migrations or data shape changes under `docs/` so future agents can trace schema history.
- Attach screenshots/gifs for UI shifts covering both phone and desktop breakpoints.

## 19. Support Resources
- Check `README.md` for onboarding steps, feature overviews, and deployment expectations.
- Consult `docs/` subfolders for detailed workflows (e.g., security, automation, store releases).
- Use GitHub Discussions/Issues for any clarifications outside this document; avoid creating TODO comments in production code.
- Keep `AGENTS.md` updated whenever tooling, architecture, or style guidance changes; treat it as living documentation.
- Coordinate with maintainers before altering CI, release automation, or dependency versions.

## 20. Reference Commands & Tips
- `flutter pub outdated` surfaces dependency drift; run before proposing dependency bumps.
- `flutter upgrade` should only be executed after syncing with maintainers; document SDK moves.
- `flutter gen-l10n` regenerates localization delegates if you modify ARB files.
- `dart pub global run pana .` is handy for local package scoring when publishing shared packages.

Keep this document ~150 lines by refreshing content (not fluff) when practices evolve. Happy shipping!
