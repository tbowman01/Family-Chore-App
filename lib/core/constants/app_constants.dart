/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Family Chores';
  static const String appVersion = '0.1.0';

  // User Roles
  static const String roleParent = 'parent';
  static const String roleChild = 'child';

  // Chore Status
  static const String choreStatusActive = 'active';
  static const String choreStatusSubmitted = 'submitted';
  static const String choreStatusCompleted = 'completed';
  static const String choreStatusRejected = 'rejected';

  // Submission Status
  static const String submissionStatusPending = 'pending';
  static const String submissionStatusApproved = 'approved';
  static const String submissionStatusRejected = 'rejected';

  // Reward Types (Alpha: points only)
  static const String rewardTypePoints = 'points';

  // File Upload
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Notification Channels
  static const String notificationChannelId = 'family_chores_channel';
  static const String notificationChannelName = 'Family Chores Notifications';
  static const String notificationChannelDescription = 'Notifications for chore assignments and updates';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxChoreDescriptionLength = 500;
  static const int maxChoreTitleLength = 100;

  // Default Values
  static const int defaultChorePoints = 10;
  static const int minChorePoints = 1;
  static const int maxChorePoints = 1000;
}
