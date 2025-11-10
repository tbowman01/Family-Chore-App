# Firebase Setup Guide

This guide will walk you through setting up Firebase for the Family Chores App.

---

## Prerequisites

- A Google account
- Flutter installed on your machine
- FlutterFire CLI (will be installed in this guide)

---

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `family-chores-app` (or your preferred name)
4. (Optional) Enable Google Analytics
5. Click **"Create project"**

---

## Step 2: Install FlutterFire CLI

The FlutterFire CLI makes it easy to configure your Flutter app with Firebase.

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Make sure it's in your PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

---

## Step 3: Configure Firebase for Flutter

Run the following command in your project root directory:

```bash
flutterfire configure
```

This will:
1. Prompt you to select your Firebase project
2. Select the platforms you want to support (iOS, Android, Web)
3. Generate platform-specific configuration files automatically
4. Create a `firebase_options.dart` file with your Firebase configuration

**Important:** Make sure to select the project you created in Step 1.

---

## Step 4: Enable Authentication

1. In Firebase Console, go to **Build > Authentication**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable **"Email/Password"** provider
5. Click **"Save"**

---

## Step 5: Create Firestore Database

1. In Firebase Console, go to **Build > Firestore Database**
2. Click **"Create database"**
3. Select **"Start in production mode"** (we'll add security rules later)
4. Choose a Firestore location (select closest to your users)
5. Click **"Enable"**

---

## Step 6: Set Up Firebase Storage

1. In Firebase Console, go to **Build > Storage**
2. Click **"Get started"**
3. Start in **production mode** (we'll add rules later)
4. Choose a location (same as Firestore)
5. Click **"Done"**

---

## Step 7: Deploy Security Rules

### Firestore Security Rules

1. In Firebase Console, go to **Firestore Database > Rules**
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Helper function to check if user is family member
    function isFamilyMember(familyId) {
      return isAuthenticated() &&
        request.auth.uid in get(/databases/$(database)/documents/families/$(familyId)).data.memberIds;
    }

    // Helper function to check if user is parent
    function isParent(familyId) {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/families/$(familyId)/members/$(request.auth.uid)).data.role == 'parent';
    }

    // Families collection
    match /families/{familyId} {
      // Only authenticated users can read their own family
      allow read: if isFamilyMember(familyId);
      // Only authenticated users can create families
      allow create: if isAuthenticated();
      // Only family members can update
      allow update: if isFamilyMember(familyId);

      // Members subcollection
      match /members/{memberId} {
        allow read: if isFamilyMember(familyId);
        allow create: if isAuthenticated();
        allow update: if isFamilyMember(familyId);
      }

      // Chores subcollection
      match /chores/{choreId} {
        allow read: if isFamilyMember(familyId);
        // Only parents can create/update/delete chores
        allow create, update, delete: if isParent(familyId);
      }

      // Submissions subcollection
      match /submissions/{submissionId} {
        allow read: if isFamilyMember(familyId);
        // Any family member can create submissions
        allow create: if isFamilyMember(familyId);
        // Only parents can update (approve/reject)
        allow update: if isParent(familyId);
      }
    }
  }
}
```

3. Click **"Publish"**

### Storage Security Rules

1. In Firebase Console, go to **Storage > Rules**
2. Replace the default rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /families/{familyId}/submissions/{submissionId}/{fileName} {
      // Allow authenticated users to upload to their family's submissions
      allow write: if request.auth != null &&
        request.resource.size < 5 * 1024 * 1024 && // Max 5MB
        request.resource.contentType.matches('image/.*');

      // Allow family members to read submission images
      allow read: if request.auth != null;
    }
  }
}
```

3. Click **"Publish"**

---

## Step 8: Update main.dart with Firebase Options

The `flutterfire configure` command should have created a `firebase_options.dart` file. Update your `main.dart` to import it:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ... rest of initialization
}
```

---

## Step 9: Run Flutter Pub Get

Install all dependencies:

```bash
flutter pub get
```

---

## Step 10: Test the Setup

Run the app on your preferred platform:

```bash
# For Android
flutter run -d android

# For iOS (Mac only)
flutter run -d ios

# For Web
flutter run -d chrome
```

---

## Troubleshooting

### Android Issues

If you encounter issues with Android:

1. Make sure `google-services.json` is in `android/app/`
2. Check that `android/build.gradle` has:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```
3. Check that `android/app/build.gradle` has:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### iOS Issues

If you encounter issues with iOS:

1. Make sure `GoogleService-Info.plist` is in `ios/Runner/`
2. Open `ios/Runner.xcworkspace` in Xcode
3. Make sure the plist file is added to the Runner target
4. Run `pod install` in the `ios/` directory

### Build Issues

If you get package resolution errors:

```bash
flutter clean
flutter pub get
```

---

## Next Steps

Once Firebase is set up:

1. Run the app to test authentication
2. Create a test account
3. Verify data is being saved to Firestore
4. Test image uploads to Storage

---

## Security Considerations

- ✅ Security rules are enforced at the Firebase level
- ✅ Family data is isolated - users can only access their own family
- ✅ Role-based access control (parents vs children)
- ✅ Image size limits enforced (5MB max)
- ⚠️ For production, consider adding rate limiting in Firebase
- ⚠️ Monitor Firebase usage to avoid unexpected costs

---

## Firebase Console Shortcuts

- **Authentication:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/authentication
- **Firestore:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/firestore
- **Storage:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/storage
- **Usage:** https://console.firebase.google.com/project/YOUR_PROJECT_ID/usage

---

**Last Updated:** November 10, 2025
