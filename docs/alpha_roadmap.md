# Family Chore App - Alpha Release Roadmap

**Target Release Date:** December 1, 2025
**Timeline:** November 10 - December 1, 2025 (21 days)
**Release Type:** Internal Alpha Testing

---

## 🎯 Alpha Release Objectives

- Deliver core MVP functionality for parent-child chore management
- Validate product-market fit with 5-10 test families
- Achieve >99% crash-free rate
- Gather user feedback for beta improvements

---

## 📋 Scope Definition

### ✅ IN SCOPE (Alpha)

**Authentication:**
- Email/password authentication only
- Role selection (Parent/Child)
- Basic profile creation
- Persistent login

**Parent Features:**
- Create/edit/delete chores (manual assignment)
- Assign chores to specific children
- Simple reward system (points only)
- Review photo submissions (approve/reject)
- View family dashboard

**Child Features:**
- View assigned chores list
- Upload single photo as proof
- View chore status (pending/completed)
- View accumulated points
- Basic notifications for new chores

**Technical:**
- Firebase Auth + Firestore + Storage
- Local notifications only
- Basic offline detection
- Error handling & loading states
- Simple email-based family invites

### ❌ OUT OF SCOPE (Deferred to Beta/GA)

- Google/Facebook OAuth
- Recurring/rotational scheduling
- Multiple families per user
- Money/time rewards (points only)
- Chore templates or categories
- Push notifications
- Export/reporting features
- Advanced analytics
- Comprehensive automated testing
- Parent collaboration features

---

## 🗓️ Implementation Timeline

### Week 1: Infrastructure & Core (Nov 10-16)

#### Days 1-2: Setup & Dependencies
- [ ] Update `pubspec.yaml` with latest stable packages
  - Firebase packages (^4.x)
  - Provider or Riverpod
  - Image picker (^1.0.0)
  - Flutter local notifications (^17.x)
- [ ] Run `flutter pub get`
- [ ] Create Firebase project in console
- [ ] Download `google-services.json` (Android)
- [ ] Download `GoogleService-Info.plist` (iOS)
- [ ] Configure `android/app/build.gradle`
- [ ] Configure `ios/Runner/Info.plist`
- [ ] Test Firebase initialization

#### Days 3-4: Core Architecture
- [ ] Create folder structure:
  ```
  lib/
  ├── core/
  │   ├── constants/
  │   │   ├── app_constants.dart
  │   │   └── firestore_constants.dart
  │   ├── theme/
  │   │   └── app_theme.dart
  │   └── utils/
  │       ├── validators.dart
  │       └── helpers.dart
  ├── models/
  │   ├── user_model.dart
  │   ├── family_model.dart
  │   ├── chore_model.dart
  │   ├── submission_model.dart
  │   └── reward_model.dart
  ├── services/
  │   ├── auth_service.dart
  │   ├── firestore_service.dart
  │   ├── storage_service.dart
  │   └── notification_service.dart
  ├── providers/
  │   ├── auth_provider.dart
  │   ├── chore_provider.dart
  │   └── family_provider.dart
  ├── screens/
  │   ├── auth/
  │   ├── parent/
  │   └── child/
  ├── widgets/
  │   ├── common/
  │   └── chore/
  └── routes/
      └── app_router.dart
  ```
- [ ] Create data models with toJson/fromJson
- [ ] Implement service layer structure

#### Days 5-7: Authentication System
- [ ] Build `AuthService` with Firebase Auth
  - Sign up with email/password
  - Sign in with email/password
  - Sign out
  - Password reset
  - Auth state stream
- [ ] Create auth screens:
  - Login screen
  - Signup screen
  - Role selection screen
  - Family creation/join screen
- [ ] Implement auth state provider
- [ ] Add form validation
- [ ] Test auth flow end-to-end

### Week 2: Parent Features (Nov 17-23)

#### Days 8-10: Chore Management
- [ ] Build `FirestoreService` base class
- [ ] Implement chore CRUD operations:
  - Create chore
  - Read chores (by family, by child)
  - Update chore
  - Delete chore
- [ ] Create parent screens:
  - Parent dashboard (chore overview)
  - Create chore screen
  - Edit chore screen
  - Assign chore screen (select child)
- [ ] Build chore list widgets
- [ ] Add chore form with validation

#### Days 11-12: Review System
- [ ] Implement submission queries in Firestore
- [ ] Create submission review screen
- [ ] Add approve/reject functionality
- [ ] Update chore status on approval
- [ ] Award points to child on approval
- [ ] Build submission card widget with image preview

#### Day 13: Parent Dashboard Polish
- [ ] Add dashboard statistics
  - Total active chores
  - Pending reviews
  - Completed this week
- [ ] Implement filtering/sorting
- [ ] Add empty states
- [ ] Error handling for all operations

### Week 3: Child Features & Integration (Nov 24-30)

#### Days 14-15: Child Dashboard
- [ ] Build child dashboard screen
  - My assigned chores
  - Completed chores
  - Total points earned
- [ ] Create chore detail screen
- [ ] Implement chore status badges
- [ ] Add pull-to-refresh

#### Days 16-17: Photo Upload
- [ ] Implement `StorageService`
- [ ] Integrate image_picker
- [ ] Add photo upload screen
  - Camera capture
  - Gallery selection
  - Image preview
- [ ] Upload to Firebase Storage
- [ ] Create submission in Firestore
- [ ] Link submission to chore
- [ ] Add upload progress indicator

#### Day 18: Notifications
- [ ] Implement `NotificationService`
- [ ] Request notification permissions
- [ ] Schedule local notification when:
  - Parent assigns new chore
  - Parent approves/rejects submission
