# Installing App on Your Devices for Screenshots

## Option 1: Internal Testing Track (Recommended)

This is the easiest way to get the app on your devices directly from Play Store.

### Step 1: Set Up Internal Testing in Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your BluePills app
3. Navigate to **Testing** → **Internal testing**
4. Click **Create new release** (if you haven't already)
5. Upload the AAB or review the existing draft release
6. Click **Review release** → **Start rollout to internal testing**

### Step 2: Add Yourself as a Tester

1. In **Internal testing**, go to the **Testers** tab
2. Click **Create email list**
3. Give it a name (e.g., "My Devices")
4. Add your email addresses:
   - Your personal email
   - Any Google accounts you use on your devices
5. Save the list
6. Make sure the list is selected in the internal testing track

### Step 3: Get the Opt-In Link

1. Still in **Internal testing** → **Testers** tab
2. Copy the **opt-in URL** (looks like: `https://play.google.com/apps/testing/net.hlan.bluepills`)
3. This link will be valid for all your testers

### Step 4: Install on Your Devices

**On Each Device (Phone & Tablet):**

1. Make sure you're signed in with the Google account you added as a tester
2. Open the opt-in URL on your device (email it to yourself or click from browser)
3. Click **Become a tester**
4. Once accepted, click **Download it on Google Play**
5. The Play Store app will open
6. Install the app normally from Play Store

### Step 5: Generate Screenshots

1. Open the app on your device
2. Navigate to different screens
3. Take screenshots (Power + Volume Down on most Android devices)
4. Screenshots will be saved to your device gallery

---

## Option 2: Internal Sharing Link (Fastest)

If you saw an internal sharing link in the workflow output, you can use that:

```
INTERNAL_SHARING_DOWNLOAD_URL: https://play.google.com/apps/test/net.hlan.bluepills/15
```

### How to Use:

1. Open this URL on your Android device
2. Install directly (no tester setup needed)
3. **Note**: Internal sharing links expire after 60 days

---

## Option 3: Install AAB/APK Directly

If you want to test before publishing to internal testing:

### Build an APK Locally

```bash
cd .

# Build debug APK (easier for testing)
flutter build apk --debug

# Or release APK
flutter build apk --release
```

**APK location:**
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`

### Transfer to Your Device

**Option A: USB Cable**
```bash
# Enable USB debugging on your phone
# Connect via USB
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Option B: File Transfer**
1. Copy the APK to your device (USB, cloud storage, email, etc.)
2. On your device, enable **Install unknown apps** for your file manager
3. Open the APK file and install

---

## Option 4: Use Flutter Directly

If your devices are connected via USB:

```bash
# List connected devices
flutter devices

# Run on specific device
flutter run --release -d <device-id>
```

This installs and runs the app directly from your development machine.

---

## Best Approach for Screenshots

**Recommended: Option 1 (Internal Testing)**

Why?
- ✅ Same experience as real users will have
- ✅ Tests the actual Play Store distribution
- ✅ No need to enable developer options
- ✅ Clean installation without debug tools
- ✅ Can test on multiple devices easily
- ✅ Looks professional (installed from Play Store)

---

## Taking Good Screenshots for Play Store

### Requirements:
- **Minimum**: 2 screenshots
- **Maximum**: 8 screenshots
- **Format**: JPEG or 24-bit PNG (no alpha)
- **Aspect ratio**: 16:9 or 9:16
- **Min dimensions**: 320px
- **Max dimensions**: 3840px

### Recommended Sizes:
- **Phone**: 1080 x 1920 (portrait) or 1920 x 1080 (landscape)
- **Tablet**: 1200 x 1920 (portrait) or 1920 x 1200 (landscape)

### What to Capture:

1. **Home/Main screen** - First impression
2. **Medication list** - Core functionality
3. **Add medication** - Show how to add entries
4. **Medication details** - Show detailed view
5. **Reminders/Notifications** - If you have this feature
6. **Settings/Privacy** - Highlight privacy features
7. **BlueSky sync** (optional) - Show the sync feature
8. **Empty state** - Clean UI when starting fresh

### Tips:

- Use **light mode** for screenshots (better visibility)
- Populate with **sample data** before taking screenshots
- Take screenshots in **portrait mode** primarily
- Capture **key features** users will care about
- Keep UI **clean and simple**
- Avoid showing personal/sensitive data

### On Android Devices:

**Take Screenshot:**
- Most devices: **Power + Volume Down** simultaneously
- Samsung: **Power + Volume Down** or **Palm swipe**

**Find Screenshots:**
- Gallery app → Screenshots folder
- Or: `/sdcard/Pictures/Screenshots/`

---

## Editing Screenshots (Optional)

You can add captions or frame your screenshots:

### Online Tools:
- [Figma](https://figma.com) - Free, professional
- [Canva](https://canva.com) - Easy templates
- [Screely](https://screely.com) - Add device frames

### Add Device Frames:
Makes screenshots look more professional by showing them in a phone/tablet frame.

### Add Text Overlays:
Briefly describe what each screenshot shows:
- "Track Your Medications"
- "Set Reminders"
- "Privacy-Focused Design"

---

## Quick Start Checklist

- [ ] Publish to internal testing in Play Console
- [ ] Add your email as a tester
- [ ] Open opt-in URL on your phone
- [ ] Become a tester
- [ ] Install from Play Store
- [ ] Add sample medications
- [ ] Take 4-6 screenshots
- [ ] Repeat on tablet (if you have one)
- [ ] Upload screenshots to Play Console

---

## Troubleshooting

### Can't find the app in Play Store
- Make sure you're signed in with the tester email
- Wait 5-10 minutes after accepting the opt-in
- Make sure the release is published to internal testing (not just draft)

### "App not available in your country"
- Check the Countries/Regions setting in Play Console
- Make sure your country is selected

### Installation failed
- Make sure you have enough storage space
- Try clearing Play Store cache: Settings → Apps → Play Store → Clear Cache

### Need to test urgently
- Use Option 2 (Internal Sharing Link) - works immediately
- Or Option 3 (Install APK directly) - no Play Store needed

---

## Next Steps After Screenshots

1. Upload screenshots to Play Console:
   - Go to **Grow** → **Store listing**
   - Scroll to **Graphics** section
   - Upload phone screenshots (required)
   - Upload tablet screenshots (optional but recommended)

2. Complete other store listing requirements:
   - App icon (512x512)
   - Feature graphic (1024x500)
   - Descriptions

3. Publish to wider testing or production when ready!
