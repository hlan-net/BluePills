# Automation Setup Script for BluePills
# Run this script to set up local development automation

#!/bin/bash

set -e

echo "🚀 Setting up BluePills development automation..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ This must be run from the root of a git repository"
    exit 1
fi

# Install git hooks
echo "📝 Installing git hooks..."
if [ -f ".github/hooks/pre-commit" ]; then
    cp .github/hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✅ Pre-commit hook installed"
else
    echo "⚠️ Pre-commit hook not found"
fi

# Install development dependencies
echo "📦 Installing development dependencies..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Get Flutter dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Install optional tools
echo "🔧 Installing optional development tools..."

# Install dart_code_metrics for advanced linting
dart pub global activate dart_code_metrics

# Install lcov for coverage reports (Linux/macOS)
if command -v apt-get &> /dev/null; then
    echo "Installing lcov via apt..."
    sudo apt-get update && sudo apt-get install -y lcov
elif command -v brew &> /dev/null; then
    echo "Installing lcov via Homebrew..."
    brew install lcov
else
    echo "⚠️ Could not install lcov automatically. Please install manually for coverage reports."
fi

# Create local configuration files
echo "⚙️ Creating local configuration files..."

# Create .vscode/settings.json if it doesn't exist
mkdir -p .vscode
if [ ! -f ".vscode/settings.json" ]; then
    cat > .vscode/settings.json << 'EOF'
{
  "dart.flutterSdkPath": "",
  "dart.lineLength": 100,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit"
  },
  "dart.debugExternalPackageLibraries": false,
  "dart.debugSdkLibraries": false,
  "files.associations": {
    "*.dart": "dart"
  },
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
EOF
    echo "✅ VS Code settings created"
fi

# Create .vscode/launch.json if it doesn't exist
if [ ! -f ".vscode/launch.json" ]; then
    cat > .vscode/launch.json << 'EOF'
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug BluePills",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--flavor", "development"]
    },
    {
      "name": "Profile BluePills",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "profile"
    },
    {
      "name": "Release BluePills",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "release"
    }
  ]
}
EOF
    echo "✅ VS Code launch configuration created"
fi

# Create development scripts
echo "📜 Creating development scripts..."

mkdir -p scripts

# Build script
cat > scripts/build.sh << 'EOF'
#!/bin/bash
set -e

echo "🏗️ Building BluePills for all platforms..."

# Clean previous builds
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Android
echo "📱 Building Android..."
flutter build apk --release
flutter build appbundle --release

# Web
echo "🌐 Building Web..."
flutter build web --release

# Linux (if supported)
if flutter doctor | grep -q "Linux toolchain"; then
    echo "🐧 Building Linux..."
    flutter build linux --release
fi

echo "✅ All builds completed!"
EOF

# Test script
cat > scripts/test.sh << 'EOF'
#!/bin/bash
set -e

echo "🧪 Running BluePills tests..."

# Format code
dart format .

# Analyze code
flutter analyze

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
if command -v lcov &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    echo "📊 Coverage report generated: coverage/html/index.html"
fi

echo "✅ All tests passed!"
EOF

# Deployment script
cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Deploying BluePills..."

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️ Warning: Not on main branch (current: $CURRENT_BRANCH)"
    read -p "Continue with deployment? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Deployment cancelled"
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff --quiet; then
    echo "❌ Uncommitted changes detected. Please commit or stash changes first."
    exit 1
fi

# Run tests
./scripts/test.sh

# Build release
./scripts/build.sh

echo "✅ Deployment build ready!"
echo "💡 To deploy:"
echo "   - Android: Upload build/app/outputs/bundle/release/app-release.aab to Play Console"
echo "   - Web: Deploy build/web/ to your hosting service"
EOF

# Make scripts executable
chmod +x scripts/*.sh

echo "✅ Development scripts created in scripts/"

# GitHub CLI setup (if available)
if command -v gh &> /dev/null; then
    echo "🐙 GitHub CLI detected. Setting up additional automation..."
    
    # Enable Dependabot alerts
    gh api repos/:owner/:repo/vulnerability-alerts -X PUT 2>/dev/null || echo "⚠️ Could not enable vulnerability alerts"
    
    # Enable GitHub Pages (if not already enabled)
    gh api repos/:owner/:repo/pages -X POST -f source='{\"branch\":\"gh-pages\",\"path\":\"/\"}' 2>/dev/null || echo "⚠️ Could not enable GitHub Pages automatically"
    
    echo "✅ GitHub automation configured"
else
    echo "💡 Install GitHub CLI (gh) for additional automation features"
fi

# Create development documentation
echo "📚 Creating development documentation..."

cat > DEVELOPMENT.md << 'EOF'
# Development Guide

## Quick Start
```bash
# Set up development environment
./scripts/setup.sh

# Run tests
./scripts/test.sh

# Build all platforms
./scripts/build.sh

# Deploy
./scripts/deploy.sh
```

## Git Hooks
- **Pre-commit**: Runs formatting, linting, and tests
- **Commit message**: Enforces conventional commit format

## VS Code Integration
- Auto-formatting on save
- Debug configurations for different modes
- Flutter UI guides enabled

## Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## Deployment
- **Android**: Use GitHub Actions or upload AAB manually
- **Web**: Deployed via GitHub Pages
- **Desktop**: Manual distribution of builds

## Automation
- **CI/CD**: GitHub Actions for testing and building
- **Dependabot**: Automated dependency updates
- **Security**: Automated vulnerability scanning
- **Quality**: Code formatting and linting checks
EOF

echo "✅ Development documentation created"

# Final setup verification
echo "🔍 Verifying setup..."

# Check Flutter doctor
flutter doctor

# Run a quick test
flutter analyze

echo ""
echo "🎉 BluePills development automation setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review GitHub Actions workflows in .github/workflows/"
echo "2. Configure repository secrets for deployment"
echo "3. Enable GitHub Pages in repository settings"
echo "4. Install recommended VS Code extensions:"
echo "   - Dart"
echo "   - Flutter"
echo "   - GitLens"
echo "   - Thunder Client (for API testing)"
echo ""
echo "💡 Useful commands:"
echo "   ./scripts/test.sh     - Run tests"
echo "   ./scripts/build.sh    - Build all platforms"
echo "   ./scripts/deploy.sh   - Prepare deployment"
echo ""
echo "Happy coding! 🚀"