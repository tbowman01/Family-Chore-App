# Family Chores App 👨‍👩‍👧‍👦

A cross-platform Flutter app for managing family chores with role-based access, reminders, and rewards.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📖 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Features](#features)
- [Project Structure](#project-structure)
- [Development](#development)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## 🎯 Overview

The Family Chores App is designed to help families manage household chores effectively by:

- **Empowering Parents** - Assign, track, and review chores with ease
- **Encouraging Responsibility** - Motivate children through a reward system
- **Ensuring Accountability** - Photo proof verification for completed tasks
- **Timely Reminders** - Local notifications to keep everyone on track
- **Role-Based Experience** - Tailored interfaces for parents and children

### Current Status: Alpha Release v0.1.0

This is an alpha version with core features implemented. See [CURRENT_STATUS.md](docs/CURRENT_STATUS.md) for details.

---

## ⚡ Quick Start

### For Developers

```bash
# 1. Clone the repository
git clone <repository-url>
cd Family-Chore-App

# 2. Complete setup (installs dependencies & configures Firebase)
make setup

# 3. Run the app
make run
```

### For Testers/Users

```bash
# Quick start for testers
make quick-start

# Run the app
make run
```

**First time setup?** See our [Quick Start Guide](docs/quick_start.md) for detailed instructions.

---

## ✨ Features

### Authentication & Setup
- ✅ Email/Password authentication
- ✅ Parent/Child role selection
- ✅ Family creation and joining via Family ID
- ✅ Password reset functionality

### Parent Features
- ✅ Create, edit, and delete chores
- ✅ Assign chores to specific children
- ✅ Review photo proof submissions
- ✅ Approve/reject submissions with feedback
- ✅ View all family members
- ✅ Manage points and rewards

### Child Features
- ✅ View assigned chores
- ✅ Filter chores by status (pending, submitted, approved)
- ✅ Upload photo proof via camera or gallery
- ✅ Track earned points
- ✅ View submission status and feedback

### Technical Highlights
- ✅ Real-time data synchronization (Firebase)
- ✅ Offline support with local caching
- ✅ Material Design 3 UI
- ✅ Comprehensive error handling
- ✅ Form validation
- ✅ Loading states and user feedback

### Alpha Limitations
- ❌ Google/Facebook login (Email only)
- ❌ Recurring/scheduled chores
- ❌ Push notifications (local only)
- ❌ Multiple families per user
- ❌ Money/time rewards (points only)
- ❌ Chore templates
- ❌ Analytics dashboard

---

## 📁 Project Structure

```
Family-Chore-App/
├── lib/
│   ├── core/              # Core utilities, constants, and theme
│   ├── models/            # Data models (User, Chore, Family, etc.)
│   ├── providers/         # State management (Provider pattern)
│   ├── screens/           # UI screens
│   │   ├── auth/          # Login, signup, role selection
│   │   ├── parent/        # Parent dashboard, chore management
│   │   └── child/         # Child dashboard, chore completion
│   ├── services/          # Firebase services and business logic
│   └── widgets/           # Reusable UI components
├── docs/                  # Documentation
├── assets/                # Images, mockups, and resources
├── Makefile              # Task automation by persona
└── pubspec.yaml          # Dependencies and configuration
```

For detailed architecture, see [alpha_roadmap.md](docs/alpha_roadmap.md).

---

## 🛠️ Development

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Firebase account (free tier)
- Android Studio / Xcode (for emulators)
- Git

### Common Commands

The project uses a **Makefile organized by persona** for easy task management:

#### 👨‍💻 Developer Commands

```bash
make setup              # Initial setup (first time)
make run                # Run in debug mode
make test               # Run all tests
make lint               # Run linter
make format             # Format code
make build-android      # Build Android APK
```

#### 🧪 Testing & Quality

```bash
make test               # Run tests
make test-coverage      # Run with coverage
make check-all          # Format check + lint + test
make pre-commit         # Pre-commit checks
```

#### 🧹 Maintenance

```bash
make clean              # Clean build artifacts
make update-deps        # Update dependencies
make doctor             # Run Flutter doctor
```

#### 🆘 Troubleshooting

```bash
make troubleshoot       # Show troubleshooting guide
make debug-info         # Show debug information
make list-devices       # List connected devices
```

**See all commands:** `make help`

### Development Workflow

```bash
# 1. Create a new branch
git checkout -b feature/your-feature

# 2. Make changes and test
make dev-workflow       # Clean, install, lint, test, run

# 3. Before committing
make pre-commit         # Format, lint, test

# 4. Commit and push
git add .
git commit -m "feat: your feature description"
git push origin feature/your-feature
```

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Quick Start Guide](docs/quick_start.md) | Get started in 15 minutes |
| [User Guide](docs/user_guide.md) | How to use the app |
| [Firebase Setup](docs/firebase_setup.md) | Detailed Firebase configuration |
| [Current Status](docs/CURRENT_STATUS.md) | What's implemented and what's not |
| [Alpha Roadmap](docs/alpha_roadmap.md) | Development roadmap and architecture |
| [Progress Summary](docs/progress_summary.md) | Implementation progress |

### Quick References

```bash
make docs               # View documentation
make learn              # Show learning resources
make show-architecture  # Display project structure
```

---

## 🐛 Troubleshooting

### Common Issues

**Build Errors**
```bash
make clean
make install-flutter-deps
make run
```

**Firebase Not Initialized**
```bash
make setup-firebase
```

**Can't Find Device**
```bash
make list-devices
flutter devices
```

**Outdated Dependencies**
```bash
make update-deps
```

**Environment Issues**
```bash
make doctor
```

For more help, see [Quick Start Guide - Troubleshooting](docs/quick_start.md#troubleshooting) or run:
```bash
make troubleshoot
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Run quality checks** (`make pre-commit`)
5. **Commit your changes** (`git commit -m 'feat: add amazing feature'`)
6. **Push to the branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

### Code Quality Standards

- Run `make format` before committing
- Ensure `make lint` passes
- Add tests for new features
- Update documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Backend powered by [Firebase](https://firebase.google.com/)
- State management via [Provider](https://pub.dev/packages/provider)

---

## 📞 Support

- **Documentation**: See [docs/](docs/) directory
- **Issues**: Open an issue on GitHub
- **Questions**: Check [Quick Start Guide](docs/quick_start.md)

---

## 🗺️ Roadmap

See [alpha_roadmap.md](docs/alpha_roadmap.md) for detailed development plans.

### Coming in Beta
- 🔄 Recurring chores
- 🔔 Push notifications
- 🔑 Social login (Google, Facebook)
- 💰 Multiple reward types
- 📊 Analytics dashboard
- 📱 Multiple families per user

---

**Made with ❤️ for families**
