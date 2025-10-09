# First Upload to Google Play Console

## Why Manual First Upload is Needed

Google Play Console requires the **first release** to be uploaded manually through the web interface. This establishes the package name in their system. After the first upload, automated deployments will work.

## Steps for First Upload

### 1. Build the Release AAB Locally

```bash
# Navigate to your project
cd /home/larry/slorba/BluePills

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Build the release app bundle
flutter build appbundle --release
```

The AAB file will be created at: `build/app/outputs/bundle/release/app-release.aab`

### 2. Complete Google Play Console Setup

1. **Go to [Google Play Console](https://play.google.com/console)**

2. **Select your app** (or create it if you haven't):
   - App name: BluePills
   - Default language: English (United States)
   - App or game: App
   - Free or paid: Free

3. **Complete required sections** (left sidebar):
   - **App content** (required before testing):
     - Privacy policy
     - App access (all features accessible)
     - Ads (select if app contains ads)
     - Content rating (complete questionnaire)
     - Target audience
     - News app (No)
     - COVID-19 contact tracing (No)
     - Data safety (complete form)
   
   - **Store listing** (required before testing):
     - App name: BluePills
     - Short description
     - Full description
     - App icon (512x512 PNG)
     - Feature graphic (1024x500)
     - Screenshots (at least 2)

### 3. Create Internal Testing Release

1. **Go to Testing → Internal testing**
2. Click **Create new release**
3. **Upload the AAB file**:
   - Click "Upload" and select `build/app/outputs/bundle/release/app-release.aab`
   - Wait for upload and processing
4. **Add release notes** (optional)
5. **Review and roll out** to Internal testing
6. **Add testers**:
   - Create a tester list
   - Add your email address

### 4. What This Does

The first manual upload:
- ✅ Registers the package name `net.hlan.bluepills` in Google Play
- ✅ Creates the first release version (1.0.0+2)
- ✅ Allows automated deployments to work afterwards

### 5. After First Upload

Once the first release is uploaded, the automated deployment workflow will work:

```bash
gh workflow run deploy.yml -f deploy_android=true -f deploy_web=false -f track=internal
```

## Troubleshooting

### Build Fails Locally

If the build fails with signing errors, you need to set up signing locally:

1. **Create key.properties** in `android/` directory:
   ```properties
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=YOUR_KEY_ALIAS
   storeFile=keystore.jks
   ```

2. **Create the keystore** (if you don't have one):
   ```bash
   cd android/app
   keytool -genkey -v -keystore keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

3. The keystore will be in `android/app/keystore.jks`
4. Update `storeFile=keystore.jks` in key.properties

### Can't Complete All Store Listing Requirements

For internal testing, you can:
- Use placeholder images
- Write minimal descriptions
- Complete only required sections

Google Play allows internal testing with minimal setup. Full store listing is only required for production release.

## Alternative: Use Pre-built AAB from GitHub Actions

If you don't want to build locally:

1. **Trigger the build workflow** (without deploy):
   ```bash
   gh workflow run ci.yml
   ```

2. **Download the artifacts** from the workflow run:
   - Go to Actions → CI workflow → Latest run
   - Download the Android artifacts
   - Extract the AAB file

3. **Upload manually** to Google Play Console

## Next Steps

After successful first upload:
1. ✅ Automated deployments will work
2. ✅ You can increment version and deploy via GitHub Actions
3. ✅ Internal testers can access the app

The initial manual upload is a one-time requirement!
