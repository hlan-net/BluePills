# Google Play Service Account Setup Guide

## Issue
The deployment workflow is failing with the error:
```
The incoming JSON object does not contain a client_email field
```

This means the `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret is either missing or incorrectly formatted.

## Solution

### Step 1: Create a Service Account in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select or create a project for your app
3. Navigate to **IAM & Admin** → **Service Accounts**
4. Click **+ CREATE SERVICE ACCOUNT**
5. Fill in the details:
   - **Service account name**: `bluepills-play-publisher` (or any name you prefer)
   - **Service account description**: "Service account for uploading BluePills to Google Play"
6. Click **CREATE AND CONTINUE**
7. Skip the optional permissions (we'll set them in Play Console)
8. Click **DONE**

### Step 2: Create a JSON Key

1. Find your newly created service account in the list
2. Click on the service account name
3. Go to the **KEYS** tab
4. Click **ADD KEY** → **Create new key**
5. Select **JSON** as the key type
6. Click **CREATE**
7. The JSON key file will be downloaded to your computer

**Important**: Keep this file secure! It provides access to your Google Play Console.

### Step 3: Link Service Account to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Setup** → **API access**
3. Click **Link a project** (if not already linked)
4. Select your Google Cloud project
5. Under **Service accounts**, find your service account
6. Click **Grant access**
7. Select the following permissions:
   - **Admin** (for Releases): View app information and download bulk reports
   - **Release manager**: Manage releases (upload APKs/AABs)
8. Click **Apply** → **Send invitation**

### Step 4: Verify the JSON Key Format

The downloaded JSON file should look like this:

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "bluepills-play-publisher@your-project.iam.gserviceaccount.com",
  "client_id": "123456789",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/..."
}
```

The most important field is `client_email` - this must be present!

### Step 5: Update GitHub Secret

1. Open your JSON key file in a text editor
2. Copy the **entire contents** of the file
3. Go to your GitHub repository
4. Navigate to **Settings** → **Secrets and variables** → **Actions**
5. Find the `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret
6. Click **Update** (or **New repository secret** if it doesn't exist)
7. Paste the entire JSON content as the secret value
8. Click **Update secret** (or **Add secret**)

### Step 6: Test the Deployment

1. Go to **Actions** tab in your GitHub repository
2. Select the **Deploy to App Stores** workflow
3. Click **Run workflow**
4. Select options:
   - Deploy to Google Play: ✓
   - Deploy to Web: (your choice)
   - Track: `internal`
5. Click **Run workflow**

## Common Issues

### Issue: "client_email field is missing"
**Solution**: Make sure you copied the ENTIRE JSON file content, including the opening `{` and closing `}` braces.

### Issue: "The project ID used to call the Google Play Developer API has not been linked"
**Solution**: Complete Step 3 above to link the service account in Google Play Console.

### Issue: "The caller does not have permission"
**Solution**: Make sure you granted the correct permissions in Step 3 (Release manager role).

### Issue: "Package not found"
**Solution**: Make sure you've created the app in Google Play Console and the package name matches (`com.slorba.bluepills`).

## Security Best Practices

1. **Never commit** the JSON key file to your repository
2. **Rotate keys** periodically (every 90 days recommended)
3. **Use minimum permissions** - only grant what's necessary
4. **Monitor usage** in Google Cloud Console IAM audit logs
5. **Delete old keys** after rotation

## Troubleshooting Commands

To verify your secret is set correctly:

```bash
# Check if the secret exists (won't show the value)
gh secret list | grep GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

# Test JSON validity locally (don't commit this file!)
cat service-account.json | jq '.client_email'
# Should output: "your-service-account@project.iam.gserviceaccount.com"
```

## Next Steps

After the secret is correctly set:

1. The deployment workflow should complete successfully
2. Check the **Releases** section in Google Play Console
3. Your app should appear in the **Internal testing** track
4. You can then promote it to other tracks (alpha, beta, production)

## Need Help?

If you're still having issues:

1. Check the workflow logs for detailed error messages
2. Verify all secrets are set: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
3. Ensure the app exists in Google Play Console with the correct package name
4. Make sure the service account has been granted access in Play Console (can take up to 24 hours to propagate)
