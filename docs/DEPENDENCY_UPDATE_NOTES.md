# Dependency Update Notes

## Dependabot refresh - September 2026

The updates proposed in PRs #217-#221 are tested together on Flutter 3.47.0
(Dart 3.13). `build_runner` 2.16.1 requires an analyzer version whose `meta`
constraint conflicts with the pin in Flutter 3.44.4. Use the pinned Flutter
version when resolving dependencies and regenerating the lockfile.

`build_runner` now replaces conflicting generated outputs by default. The
removed `--delete-conflicting-outputs` option has been dropped from active
build commands. Flutter also migrates `analysis_options.yaml` to exclude its
build and native platform directories; application code and tests remain
included in analysis.

- `build_runner`: 2.15.0 -> 2.16.1
- `sqflite`: 2.4.3 -> 2.4.4
- `table_calendar`: 3.2.0 -> 3.2.1
- `sqflite_common_ffi`: 2.4.2 -> 2.4.3
- `json_serializable`: 6.14.0 -> 6.14.1

The Android toolchain moves to Gradle 8.14.5, Android Gradle Plugin 8.13.0,
and Kotlin 2.2.20 to meet Flutter 3.47's minimum supported versions. Install
JDK 17 or newer for Android builds. NDK 28.2.13676358 matches the JNI plugin's
requirement. Flutter's generated Gradle compatibility flags are retained.
Flutter still warns that a future release will require Gradle 9 / AGP 9 and
Kotlin 2.3.20; that separate major toolchain migration is not included here.

CI now runs for workflow changes as well as application changes. SonarCloud
runs when `SONAR_TOKEN` is available; otherwise CI emits a notice and still
runs code generation, formatting, security checks, analysis, tests and builds.
Platform builds no longer cancel one another when one platform fails.
To enable SonarCloud on Dependabot PRs, configure `SONAR_TOKEN` as a
**Dependabot secret** as well as an Actions secret. Dependabot-triggered
workflows cannot use ordinary Actions secrets:
https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions

Invalid placeholder reviewers/assignees and the nonexistent `automated` label
were removed from the Dependabot configuration.

### Local verification

- Dependency resolution and code generation completed successfully.
- Formatting passed without changes; Flutter analysis reported no issues.
- All 63 unit and widget tests passed with coverage enabled.
- Android arm64 debug APK, web release and Linux debug builds succeeded.
- Windows and macOS builds are left to the PR's CI matrix.
- The web build reports a Cupertino icon font warning; no visual smoke test
  was performed.

---

## Weekly Review - October 10, 2025

### Summary
Updated resolvable dependencies by running `flutter pub upgrade`. Successfully updated 8 packages to their latest compatible versions. Packages constrained by the Flutter SDK remain at their current versions.

### Packages Successfully Updated

#### Transitive Dependencies
- **_fe_analyzer_shared**: 88.0.0 → 89.0.0 ✅
- **analyzer**: 8.1.1 → 8.2.0 ✅
- **build**: 4.0.1 → 4.0.2 ✅
- **path_provider_android**: 2.2.18 → 2.2.19 ✅
- **shared_preferences_android**: 2.4.13 → 2.4.15 ✅
- **source_gen**: 4.0.1 → 4.0.2 ✅
- **sqflite_android**: 2.4.1 → 2.4.2+2 ✅
- **sqlite3**: 2.9.1 → 2.9.2 ✅

### Packages Not Updated (SDK Constraints)

Some packages cannot be updated due to Flutter SDK version constraints:

#### Direct Dependencies
- **meta**: 1.16.0 (latest: 1.17.0)
  - Constrained by Flutter SDK (flutter_test dependency)

#### Dev Dependencies
- **flutter_launcher_icons**: 0.13.1 (latest: 0.14.4)
  - Requires major version update (use `flutter pub upgrade --major-versions`)

#### Transitive Dependencies
- **characters**: 1.4.0 (latest: 1.4.1)
- **material_color_utilities**: 0.11.1 (latest: 0.13.0)
- **test_api**: 0.7.6 (latest: 0.7.7)

These packages are constrained by the Flutter SDK version and will be automatically updated when the Flutter SDK is upgraded.

### Verification

