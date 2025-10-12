# 🔒 Security Guide for BluePills Public Repository

## ⚠️ **CRITICAL: Public Repository Security**

Since BluePills is a **public repository**, all secrets, keys, and credentials must be managed **outside of Git**. This guide ensures your project remains secure while being open source.

---

## 🚨 **NEVER Commit These Files**

### ❌ **Absolutely Forbidden in Git:**
```bash
# Android signing
android/key.properties
android/app/keystore.jks
android/app/upload-keystore.jks
*.keystore
*.jks

# API Keys & Tokens
google-services.json
GoogleService-Info.plist
.env files (except .env.example)
firebase_app_id_file.json

# Certificates & Keys
*.pem
*.key
*.crt
*.p12
*.pfx

# Configuration with secrets
config/secrets.yaml
config/production.yaml
```

### ✅ **Safe to Commit:**
```bash
# Templates and examples
android/key.properties.template
.env.example
config/secrets.yaml.example

# Documentation
SECURITY.md
DEPLOYMENT.md
```

---

## 🛡️ **GitHub Repository Secrets**

### **For Automated Deployment:**
Store these in GitHub Settings → Secrets and variables → Actions:

#### **Android Deployment:**
```
ANDROID_KEYSTORE_BASE64          # Base64 encoded keystore file
ANDROID_KEYSTORE_PASSWORD        # Keystore password
ANDROID_KEY_ALIAS               # Key alias name
ANDROID_KEY_PASSWORD            # Key password
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON # Service account JSON content
```

#### **Optional Integrations:**
```
CODECOV_TOKEN                   # Code coverage reporting
SLACK_WEBHOOK                   # Deployment notifications
FIREBASE_TOKEN                  # Firebase deployment
FIREBASE_PROJECT_ID             # Firebase project ID
```

---

## 🔐 **Local Development Security**

### **1. Android Signing Setup**
```bash
# Create keystore (store outside repo!)
mkdir -p ~/android-keys
keytool -genkey -v -keystore ~/android-keys/bluepills-release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 -alias bluepills

# Create key.properties (ignored by Git)
echo "storePassword=YOUR_PASSWORD" > android/key.properties
echo "keyPassword=YOUR_PASSWORD" >> android/key.properties
echo "keyAlias=bluepills" >> android/key.properties
echo "storeFile=../../../android-keys/bluepills-release.keystore" >> android/key.properties
```

### **2. Environment Variables**
```bash
# For local testing with secrets
export BLUEPILLS_API_KEY="your-api-key"
export BLUEPILLS_DB_URL="your-db-url"

# Or use .env file (Git ignored)
echo "BLUEPILLS_API_KEY=your-api-key" > .env
echo "BLUEPILLS_DB_URL=your-db-url" >> .env
```

### **3. IDE Configuration**
```bash
# VS Code settings (local only)
# Stored in .vscode/settings.json (Git ignored for secrets)
{
  "dart.env": {
    "BLUEPILLS_API_KEY": "your-local-key"
  }
}
```

---

## 🔍 **Security Scanning & Monitoring**

### **Automated Security Checks:**
Our GitHub Actions include:
- ✅ **Trivy vulnerability scanning**
- ✅ **Dependency security audits**
- ✅ **Secret detection** (prevents accidental commits)
- ✅ **License compliance** checking

### **Pre-commit Security:**
```bash
# Run security check before commit
./scripts/security-check.sh

# Check for secrets in staged files
git diff --cached --name-only | xargs grep -l "password\|secret\|key" || echo "Clean"
```

### **Manual Security Audit:**
```bash
# Scan for potential secrets
git log --all --full-history -- "**/*secret*" "**/*key*" "**/*password*"

# Check current repo for secrets
grep -r "password\|secret\|key" . --exclude-dir=.git --exclude-dir=build
```

---

## 🚀 **Deployment Security**

### **Production Deployment:**
1. **Secrets stored in GitHub Actions** (not in code)
2. **Keystore stored externally** (base64 encoded in secrets)
3. **Environment-specific configs** (production, staging)
4. **Secure CI/CD pipeline** (automated security checks)

### **Local Development:**
1. **Local keystore** (outside Git repo)
2. **Environment variables** (not hardcoded)
3. **Test credentials only** (never production secrets)
4. **Regular key rotation** (development keys)

---

## 🛠️ **Security Best Practices**

### **For Contributors:**
1. **Never commit secrets** (use .env.example for templates)
2. **Use GitHub secrets** for CI/CD
3. **Rotate compromised keys** immediately
4. **Review PRs for secrets** before merging

### **For Maintainers:**
1. **Regular security audits** of dependencies
2. **Monitor GitHub security alerts**
3. **Update vulnerable dependencies** promptly
4. **Review contributor access** periodically

### **For Users:**
1. **Generate your own keys** (don't share keystores)
2. **Use strong passwords** for signing keys
3. **Backup keystores securely** (not in Git)
4. **Keep local secrets local**

---

## 🚨 **If Secrets Are Accidentally Committed**

### **Immediate Actions:**
```bash
# 1. Remove from Git history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch android/key.properties' \
  --prune-empty --tag-name-filter cat -- --all

# 2. Force push (if you own the repo)
git push origin --force --all

# 3. Rotate ALL affected secrets
# - Generate new keystore
# - Update GitHub secrets
# - Change any exposed passwords/tokens
```

### **Prevention:**
```bash
# Set up git hooks
cp .github/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Use git-secrets tool
git secrets --register-aws
git secrets --install
```

---

## 📋 **Security Checklist**

### **Before Every Commit:**
- [ ] No secrets in staged files
- [ ] .gitignore updated for new secret files
- [ ] Environment variables used (not hardcoded)
- [ ] Only template/example files committed

### **Before Every Release:**
- [ ] Security scan completed
- [ ] Dependencies updated
- [ ] Keystores rotated (if needed)
- [ ] GitHub secrets updated

### **Monthly Security Review:**
- [ ] Audit repository for secrets
- [ ] Update vulnerable dependencies
- [ ] Review GitHub security alerts
- [ ] Rotate development keys

---

## 🎯 **Quick Security Commands**

```bash
# Check for secrets before commit
./scripts/security-check.sh

# Scan dependencies for vulnerabilities
flutter pub audit

# Update all dependencies
flutter pub upgrade

# Generate new development keystore
./scripts/generate-keystore.sh

# Clean build artifacts (may contain secrets)
flutter clean && rm -rf build/
```

---

## 🔗 **Security Resources**

- [GitHub Security Advisories](https://github.com/your-username/BluePills/security/advisories)
- [Dependabot Alerts](https://github.com/your-username/BluePills/security/dependabot)
- [Flutter Security Guide](https://docs.flutter.dev/deployment/obfuscate)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

---

## 🎉 **Security Is Setup! ✅**

Your BluePills repository is now **properly secured** for public open-source development:

- ✅ **All secrets excluded** from Git
- ✅ **GitHub Actions secrets** configured  
- ✅ **Automated security scanning** enabled
- ✅ **Pre-commit hooks** prevent accidents
- ✅ **Documentation** for contributors
- ✅ **Security monitoring** active

**Your public repository is secure and ready for community contributions!** 🌟

---

*Remember: Security is a continuous process. Regularly review and update your security practices as the project grows.*