- [ ] Handle notification taps
- [ ] Add notification settings screen

#### Days 19-20: Security & Error Handling
- [ ] Write Firestore Security Rules:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /families/{familyId} {
        allow read, write: if request.auth != null &&
          request.auth.uid in resource.data.memberIds;

        match /chores/{choreId} {
          allow read: if request.auth != null &&
            request.auth.uid in get(/databases/$(database)/documents/families/$(familyId)).data.memberIds;
          allow write: if request.auth != null &&
            get(/databases/$(database)/documents/families/$(familyId)/members/$(request.auth.uid)).data.role == 'parent';
        }

        match /submissions/{submissionId} {
          allow read: if request.auth != null &&
            request.auth.uid in get(/databases/$(database)/documents/families/$(familyId)).data.memberIds;
          allow create: if request.auth != null;
          allow update: if request.auth != null &&
            get(/databases/$(database)/documents/families/$(familyId)/members/$(request.auth.uid)).data.role == 'parent';
        }
      }
    }
  }
  ```
- [ ] Write Storage Security Rules
- [ ] Add try-catch blocks to all async operations
- [ ] Implement error message widgets
- [ ] Add loading states to all screens
- [ ] Test offline scenarios

#### Day 21: Final Testing & Preparation
- [ ] Manual testing checklist:
  - [ ] Parent can create account and family
  - [ ] Child can join family
  - [ ] Parent can create and assign chore
  - [ ] Child receives notification
  - [ ] Child can view chore
  - [ ] Child can upload photo
  - [ ] Parent can review submission
  - [ ] Points are awarded correctly
  - [ ] App handles network errors
  - [ ] App works after restart
- [ ] Configure Firebase App Distribution
- [ ] Prepare release notes
- [ ] Create simple privacy policy page
- [ ] Build release APK/IPA
- [ ] Deploy to Firebase App Distribution

---

## 📊 Data Model Structure

### Firestore Collections

```
families/
  {familyId}/
    name: string
    createdBy: string (userId)
    createdAt: timestamp
    memberIds: array<string>

    members/
      {userId}/
        name: string
        email: string
        role: 'parent' | 'child'
        totalPoints: number
        avatarUrl: string (optional)

    chores/
      {choreId}/
        title: string
        description: string
        pointValue: number
        assignedTo: string (userId)
        createdBy: string (userId)
        status: 'active' | 'submitted' | 'completed' | 'rejected'
        dueDate: timestamp (optional)
        createdAt: timestamp
        completedAt: timestamp (optional)

    submissions/
      {submissionId}/
        choreId: string
        submittedBy: string (userId)
        imageUrl: string
        status: 'pending' | 'approved' | 'rejected'
        submittedAt: timestamp
        reviewedAt: timestamp (optional)
        reviewedBy: string (userId, optional)
        reviewNotes: string (optional)
```

### Storage Structure

```
families/{familyId}/submissions/{submissionId}/{timestamp}.jpg
```

---

## 🔒 Security Checklist

- [ ] Firestore Security Rules deployed
- [ ] Storage Security Rules deployed
- [ ] Family data isolation enforced
- [ ] Role-based access control (parent vs child)
- [ ] Email verification enabled
- [ ] Input validation on all forms
- [ ] Image file size limits (max 5MB)
- [ ] Rate limiting considered

---

## 🚀 Release Criteria

### Must-Have (Blockers)
- ✅ All critical user flows work end-to-end
- ✅ No app crashes during basic operations
- ✅ Firebase security rules deployed
- ✅ Auth persists across app restarts
- ✅ Photos upload successfully

### Should-Have (Important)
- ✅ Graceful offline handling
- ✅ Loading states on all async operations
- ✅ Error messages displayed to users
- ✅ Basic notification system works
- ✅ Points calculated correctly

### Nice-to-Have (Polish)
- ⚠️ Smooth animations
- ⚠️ Comprehensive empty states
- ⚠️ Onboarding tutorial
- ⚠️ Custom app icon
- ⚠️ Splash screen

---

## 📈 Success Metrics (Alpha)

**Technical:**
- Crash-free rate: >99%
- Average app load time: <2s
- Photo upload success rate: >95%

**User Engagement:**
- 5-10 test families onboarded
- At least 50 chores created
- At least 80% chore completion rate
- Daily active usage by at least 3 families

**Feedback:**
- Collect qualitative feedback via survey
- Identify top 3 pain points
- Validate core value proposition

---

## 🐛 Known Limitations (Alpha)

- Email authentication only (no social login)
- Manual chore assignment only (no automation)
- Points only (no money/time tracking)
- Local notifications only (no push)
- Single family per user
- No data export functionality
- Limited error recovery
- Basic UI (following mockups but minimal polish)

---

## 📝 Post-Alpha Plans (Beta Roadmap Preview)

**High Priority:**
- Recurring chore scheduling (daily/weekly)
- Push notifications via FCM
- Money & time reward types
- Chore templates
- Improved onboarding flow

**Medium Priority:**
- Google/Facebook OAuth
- Parent collaboration (multiple parents)
- Chore categories and tags
- Basic reporting/analytics

**Lower Priority:**
- Multiple families per user
- Chore rotation system
- Export data to CSV
- Advanced customization

---

## 🔗 Related Documents

- [User Guide](./user_guide.md) - End-user documentation
- [Workflow Diagram](./workflow_diagram.md) - App flow visualization
- [README](../README.md) - Project overview

---

**Document Version:** 1.0
**Last Updated:** November 10, 2025
**Next Review:** November 20, 2025 (midpoint check-in)
