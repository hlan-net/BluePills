# Automated Version Code Management

## How It Works

The deployment workflow now **automatically increments the version code** based on the GitHub workflow run number. You no longer need to manually bump the version in `pubspec.yaml` before each deployment!

## Version Number Format

**Format:** `MAJOR.MINOR.PATCH+BUILD_NUMBER`

Example: `1.1.2+5`

- **1.1.2** = Version name (user-visible, manually set in pubspec.yaml)
- **+5** = Build number (automatically calculated at build time)

## Automatic Build Number Calculation

The workflow calculates the build number as:

```
BUILD_NUMBER = BASE_VERSION + GITHUB_RUN_NUMBER
```

Where:
- **BASE_VERSION** = The build number from `pubspec.yaml` (currently 5)
- **GITHUB_RUN_NUMBER** = Increments with each workflow run (starts at 1)

### Example:

If `pubspec.yaml` has `version: 1.1.2+5`:
- Workflow run #1 → Build number = 5 + 1 = **6**
- Workflow run #2 → Build number = 5 + 2 = **7**
- Workflow run #3 → Build number = 5 + 3 = **8**

## Benefits

✅ **No manual version bumps** - Just run the workflow
✅ **No conflicts** - Each run gets a unique version code
✅ **Predictable** - Build numbers always increase
✅ **Simple** - Only update version name when releasing

## When to Update pubspec.yaml

You only need to update `pubspec.yaml` when you want to **change the version name** (the user-visible version):

### Bug Fix Release
```yaml
# Change from 1.1.2+5 to 1.1.3+5
version: 1.1.3+5
```

### Minor Release (New Features)
```yaml
# Change from 1.1.3+5 to 1.2.0+5
version: 1.2.0+5
```

### Major Release (Breaking Changes)
```yaml
# Change from 1.2.0+5 to 2.0.0+5
version: 2.0.0+5
```

The build number part (+5) stays the same in the file - the workflow will add the run number automatically.

## Workflow Usage

### Deploy Current Version
Just run the workflow - no code changes needed:

```bash
gh workflow run deploy.yml -f deploy_android=true -f deploy_web=false -f track=internal
```

Each run automatically gets the next build number.

### Deploy New Version
1. Update version name in `pubspec.yaml`:
   ```yaml
   version: 1.2.0+5  # Changed from 1.1.2+5
   ```
2. Commit and push
3. Run the workflow

## Understanding Run Numbers

GitHub Actions maintains a run counter for each workflow:
- Starts at 1 when workflow is first created
- Increments by 1 for each execution
- Never resets (even if you delete workflow runs)
- Unique per repository workflow

You can see the run number in:
- GitHub Actions UI: "Run #123"
- Workflow logs: Available as `${{ github.run_number }}`

## Version History Example

| Workflow Run | pubspec.yaml | GitHub Run # | Final Build | User Sees |
|--------------|--------------|--------------|-------------|-----------|
| 1            | 1.1.2+5      | 1            | 6           | 1.1.2     |
| 2            | 1.1.2+5      | 2            | 7           | 1.1.2     |
| 3            | 1.1.3+5      | 3            | 8           | 1.1.3     |
| 4            | 1.1.3+5      | 4            | 9           | 1.1.3     |
| 5            | 2.0.0+5      | 5            | 10          | 2.0.0     |

## Play Console View

In Google Play Console, each release shows:
- **Version name**: 1.1.2 (from pubspec.yaml)
- **Version code**: 6 (calculated: 5 + 1)

Users only see the version name (1.1.2) in the app store and app info screen.

## Advantages Over Manual Bumping

### Before (Manual)
```
1. Edit pubspec.yaml: 1.1.2+5 → 1.1.2+6
2. Commit and push
3. Run workflow
4. Edit pubspec.yaml: 1.1.2+6 → 1.1.2+7
5. Commit and push
6. Run workflow
```

### Now (Automatic)
```
1. Run workflow (gets build 6)
2. Run workflow (gets build 7)
3. Run workflow (gets build 8)
```

## Best Practices

### ✅ Good: Update version name for releases
```yaml
# Release 1.2.0
version: 1.2.0+5
```
Commit, push, run workflow

### ✅ Good: Keep deploying same version
```bash
# No code changes needed
gh workflow run deploy.yml
```
Each run gets unique build number automatically

### ❌ Bad: Manually changing build number in pubspec.yaml
```yaml
# Don't do this anymore!
version: 1.1.2+6  # The +6 is now automatic
version: 1.1.2+7  # Don't manually increment
```

## Troubleshooting

### Problem: Build number conflicts
**Symptom**: "Version code X has already been used"

**Solution**: This shouldn't happen with automatic versioning, but if it does:
1. Check what's in Play Console
2. Update the base version in pubspec.yaml to be higher than the highest used version
3. Example: If Play Console has build 10, set `version: 1.1.2+10` in pubspec.yaml

### Problem: Want to reset run numbers
**Solution**: You can't reset GitHub run numbers, but you can adjust the base version:
```yaml
# If run numbers are getting large, increase base version
version: 1.2.0+100  # New base, workflow adds run number to this
```

### Problem: Need specific build number
**Solution**: You can still override manually with:
```bash
flutter build appbundle --release --build-number=123
```

But the automated workflow handles this for you!

## Migration Notes

Your existing deployments:
- Build 2: Manual upload
- Build 3: Manual bump
- Build 4: Manual bump
- Build 5: Last manual bump (current base)
- Build 6+: Automated from here!

The workflow now takes over version code management. You focus on the version name (1.1.2), and the workflow handles the build number automatically.

## Summary

🎯 **Set it and forget it!**
- Update version name only when releasing a new version
- Run the workflow anytime - automatic unique build numbers
- No more manual version code management
- No more version conflicts