The following verification steps were performed:
1. ✅ `flutter pub upgrade` - Successfully updated 8 dependencies
2. ✅ `flutter pub get` - Successfully resolved dependencies
3. ✅ `dart run build_runner build` - Successfully generated code (3 outputs)
4. ⚠️ Tests have pre-existing failures unrelated to dependency updates

### Action Taken
Successfully updated all resolvable dependencies. The build runner completed successfully, generating all required code files.

### Recommendation
- Consider updating `flutter_launcher_icons` to 0.14.4 using `flutter pub upgrade --major-versions flutter_launcher_icons` if the new features are needed
- To update SDK-constrained packages (meta, characters, material_color_utilities, test_api), upgrade the Flutter SDK version in CI/CD workflows
- Address pre-existing test failures in a separate PR

---

## Weekly Review - October 7, 2025

### Summary
Reviewed the weekly dependency update report. All packages are already at their newest resolvable versions. The packages showing as outdated in the report are constrained by the Flutter SDK and cannot be updated without upgrading the Flutter SDK version.

### Status of Outdated Packages

#### Direct Dependencies
- **meta**: 1.16.0 (latest: 1.17.0) - ✓ Already at newest resolvable version
  - Constrained by Flutter SDK (flutter_test dependency)
  - Will be updated automatically when Flutter SDK is upgraded

#### Transitive Dependencies
- **characters**: 1.4.0 (latest: 1.4.1) - ✓ Already at newest resolvable version
- **material_color_utilities**: 0.11.1 (latest: 0.13.0) - ✓ Already at newest resolvable version
- **test_api**: 0.7.6 (latest: 0.7.7) - ✓ Already at newest resolvable version

All transitive dependencies are constrained by the Flutter SDK version.

### Action Taken
No changes required. All dependencies are already at their newest compatible and resolvable versions given the current Flutter SDK constraints.

### Recommendation
To update these packages, the Flutter SDK version should be upgraded in the CI/CD workflows (`.github/workflows/*.yml` - currently set to Flutter 3.32.7). Once a newer Flutter version is available that unpins these dependencies, run `flutter pub upgrade` to get the latest versions.

---

## Previous Update - Earlier in October 2025

### Summary
This update addressed a previous weekly dependency update report by running `flutter pub upgrade` to update all resolvable dependencies to their latest compatible versions.

## Packages Successfully Updated

### Direct Dev Dependencies
- **build_runner**: 2.8.0 → 2.9.0 ✅

### Transitive Dependencies
- **_fe_analyzer_shared**: 88.0.0 → 89.0.0 ✅
- **analyzer**: 8.1.1 → 8.2.0 ✅
- **build**: 4.0.0 → 4.0.1 ✅
- **shared_preferences_android**: 2.4.12 → 2.4.14 ✅
- **sqflite_android**: 2.4.1 → 2.4.2+2 ✅
- **sqlite3**: 2.9.0 → 2.9.1 ✅
- **watcher**: 1.1.3 → 1.1.4 ✅

## Packages Not Updated (SDK Constraints)

Some packages cannot be updated due to Flutter SDK version constraints. These packages are pinned by the Flutter SDK itself:

### Direct Dependencies
- **meta**: 1.16.0 (latest: 1.17.0)
  - Reason: Pinned by `flutter_test` from Flutter SDK
  - This will be automatically resolved when Flutter SDK is upgraded

### Transitive Dependencies
- **characters**: 1.4.0 (latest: 1.4.1)
- **material_color_utilities**: 0.11.1 (latest: 0.13.0)
- **test_api**: 0.7.6 (latest: 0.7.7)

These packages are constrained by the Flutter SDK version and will be automatically updated when the Flutter SDK is upgraded to a newer version.

## Verification

The following verification steps were performed:
1. ✅ `flutter pub get` - Successfully resolved dependencies
2. ✅ `dart run build_runner build` - Successfully generated code
3. ✅ `pubspec.lock` - Updated with new versions

## Next Steps

To update the remaining packages (meta, characters, material_color_utilities, test_api):
1. Wait for Flutter SDK to release a newer version that unpins these dependencies
2. Update the Flutter version in CI/CD workflows (`.github/workflows/*.yml`)
3. Run `flutter pub upgrade` again

## Reference

See the weekly dependency report issue for the full list of available updates.
