# GitHub Actions Automation Documentation

## Overview
This document describes the comprehensive GitHub Actions automation setup for BluePills, including what gets automated and how to configure it.

## 🚀 Automated Workflows

### 1. **CI/CD Pipeline** (`ci.yml`)
**Triggers:** Push to main/develop, Pull Requests

**What it does:**
- ✅ **Code Analysis**: Dart formatting, linting, static analysis
- ✅ **Security Scanning**: Vulnerability detection with Trivy
- ✅ **Multi-Platform Builds**: Android, Web, Linux, Windows, macOS
- ✅ **Test Coverage**: Unit tests with coverage reporting to Codecov
- ✅ **Dependency Updates**: Automated dependency update PRs

**Time Saved:** ~30 minutes per commit/PR of manual testing

### 2. **Release Automation** (`release.yml`)
**Triggers:** Git tags (v*), Manual workflow dispatch

**What it does:**
- 🏗️ **Multi-Platform Builds**: All platforms with optimized release builds
- 📦 **GitHub Releases**: Automatic release creation with changelogs
- 🤖 **Google Play Deploy**: Direct upload to Play Store internal testing
- 🌐 **Web Deployment**: GitHub Pages deployment
- 📱 **App Store Ready**: Prepared builds for iOS/macOS App Stores

**Time Saved:** ~2-3 hours per release cycle

### 3. **Scheduled Maintenance** (`maintenance.yml`)
**Triggers:** Weekly (Mondays 9 AM UTC), Manual

**What it does:**
- 🔍 **Dependency Audits**: Weekly dependency update reports
- 🛡️ **Security Scans**: Automated security vulnerability checks
- 📊 **Performance Monitoring**: Build size tracking and performance metrics
- 📝 **Documentation Health**: TODO tracking and documentation coverage
- 💻 **System Health**: Flutter doctor checks and environment validation

**Time Saved:** ~1 hour per week of manual maintenance

### 4. **Code Quality** (`quality.yml`)
**Triggers:** Pull Requests, Manual

**What it does:**
- 🎨 **Auto-Formatting**: Automatic code formatting on PRs
- 🔍 **Advanced Linting**: Custom lint rules and code quality checks
- ⚡ **Performance Analysis**: Build size analysis and optimization suggestions
- ♿ **Accessibility Checks**: Automated accessibility validation
- 💬 **PR Comments**: Automated code review comments

**Time Saved:** ~15 minutes per PR review

### 5. **App Store Deployment** (`deploy.yml`)
**Triggers:** Release published, Manual

**What it does:**
- 🤖 **Google Play**: Automated APK/AAB upload to Play Console
- 🌐 **Web Hosting**: GitHub Pages and optional Firebase deployment
- 🪟 **Microsoft Store**: Windows app packaging (configurable)
- 🍎 **Mac App Store**: macOS app packaging (configurable)
- 📲 **Notification**: Slack/Discord deployment notifications

**Time Saved:** ~45 minutes per deployment

## ⚙️ Required Configuration

### Repository Secrets
Add these in GitHub Settings → Secrets and variables → Actions:

#### Android Deployment
```
ANDROID_KEYSTORE_BASE64          # Base64 encoded keystore file
ANDROID_KEYSTORE_PASSWORD        # Keystore password
ANDROID_KEY_ALIAS               # Key alias name
ANDROID_KEY_PASSWORD            # Key password
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON # Google Play Console service account
```

#### Optional Integrations
```
CODECOV_TOKEN                   # Code coverage reporting
SLACK_WEBHOOK                   # Deployment notifications
FIREBASE_PROJECT_ID             # Firebase hosting
FIREBASE_TOKEN                  # Firebase deployment token
```

### Setup Instructions

#### 1. **Android Signing Setup**
```bash
# Generate keystore
keytool -genkey -v -keystore release-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 -alias bluepills

# Convert to base64
base64 release-key.keystore | tr -d '\n'
# Add this as ANDROID_KEYSTORE_BASE64 secret
```

#### 2. **Google Play Console Setup**
1. Create service account in Google Cloud Console
2. Download JSON key file
3. Add entire JSON content as `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret
4. Grant permissions in Play Console

#### 3. **Enable GitHub Pages**
1. Go to Settings → Pages
2. Select "GitHub Actions" as source
3. Your app will be available at `https://username.github.io/BluePills`

## 📊 Monitoring & Metrics

### Automated Reports
- **Weekly Dependency Report**: Issues created automatically
- **Performance Tracking**: Build size trends in artifacts
- **Code Coverage**: Trends tracked in Codecov
- **Security Alerts**: GitHub Security tab integration

### Manual Triggers
All workflows can be triggered manually via:
- GitHub Actions tab → Select workflow → "Run workflow"
- Useful for testing, emergency deployments, or troubleshooting

## 🔧 Customization

### Adding New Platforms
To add iOS support:
1. Update `ci.yml` matrix to include `ios`
2. Add iOS build steps in `release.yml`
3. Configure Apple Developer certificates as secrets

### Custom Lint Rules
Modify `quality.yml` to add project-specific checks:
```yaml
- name: Check custom rules
  run: |
    # Add your custom checks here
    grep -r "forbidden_pattern" lib/ && exit 1 || true
```

### Notification Integrations
Add Discord, Teams, or email notifications by modifying the `notify-deployment` job in `deploy.yml`.

## 🚨 Troubleshooting

### Common Issues

#### Build Failures
- Check Flutter version compatibility in workflow files
- Verify all dependencies are compatible with CI environment
- Check generated files are properly committed

#### Deployment Failures
- Verify all required secrets are set correctly
- Check Google Play Console permissions
- Ensure version codes are incrementing

#### Performance Issues
- Workflows running too long: Enable caching, parallelize jobs
- Too many dependency updates: Adjust Dependabot frequency

### Debug Commands
```bash
# Test locally
act -W .github/workflows/ci.yml

# Check workflow syntax
yamllint .github/workflows/*.yml

# Validate GitHub Actions
gh workflow list
gh run list
```

## 💡 Benefits Summary

### Time Savings
- **Per Commit**: 30 minutes → Automated
- **Per Release**: 3 hours → 5 minutes (manual trigger)
- **Per Week**: 1 hour maintenance → Automated
- **Per PR**: 15 minutes review → Automated feedback

### Quality Improvements
- **100% Test Coverage** tracking
- **Consistent Code Style** across all contributors  
- **Security Vulnerability** detection
- **Multi-Platform Compatibility** guaranteed
- **Performance Regression** detection

### Developer Experience
- **Immediate Feedback** on PRs
- **Automated Releases** with changelogs
- **Zero-Touch Deployments** to app stores
- **Consistent Environments** across team
- **Documentation** always up-to-date

## 🎯 Next Steps

1. **Enable workflows** by pushing to main branch
2. **Configure secrets** for Android deployment
3. **Test manual deployment** using workflow dispatch
4. **Monitor first weekly** maintenance run
5. **Customize notifications** for your team

This automation setup transforms BluePills from a manual deployment process to a fully automated, production-ready CI/CD pipeline! 🚀