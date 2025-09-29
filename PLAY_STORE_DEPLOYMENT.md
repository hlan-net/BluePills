# Google Play Store Deployment Guide for BluePills

## Overview
This guide will help you deploy BluePills as a testing app on Google Play Store for personal use.

## Prerequisites

### 1. Google Play Console Account
- Sign up at [Google Play Console](https://play.google.com/console)
- Pay the one-time $25 registration fee
- Verify your identity and accept the Developer Distribution Agreement

### 2. App Signing Key
You'll need to create a signing key for your app. Run these commands:

```bash
# Create keystore directory
mkdir -p ~/android-keys

# Generate signing key (replace with your details)
keytool -genkey -v -keystore ~/android-keys/bluepills-upload-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 -alias bluepills-key

# Follow prompts to enter:
# - Your name and organization details
# - Password for keystore (REMEMBER THIS!)
# - Password for key alias (can be same as keystore)
```

### 3. Configure Signing in Android
Create the file `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=bluepills-key
storeFile=/Users/YOUR_USERNAME/android-keys/bluepills-upload-key.keystore
```

## Build Configuration

### Update android/app/build.gradle.kts
Add this before the android block:

```kotlin
// Load signing properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

Update the android block to include signing config:

```kotlin
android {
    // ... existing config ...

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}
```

## Building for Release

### 1. Build the APK
```bash
cd /path/to/BluePills
flutter build apk --release
```

### 2. Build the App Bundle (Recommended)
```bash
flutter build appbundle --release
```

The output will be in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

## Play Store Setup

### 1. Create App in Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in app details:
   - **App name**: BluePills
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free

### 2. App Information
Fill in these sections in the Play Console:

#### App Details
- **App name**: BluePills
- **Short description**: Privacy-focused medication management with optional BlueSky sync
- **Full description**: (See below)

#### Suggested Full Description:
```
BluePills is a privacy-focused medication management app that helps you track your medications and set reminders, with optional BlueSky AT Protocol synchronization.

KEY FEATURES:
• Medication tracking with custom dosages and frequencies
• Local notification reminders
• Privacy-first design - start with local storage
• Optional BlueSky synchronization for cross-device access
• Decentralized data storage via AT Protocol
• Offline-first functionality

PRIVACY & CONTROL:
• Your data stays on your device by default
• Optional sync with your personal BlueSky account
• No tracking or analytics
• You control where your data is stored

Perfect for anyone who wants to manage their medications privately while having the option to sync across devices using the decentralized BlueSky network.

Note: This is an early-stage implementation. BlueSky sync requires additional setup.
```

#### Graphics Assets Needed:
1. **App icon**: 512 x 512 px PNG (use existing or create new)
2. **Feature graphic**: 1024 x 500 px JPG/PNG
3. **Screenshots**: At least 2 phone screenshots (preferably 4-8)
4. **Phone screenshots**: 16:9 or 9:16 aspect ratio

### 3. Content Rating
Complete the content rating questionnaire:
- Select "Health & Fitness" category
- Answer questions about your app's content
- BluePills should get a rating suitable for all ages

### 4. Target Audience
- **Target age**: All ages (13+)
- **Appeal to children**: No

### 5. App Content
Fill out:
- **Privacy Policy**: Required (create a simple privacy policy)
- **App category**: Health & Fitness
- **Tags**: medication, health, privacy, reminders

## Testing Setup

### 1. Internal Testing
1. In Play Console, go to "Testing" → "Internal testing"
2. Create a new release
3. Upload your app bundle (AAB file)
4. Add your email to the list of internal testers
5. Publish the release

### 2. Access Your Test App
1. Join the testing program via the link provided
2. Download from Play Store on your device
3. Test all functionality

## Sample Privacy Policy

Create a simple privacy policy at `privacy-policy.md`:

```markdown
# Privacy Policy for BluePills

## Data Collection
BluePills stores your medication information locally on your device. When BlueSky sync is enabled, your medication data is stored on your chosen Personal Data Server (PDS).

## Data Usage
- Medication data is used only for app functionality
- No analytics or tracking data is collected
- No data is shared with third parties

## Data Storage
- Local mode: Data stored only on your device
- Sync mode: Data stored on your chosen BlueSky PDS
- You have full control over your data location

## Contact
For questions about this privacy policy, contact: [your-email@example.com]

Last updated: [Current Date]
```

## Deployment Commands

```bash
# 1. Ensure dependencies are up to date
flutter pub get

# 2. Run code generation
dart run build_runner build

# 3. Clean previous builds
flutter clean

# 4. Build release app bundle
flutter build appbundle --release

# 5. Test the release build locally (optional)
flutter build apk --release
flutter install --release
```

## Security Considerations

### For Production Use:
1. **Enable App Signing by Google Play**: Let Google manage your signing key
2. **Enable ProGuard**: Already configured in build.gradle.kts
3. **Review Permissions**: Only necessary permissions are included
4. **Security Review**: Consider security audit for production

### Sensitive Data:
- Keep your keystore and passwords secure
- Never commit key.properties to version control
- Consider using environment variables for CI/CD

## Troubleshooting

### Common Issues:
1. **Build failures**: Run `flutter clean && flutter pub get`
2. **Signing issues**: Verify key.properties path and passwords
3. **Upload issues**: Ensure you're using unique version codes
4. **Permission issues**: Check AndroidManifest.xml permissions

### Version Updates:
To release updates:
1. Increment version in pubspec.yaml (e.g., 1.0.1+2)
2. Build new app bundle
3. Upload to Play Console
4. Release to testing track

## Next Steps

Once your test app is working:
1. **Add More Testers**: Invite friends/family to test
2. **Gather Feedback**: Use Play Console's feedback tools
3. **Iterate**: Fix bugs and add features
4. **Public Release**: When ready, promote to production track

Remember: This setup creates a private testing app. You control who can access it through the Play Console testing features.