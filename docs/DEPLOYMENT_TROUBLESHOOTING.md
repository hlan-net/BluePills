# Google Play Deployment Troubleshooting

## Common Deployment Errors and Solutions

### Error: "The incoming JSON object does not contain a client_email field"

**Cause**: The `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret is missing, empty, or incorrectly formatted.

**Solution**:
1. Follow the complete guide in [GOOGLE_PLAY_SERVICE_ACCOUNT_SETUP.md](GOOGLE_PLAY_SERVICE_ACCOUNT_SETUP.md)
2. Ensure you copied the ENTIRE JSON file content when setting the secret
3. Verify the JSON file contains a `client_email` field
4. Make sure there are no extra spaces or characters before/after the JSON

**Quick Check**:
```bash
# Verify your JSON key locally (don't commit this file!)
cat your-service-account.json | jq '.client_email'
# Should output the service account email
```

---

### Error: "Unable to find 'whatsnew' directory"

**Cause**: The `distribution/whatsnew` directory doesn't exist.

**Solution**: This has been fixed! The workflow now automatically creates this directory with a default message. You can customize release notes by editing `distribution/whatsnew/whatsnew-en-US`.

---

### Error: "The project ID used to call the Google Play Developer API has not been linked"

**Cause**: The service account hasn't been linked to your Google Play Console.

**Solution**:
1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Setup** → **API access**
3. Find your service account under **Service accounts**
4. Click **Grant access** and assign appropriate permissions
5. Wait up to 24 hours for changes to propagate

---

### Error: "The caller does not have permission"

**Cause**: The service account doesn't have sufficient permissions in Google Play Console.

**Solution**:
1. Go to Google Play Console → **Setup** → **API access**
2. Find your service account
3. Click **Manage Play Console permissions**
4. Ensure these permissions are granted:
   - **View app information** (read-only)
   - **Manage releases** (release to production, exclude devices, and use Play App Signing)
5. Save and wait a few minutes for changes to take effect

---

### Error: "Package not found: net.hlan.bluepills"

**Cause**: The app hasn't been created in Google Play Console, or the package name doesn't match.

**Solution**:
1. Create the app in Google Play Console if not already done
2. Verify the package name in `android/app/build.gradle.kts` matches the one in Play Console
3. If you changed the package name, update the workflow file:
   ```yaml
   packageName: net.hlan.bluepills  # Update this to match your app
   ```

---

### Error: "Version code XXX has already been used"

**Cause**: You're trying to upload an APK/AAB with a version code that was already uploaded.

**Solution**:
1. Increment the version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # The number after + is the version code
   ```
2. Rebuild and redeploy

---

### Error: "Keystore file not found" or signing errors

**Cause**: The Android signing setup is incomplete or incorrect.

**Solution**:
1. Verify all Android secrets are set in GitHub:
   - `ANDROID_KEYSTORE_BASE64`
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS`
   - `ANDROID_KEY_PASSWORD`
2. Ensure the base64 encoding of keystore is correct:
   ```bash
   base64 android/app/keystore.jks
   # Copy entire output as ANDROID_KEYSTORE_BASE64 secret
   ```

---

### Error: "Build failed" during flutter build

**Cause**: Dependencies or code generation issues.

**Solution**:
1. The workflow runs `flutter pub get` and `dart run build_runner build`
2. Check the full workflow logs for specific error messages
3. Test locally:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter build appbundle --release
   ```

---

## Checking Workflow Status

View recent workflow runs:
```bash
gh run list --workflow=deploy.yml --limit 5
```

View detailed logs of a failed run:
```bash
gh run view <run-id> --log-failed
```

---

## Testing the Deployment Locally

Before running the GitHub Action, test the build locally:

```bash
# 1. Clean and get dependencies
flutter clean
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Build the release bundle
flutter build appbundle --release

# 4. Check the output
ls -lh build/app/outputs/bundle/release/app-release.aab
```

If this succeeds locally but fails in GitHub Actions, the issue is likely with secrets or environment configuration.

---

## Verifying Secrets

Check which secrets are set (values won't be shown):
```bash
gh secret list
```

Expected secrets:
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

To update a secret:
```bash
gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON < service-account.json
```

---

## Getting Help

1. **Check workflow logs**: The most recent error is usually at the end of the failed step
2. **Verify all prerequisites**: Service account, secrets, app in Play Console
3. **Test locally first**: Build locally to isolate issues
4. **Review documentation**: 
   - [GOOGLE_PLAY_SERVICE_ACCOUNT_SETUP.md](GOOGLE_PLAY_SERVICE_ACCOUNT_SETUP.md)
   - [QUICK_START_PLAY_STORE.md](QUICK_START_PLAY_STORE.md)
   - [PLAY_STORE_DEPLOYMENT.md](PLAY_STORE_DEPLOYMENT.md)

---

## Prevention Checklist

Before running the deploy workflow, ensure:

- [ ] App exists in Google Play Console
- [ ] Package name matches between app and workflow
- [ ] Service account created and JSON key downloaded
- [ ] Service account linked in Play Console with correct permissions
- [ ] All 5 required secrets are set in GitHub
- [ ] At least one internal test release uploaded manually (first time only)
- [ ] Version code in pubspec.yaml is higher than last uploaded version
- [ ] Local build succeeds: `flutter build appbundle --release`

---

## Still Having Issues?

If you've followed all the steps and are still experiencing issues:

1. Wait 24 hours after setting up the service account (permissions can take time to propagate)
2. Try uploading manually first through Play Console to verify your app setup
3. Check Google Cloud Console IAM logs for permission issues
4. Ensure you're using the latest version of the GitHub Action (r0adkll/upload-google-play@v1)
