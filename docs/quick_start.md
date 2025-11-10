# Family Chores App - Quick Start Guide

Get your Family Chores App running in minutes!

---

## Prerequisites

- ✅ Flutter installed (you confirmed this)
- Google account for Firebase
- Android Studio/Xcode (for emulator) or physical device

---

## Step 1: Firebase Setup (15 minutes)

### 1.1 Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 1.2 Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Name it: `family-chores-app`
4. Follow the wizard (Google Analytics optional)

### 1.3 Configure Flutter App

```bash
cd /home/user/Family-Chore-App
flutterfire configure
```

Select your Firebase project and platforms (Android/iOS).

### 1.4 Enable Firebase Services

**In Firebase Console:**

1. **Authentication**
   - Go to Build > Authentication
   - Click "Get started"
   - Enable "Email/Password"

2. **Firestore Database**
   - Go to Build > Firestore Database
   - Click "Create database"
   - Choose "Start in production mode"
   - Select your region

3. **Storage**
   - Go to Build > Storage
   - Click "Get started"
   - Choose "Start in production mode"

### 1.5 Deploy Security Rules

**Firestore Rules** (Build > Firestore Database > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }

    function isFamilyMember(familyId) {
      return isAuthenticated() &&
        request.auth.uid in get(/databases/$(database)/documents/families/$(familyId)).data.memberIds;
    }

    function isParent(familyId) {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/families/$(familyId)/members/$(request.auth.uid)).data.role == 'parent';
    }

    match /families/{familyId} {
      allow read: if isFamilyMember(familyId);
      allow create: if isAuthenticated();
      allow update: if isFamilyMember(familyId);

      match /members/{memberId} {
        allow read: if isFamilyMember(familyId);
        allow create: if isAuthenticated();
        allow update: if isFamilyMember(familyId);
      }

      match /chores/{choreId} {
        allow read: if isFamilyMember(familyId);
        allow create, update, delete: if isParent(familyId);
      }

      match /submissions/{submissionId} {
        allow read: if isFamilyMember(familyId);
        allow create: if isFamilyMember(familyId);
        allow update: if isParent(familyId);
      }
    }
  }
}
```

**Storage Rules** (Build > Storage > Rules):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /families/{familyId}/submissions/{submissionId}/{fileName} {
      allow write: if request.auth != null &&
        request.resource.size < 5 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*');
      allow read: if request.auth != null;
    }
  }
}
```

---

## Step 2: Install Dependencies (2 minutes)

```bash
cd /home/user/Family-Chore-App
flutter pub get
```

---

## Step 3: Run the App (1 minute)

### Option A: Android Emulator

```bash
# Start emulator (if not already running)
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

### Option B: Physical Device

1. Enable Developer Mode on your device
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### Option C: iOS Simulator (Mac only)

```bash
open -a Simulator
flutter run
```

---

## Step 4: Test the App

### Create Parent Account
1. Tap "Create Account"
2. Enter name, email, password
3. Select "Parent" role
4. Create a new family
5. Note your Family ID

### Create Child Account
1. Open app in another device/emulator
2. Create account with different email
3. Select "Child" role
4. Use the Family ID to join

### Test Core Flow
1. **Parent**: Create a chore and assign to child
2. **Child**: View assigned chore
3. **Child**: Take/upload photo and submit
4. **Parent**: Review submission and approve
5. **Child**: Check points balance

---

## Troubleshooting

### "Firebase not initialized" error
- Make sure you ran `flutterfire configure`
- Check that `lib/firebase_options.dart` exists
- Verify Firebase services are enabled in console

### "Permission denied" in Firestore
- Verify security rules are deployed
- Check that rules allow the operation
- Ensure user is authenticated

### Image upload fails
- Check Storage rules are deployed
- Verify image is under 5MB
- Check internet connection

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Can't find device
```bash
flutter devices
```

---

## What's Included ✅

**Authentication:**
- ✅ Email/password signup & login
- ✅ Password reset
- ✅ Role selection (parent/child)
- ✅ Family creation/joining

**Parent Features:**
- ✅ Create/edit/delete chores
- ✅ Assign chores to children
- ✅ Review photo submissions
- ✅ Approve/reject with feedback
- ✅ View family members
- ✅ Points management

**Child Features:**
- ✅ View assigned chores
- ✅ Filter by status
- ✅ Upload photo proof (camera/gallery)
- ✅ Track points
- ✅ View submission status

**Technical:**
- ✅ Real-time data sync
- ✅ Offline-friendly (Firebase caching)
- ✅ Loading states
- ✅ Error handling
- ✅ Form validation
- ✅ Material Design 3 UI

---

## What's NOT Included (Alpha Limitations)

- ❌ Google/Facebook login
- ❌ Recurring/scheduled chores
- ❌ Push notifications (local only)
- ❌ Multiple families per user
- ❌ Money/time rewards (points only)
- ❌ Chore templates
- ❌ Advanced analytics

---

## Next Steps

1. **Test thoroughly** - Try all user flows
2. **Report issues** - Note any bugs or UX problems
3. **Gather feedback** - Get 5-10 test families using it
4. **Plan improvements** - Prioritize features for beta

---

## Need Help?

- **Firebase Setup:** See `docs/firebase_setup.md`
- **Architecture:** See `docs/alpha_roadmap.md`
- **Progress:** See `docs/progress_summary.md`

---

**Happy coding! 🚀**
