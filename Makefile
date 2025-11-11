# Family Chores App - Makefile
# Organized by persona and common tasks

.PHONY: help
.DEFAULT_GOAL := help

##@ General

help: ## Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\033[0m\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ 👨‍💻 Developer - Initial Setup

setup: ## Complete initial setup for new developers
	@echo "🚀 Starting initial setup..."
	@make install-flutter-deps
	@make setup-firebase
	@echo "✅ Setup complete! Run 'make run' to start the app"

install-flutter-deps: ## Install Flutter dependencies
	@echo "📦 Installing Flutter dependencies..."
	flutter pub get
	@echo "✅ Dependencies installed"

setup-firebase: ## Configure Firebase (interactive)
	@echo "🔥 Setting up Firebase..."
	@echo "Make sure you have:"
	@echo "  1. Created a Firebase project at https://console.firebase.google.com"
	@echo "  2. Installed FlutterFire CLI: dart pub global activate flutterfire_cli"
	@echo ""
	@read -p "Press Enter to continue with Firebase configuration..." dummy
	flutterfire configure
	@echo "✅ Firebase configured"

install-flutterfire-cli: ## Install FlutterFire CLI globally
	@echo "🔧 Installing FlutterFire CLI..."
	dart pub global activate flutterfire_cli
	@echo "Add to PATH: export PATH=\"\$$PATH\":\"\$$HOME/.pub-cache/bin\""
	@echo "✅ FlutterFire CLI installed"

check-env: ## Check development environment
	@echo "🔍 Checking environment..."
	@echo "Flutter version:"
	@flutter --version
	@echo "\n📱 Available devices:"
	@flutter devices
	@echo "\n🔥 FlutterFire CLI:"
	@which flutterfire || echo "Not installed - run 'make install-flutterfire-cli'"

##@ 🏃 Developer - Running & Testing

run: ## Run app in debug mode
	@echo "🏃 Running app in debug mode..."
	flutter run

run-release: ## Run app in release mode
	@echo "🏃 Running app in release mode..."
	flutter run --release

run-android: ## Run app on Android device/emulator
	@echo "🤖 Running on Android..."
	flutter run -d android

run-ios: ## Run app on iOS simulator (Mac only)
	@echo "🍎 Running on iOS..."
	flutter run -d ios

run-web: ## Run app in Chrome
	@echo "🌐 Running on web..."
	flutter run -d chrome

hot-reload: ## Run with hot reload enabled (default)
	@echo "🔥 Running with hot reload..."
	flutter run --hot

##@ 🧪 Developer - Testing & Quality

test: ## Run all unit and widget tests
	@echo "🧪 Running tests..."
	flutter test

test-coverage: ## Run tests with coverage report
	@echo "🧪 Running tests with coverage..."
	flutter test --coverage
	@echo "📊 Coverage report generated in coverage/lcov.info"

lint: ## Run Flutter linter
	@echo "🔍 Running linter..."
	flutter analyze

format: ## Format Dart code
	@echo "✨ Formatting code..."
	dart format lib/ test/ -l 120

format-check: ## Check code formatting without making changes
	@echo "🔍 Checking code format..."
	dart format lib/ test/ -l 120 --set-exit-if-changed

check-all: format-check lint test ## Run all code quality checks

##@ 🔨 Developer - Build & Release

build-android: ## Build Android APK
	@echo "🔨 Building Android APK..."
	flutter build apk --release
	@echo "✅ APK built: build/app/outputs/flutter-apk/app-release.apk"

build-android-bundle: ## Build Android App Bundle (for Play Store)
	@echo "🔨 Building Android App Bundle..."
	flutter build appbundle --release
	@echo "✅ Bundle built: build/app/outputs/bundle/release/app-release.aab"

build-ios: ## Build iOS app (Mac only)
	@echo "🔨 Building iOS app..."
	flutter build ios --release
	@echo "✅ iOS app built"

build-web: ## Build web app
	@echo "🔨 Building web app..."
	flutter build web --release
	@echo "✅ Web app built in build/web/"

build-all: build-android build-android-bundle build-web ## Build for all platforms (except iOS)

##@ 📱 User/Tester - Quick Start

quick-start: ## Quick start guide for testers
	@echo "📱 Family Chores App - Quick Start"
	@echo ""
	@echo "1️⃣  First time? Run: make setup"
	@echo "2️⃣  Start the app: make run"
	@echo "3️⃣  View docs: make docs"
	@echo ""
	@echo "📚 Full guide: docs/quick_start.md"

demo: ## Run app with demo/test data
	@echo "🎮 Starting demo mode..."
	@echo "⚠️  Demo mode not implemented yet"
	@echo "Run 'make run' and create test accounts manually"

docs: ## Open documentation
	@echo "📚 Documentation available:"
	@echo "  - Quick Start Guide: docs/quick_start.md"
	@echo "  - User Guide: docs/user_guide.md"
	@echo "  - Firebase Setup: docs/firebase_setup.md"
	@echo "  - Project Status: docs/CURRENT_STATUS.md"
	@echo ""
	@echo "Opening Quick Start Guide..."
	@cat docs/quick_start.md

##@ 🧹 Maintainer - Cleanup & Updates

clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	flutter clean
	@echo "✅ Clean complete"

deep-clean: clean ## Deep clean including dependencies
	@echo "🧹 Deep cleaning..."
	rm -rf .dart_tool
	rm -rf build
	rm -rf .flutter-plugins
	rm -rf .flutter-plugins-dependencies
	rm -rf pubspec.lock
	@echo "Run 'make install-flutter-deps' to reinstall dependencies"
	@echo "✅ Deep clean complete"

update-deps: ## Update Flutter dependencies
	@echo "⬆️  Updating dependencies..."
	flutter pub upgrade
	@echo "✅ Dependencies updated"

