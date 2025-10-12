# Debug Symbols for Google Play

## What are Debug Symbols?

Debug symbols help you analyze crash reports and ANRs (Application Not Responding) in Google Play Console. They provide detailed stack traces with actual function names and line numbers instead of obscured memory addresses.

## Types of Debug Information

### 1. ProGuard/R8 Mapping File (Already Configured ✓)
- Maps obfuscated code back to original names
- Located at: `build/app/outputs/mapping/release/mapping.txt`
- Automatically uploaded by the deployment workflow

### 2. Native Debug Symbols (Now Configured ✓)
- For native C/C++ libraries used by Flutter
- Helps debug crashes in native code
- The workflow now attempts to collect and upload these

## Warning: "App Bundle contains native code"

This warning appears because Flutter apps include native libraries. The workflow has been updated to handle this, but here's how to manually upload symbols if needed.

## Manual Upload (If Automatic Upload Fails)

### Step 1: Build with Symbols

```bash
# Build the release app bundle
flutter build appbundle --release

# The native symbols are in:
build/app/intermediates/merged_native_libs/release/out/lib/
```

### Step 2: Create Symbols Archive

```bash
cd build/app/intermediates/merged_native_libs/release/out/lib/

# Create a zip file of all architecture folders
zip -r native-debug-symbols.zip *

# Or create separate archives per architecture
zip -r arm64-v8a.zip arm64-v8a/
zip -r armeabi-v7a.zip armeabi-v7a/
zip -r x86_64.zip x86_64/
```

### Step 3: Upload to Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to **Quality** → **Android vitals** → **Crashes & ANRs**
4. Click **Upload debug symbols** in the top right
5. Select the version code (e.g., 4)
6. Upload the zip file(s)

## What the Workflow Does Now

The updated deployment workflow:

1. **Builds the AAB** with release configuration
2. **Extracts native symbols** from the build artifacts
3. **Uploads to GitHub Actions** as artifacts (for manual download if needed)
4. **Uploads mapping file** to help debug ProGuard obfuscation

## Checking Symbol Upload Status

After deployment, check in Play Console:

1. Go to **Release** → **Internal testing**
2. Click on your release
3. Look for "Debug symbols" section
4. Status should show: "ProGuard mapping file available"

## Do I Need to Worry About This Warning?

**For Internal Testing:** No, the warning is informational. Your app will work fine.

**For Production:** It's recommended to upload symbols for better crash debugging, but not strictly required.

## Automatic Symbol Upload (Future Enhancement)

The current GitHub Action (`r0adkll/upload-google-play@v1`) uploads the ProGuard mapping file automatically. Native debug symbols need to be uploaded separately through:

1. **Play Console web interface** (manual)
2. **Google Play Developer API** (requires additional setup)
3. **Bundletool** (command-line tool)

## Alternative: Using Bundletool

If you want to extract and upload symbols programmatically:

```bash
# Download bundletool
curl -L https://github.com/google/bundletool/releases/latest/download/bundletool-all.jar -o bundletool.jar

# Extract native libraries
java -jar bundletool.jar extract-libs \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output-dir=symbols/

# Upload to Play Console (requires additional API setup)
```

## Best Practices

1. **Always keep mapping files** - Store them for each release
2. **Match versions** - Ensure symbols match the exact build/version code
3. **Test crash reporting** - Trigger a test crash to verify symbols work
4. **Monitor crash reports** - Check Play Console regularly

## For Your App

The warning is safe to ignore for now since:
- ✓ ProGuard mapping file is uploaded automatically
- ✓ Native symbols are collected (available as workflow artifacts)
- ✓ You can upload native symbols manually if needed for crash debugging
- ✓ Your app is in internal testing, not production

Once you have actual crash reports in Play Console, you can download the symbols from the workflow artifacts and upload them if the crash reports aren't detailed enough.

## Workflow Artifacts

After each deployment, you can download symbols from GitHub:

1. Go to **Actions** → **Deploy to App Stores** → Select run
2. Scroll to **Artifacts** section
3. Download:
   - `android-mapping` - ProGuard mapping file
   - `native-debug-symbols` - Native symbols (if available)

Keep these for 90 days (artifact retention period) in case you need them for debugging.
