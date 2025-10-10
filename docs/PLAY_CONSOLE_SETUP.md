# Completing Google Play Console Setup

## Issue: "Only releases with status draft may be created on draft app"

Your app is in "draft" status because certain required sections haven't been completed in Google Play Console. The deployment workflow now creates draft releases, but to fully publish and test the app, you need to complete the required setup.

## Required Sections to Complete

### 1. App Content (Required)

Go to **Policy → App content** and complete:

#### Privacy Policy ✓
- Provide a URL to your privacy policy
- You can use the `PRIVACY_POLICY.md` file in your repo
- Host it on GitHub Pages or create a simple page

#### App Access ✓
- Select if all features are accessible or require login
- For testing app: Select "All functionality is available without restrictions"

#### Ads ✓
- Does your app contain ads?
- For medication tracker: Likely "No"

#### Content Ratings ✓
- Complete the questionnaire
- Select "Health & Fitness" or "Lifestyle" category
- Answer questions truthfully about your app
- This generates age ratings (ESRB, PEGI, etc.)

#### Target Audience ✓
- Select target age group
- For medication app: "18 and over" is appropriate

#### News App ✓
- Is this a news app? → No

#### COVID-19 Contact Tracing ✓
- Is this a contact tracing app? → No

#### Data Safety ✓
- What data do you collect?
- How is it used?
- Is it shared with third parties?
- For privacy-focused app, you can indicate:
  - Data is stored locally
  - Optional sync with user's own BlueSky account
  - No data shared with third parties
  - No analytics/tracking

### 2. Store Listing (Required)

Go to **Grow → Store listing** and provide:

#### App Details ✓
- **App name**: BluePills
- **Short description** (max 80 chars):
  ```
  Privacy-focused medication tracker with optional BlueSky sync
  ```
- **Full description** (max 4000 chars):
  ```
  BluePills is a privacy-focused medication management app that helps you track 
  your medications and set reminders, with optional BlueSky AT Protocol synchronization.

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

  Perfect for anyone who wants to manage their medications privately while having 
  the option to sync across devices using the decentralized BlueSky network.
  ```

#### Graphics ✓
You need to provide:
1. **App icon** (512 x 512 px PNG)
   - Use your existing app icon
   - Export at 512x512 resolution

2. **Feature graphic** (1024 x 500 px JPG/PNG)
   - Create a banner image for your app
   - Can be simple with app name and tagline

3. **Screenshots** (at least 2, up to 8)
   - **Phone screenshots**: Take screenshots from your app
   - Use an emulator or real device
   - Required sizes: 16:9 or 9:16 aspect ratio
   - Recommended: 1080 x 1920 or 1080 x 2340

#### App Categorization ✓
- **Category**: Health & Fitness (or Medical)
- **Tags**: medication, health, privacy, reminders

#### Contact Details ✓
- **Email**: Your support email
- **Website** (optional): Your GitHub repo or project page
- **Phone** (optional)

### 3. Countries/Regions

Go to **Production → Countries/regions**:
- Select which countries can access your app
- For testing: Can start with your own country
- For wider release: Select all desired countries

## What Happens After Completion

Once you complete the required sections:

1. **Draft releases work** ✓ (current state)
   - Workflow uploads as draft
   - You manually review and publish in Play Console

2. **Can change to completed status** (future)
   - Update workflow: `status: completed`
   - Releases automatically go live in selected track
   - No manual review needed

## Workflow Behavior

### Current (Draft Mode)
```yaml
status: draft
```
- Upload succeeds
- Release appears as draft in Play Console
- You review and click "Review release" → "Start rollout to internal testing"

### Future (Completed Mode)
```yaml
status: completed
```
- Upload succeeds
- Release automatically goes live
- Fully automated deployment

## Quick Start for Testing

Minimum to enable internal testing:

1. **Privacy Policy** - Create a simple page
2. **App Access** - Select "All functionality available"
3. **Content Rating** - Complete questionnaire
4. **Data Safety** - Fill out the form
5. **Store Listing** - Provide descriptions (graphics can be placeholders for testing)

After completing these, you can:
- Deploy to internal testing track
- Add testers (your email)
- Download and test the app

## Creating Graphics Quickly

### Using Your Existing Assets

1. **App Icon**: Already have in `android/app/src/main/res/` folders
   - Export at 512x512 for Play Store

2. **Feature Graphic**: Simple template
   ```
   Background: Solid color or gradient
   Text: "BluePills" + tagline
   Icon: Your app icon
   Size: 1024 x 500
   ```

3. **Screenshots**: Use Flutter
   ```bash
   # Run app on emulator/device
   flutter run
   
   # Take screenshots from the app
   # Or use Flutter's screenshot testing
   ```

## Need Help?

The Play Console has helpful tooltips and examples for each field. For internal testing, you can use:
- Placeholder graphics
- Minimal descriptions
- Basic privacy policy

Full store listing is only required for production release!

## After Setup is Complete

Once you've completed the required sections, run the deployment workflow again:

```bash
gh workflow run deploy.yml -f deploy_android=true -f deploy_web=false -f track=internal
```

The release will be created as a draft, then you can review and publish it in Play Console.