outdated: ## Check for outdated dependencies
	@echo "🔍 Checking for outdated packages..."
	flutter pub outdated

doctor: ## Run Flutter doctor
	@echo "🏥 Running Flutter doctor..."
	flutter doctor -v

##@ 🔥 Maintainer - Firebase Management

firebase-deploy-rules: ## Deploy Firestore security rules
	@echo "🔥 Deploying Firestore rules..."
	@echo "⚠️  Not implemented - Deploy manually from Firebase Console"
	@echo "See: docs/firebase_setup.md for rules"

firebase-backup: ## Backup Firestore data
	@echo "💾 Backing up Firestore..."
	@echo "⚠️  Not implemented - Use Firebase Console or gcloud CLI"
	@echo "See: https://firebase.google.com/docs/firestore/manage-data/export-import"

firebase-info: ## Show Firebase project info
	@echo "🔥 Firebase Project Info:"
	@echo "Run: firebase projects:list"
	@echo "Or visit: https://console.firebase.google.com/"

##@ 🤝 Contributor - Code Quality

pre-commit: format lint test ## Run pre-commit checks
	@echo "✅ Pre-commit checks passed!"

code-review: ## Run comprehensive code review checks
	@echo "👀 Running code review checks..."
	@make format-check
	@make lint
	@make test
	@echo "✅ Code review checks complete"

fix-format: ## Auto-fix code formatting issues
	@echo "🔧 Auto-fixing format issues..."
	dart format lib/ test/ -l 120
	@echo "✅ Format issues fixed"

##@ 📊 Maintainer - Monitoring & Logs

logs-android: ## View Android logs
	@echo "📊 Viewing Android logs..."
	adb logcat | grep flutter

logs-ios: ## View iOS logs (Mac only)
	@echo "📊 Viewing iOS logs..."
	@echo "Use Xcode or: instruments -s devices"

list-devices: ## List connected devices
	@echo "📱 Connected devices:"
	flutter devices

##@ 🎯 Common Workflows

# Full development workflow
dev-workflow: clean install-flutter-deps lint test run ## Complete development workflow

# Prepare for release
release-prep: clean install-flutter-deps check-all build-all ## Prepare for release

# Quick code check before commit
quick-check: format lint ## Quick code quality check

# Reset everything and start fresh
reset: deep-clean install-flutter-deps ## Reset environment to clean state
	@echo "✅ Environment reset complete"

##@ 🆘 Troubleshooting

troubleshoot: ## Common troubleshooting steps
	@echo "🆘 Troubleshooting Guide:"
	@echo ""
	@echo "Problem: Build errors"
	@echo "  → Solution: make clean && make install-flutter-deps"
	@echo ""
	@echo "Problem: Firebase not initialized"
	@echo "  → Solution: make setup-firebase"
	@echo ""
	@echo "Problem: Can't find device"
	@echo "  → Solution: make list-devices"
	@echo ""
	@echo "Problem: Outdated dependencies"
	@echo "  → Solution: make update-deps"
	@echo ""
	@echo "Problem: Environment issues"
	@echo "  → Solution: make doctor"
	@echo ""
	@echo "For more help, see docs/quick_start.md"

debug-info: ## Show debug information
	@echo "🐛 Debug Information:"
	@echo ""
	@make doctor
	@echo ""
	@make list-devices
	@echo ""
	@echo "Git Branch:"
	@git branch --show-current
	@echo ""
	@echo "Git Status:"
	@git status --short

##@ 📦 Platform-Specific

android-clean: ## Clean Android build
	@echo "🧹 Cleaning Android build..."
	cd android && ./gradlew clean
	@echo "✅ Android clean complete"

ios-clean: ## Clean iOS build (Mac only)
	@echo "🧹 Cleaning iOS build..."
	cd ios && rm -rf Pods Podfile.lock
	cd ios && pod install
	@echo "✅ iOS clean complete"

android-dependencies: ## Update Android dependencies
	@echo "⬆️  Updating Android dependencies..."
	cd android && ./gradlew dependencies

ios-pods: ## Update iOS pods (Mac only)
	@echo "⬆️  Updating iOS pods..."
	cd ios && pod update

##@ 🎓 Learning & Documentation

learn: ## Show learning resources
	@echo "🎓 Learning Resources:"
	@echo ""
	@echo "Flutter Documentation:"
	@echo "  → https://docs.flutter.dev"
	@echo ""
	@echo "Firebase Documentation:"
	@echo "  → https://firebase.google.com/docs"
	@echo ""
	@echo "Project Documentation:"
	@echo "  → docs/quick_start.md - Getting started"
	@echo "  → docs/user_guide.md - Using the app"
	@echo "  → docs/firebase_setup.md - Firebase setup"
	@echo "  → docs/alpha_roadmap.md - Development roadmap"

show-architecture: ## Show project architecture
	@echo "🏗️  Project Architecture:"
	@echo ""
	@echo "lib/"
	@echo "├── core/              # Core utilities and constants"
	@echo "├── models/            # Data models"
	@echo "├── providers/         # State management (Provider)"
	@echo "├── screens/           # UI screens"
	@echo "│   ├── auth/          # Authentication screens"
	@echo "│   ├── parent/        # Parent-specific screens"
	@echo "│   └── child/         # Child-specific screens"
	@echo "├── services/          # Business logic & Firebase"
	@echo "└── widgets/           # Reusable UI components"
	@echo ""
	@echo "For more details, see docs/alpha_roadmap.md"

##@ 🚀 Quick Commands (Most Used)

.PHONY: dev test-app build release

dev: run ## Alias for 'run' (most common command)

test-app: test ## Alias for 'test'

build: build-android ## Alias for 'build-android'

release: release-prep ## Alias for 'release-prep'
