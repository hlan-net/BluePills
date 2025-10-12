# Contributing to BluePills

Thank you for your interest in contributing to BluePills! We welcome contributions from the community to help make this medication management app better for everyone.

## 🤝 Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## 📋 How to Contribute

### 🐛 Reporting Bugs
- Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.yml)
- Include detailed steps to reproduce
- Specify platform and version information
- Add screenshots if applicable

### ✨ Suggesting Features
- Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.yml)
- Clearly describe the problem and proposed solution
- Consider the impact on privacy and user control
- Think about cross-platform compatibility

### 💻 Code Contributions

#### Getting Started
1. **Fork the repository**
2. **Clone your fork**: `git clone https://github.com/your-username/BluePills.git`
3. **Set up development environment**: `./setup-automation.sh`
4. **Create a feature branch**: `git checkout -b feature/your-feature-name`

#### Development Guidelines
- **Follow Dart/Flutter conventions**
- **Write tests for new functionality**
- **Update documentation as needed**
- **Respect the privacy-first design philosophy**
- **Ensure cross-platform compatibility**

#### Commit Guidelines
Use [conventional commits](https://www.conventionalcommits.org/):
```
feat(auth): add BlueSky authentication
fix(ui): resolve medication form validation
docs(readme): update installation instructions
```

#### Pull Request Process
1. **Run automated checks**: `./scripts/test.sh`
2. **Update documentation** if needed
3. **Create pull request** with clear description
4. **Address review feedback** promptly
5. **Ensure CI/CD passes** all checks

### 🧪 Testing
- **Run tests**: `flutter test`
- **Check coverage**: `flutter test --coverage`
- **Test on multiple platforms** when possible
- **Verify accessibility** features work

### 📚 Documentation
- **Update README.md** for user-facing changes
- **Add code comments** for complex logic
- **Update API documentation** as needed
- **Include examples** for new features

## 🎯 Priority Areas

We especially welcome contributions in these areas:

### 🔒 **Privacy & Security**
- Security audits and improvements
- Privacy-enhancing features
- Data encryption enhancements

### ♿ **Accessibility**
- Screen reader compatibility
- Voice control support
- Visual accessibility improvements

### 🌐 **AT Protocol Integration**
- BlueSky authentication improvements
- Sync reliability enhancements
- Conflict resolution features

### 🔧 **Platform Support**
- iOS implementation
- Desktop app improvements
- Cross-platform consistency

### 📱 **User Experience**
- UI/UX improvements
- Medication management features
- Notification enhancements

## ⚖️ Legal Considerations

### License Agreement
By contributing to BluePills, you agree that your contributions will be licensed under the [MIT License](LICENSE).

### Medical Disclaimer
Remember that BluePills is for informational purposes only. Contributions should not provide medical advice or replace professional healthcare guidance.

### Privacy Commitment
All contributions must respect the privacy-first philosophy of BluePills:
- No unauthorized data collection
- User control over their data
- Transparent data handling
- Support for local-only usage

## 🚀 Development Setup

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK (included with Flutter)
- Git
- Your preferred IDE (VS Code, Android Studio, etc.)

### Quick Start
```bash
# Clone and setup
git clone https://github.com/your-username/BluePills.git
cd BluePills
./setup-automation.sh

# Run the app
flutter run

# Run tests
./scripts/test.sh

# Build for all platforms
./scripts/build.sh
```

### Development Tools
- **Pre-commit hooks**: Automatically format and check code
- **GitHub Actions**: CI/CD pipeline for testing and building
- **VS Code configuration**: Included for consistent development

## 🌟 Recognition

Contributors will be recognized in:
- **README.md** contributors section
- **GitHub releases** changelog
- **App about screen** (for significant contributions)

## 🤔 Questions?

- **General questions**: Use [GitHub Discussions](https://github.com/your-username/BluePills/discussions)
- **Security issues**: Use [private security advisories](https://github.com/your-username/BluePills/security/advisories/new)
- **Feature discussions**: Create a [feature request issue](https://github.com/your-username/BluePills/issues/new?template=feature_request.yml)

## 🎉 Thank You!

Every contribution helps make BluePills better for people managing their medications while maintaining privacy and control over their health data.

---

*Remember: Your contributions help create a more private, user-controlled alternative to traditional health apps. Thank you for supporting digital healthcare freedom!* 🏥💙