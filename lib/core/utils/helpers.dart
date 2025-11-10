import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Common helper functions
class Helpers {
  /// Formats a DateTime to a readable date string
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat(AppConstants.dateFormat).format(dateTime);
  }

  /// Formats a DateTime to a readable date and time string
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  /// Formats a DateTime to a readable time string
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat(AppConstants.timeFormat).format(dateTime);
  }

  /// Gets a relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Checks if a file size is within allowed limits
  static bool isFileSizeValid(int fileSizeBytes) {
    return fileSizeBytes <= AppConstants.maxImageSizeBytes;
  }

  /// Formats file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Gets a human-readable status text
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.choreStatusActive:
        return 'Active';
      case AppConstants.choreStatusSubmitted:
        return 'Submitted';
      case AppConstants.choreStatusCompleted:
        return 'Completed';
      case AppConstants.choreStatusRejected:
        return 'Rejected';
      case AppConstants.submissionStatusPending:
        return 'Pending Review';
      case AppConstants.submissionStatusApproved:
        return 'Approved';
      case AppConstants.submissionStatusRejected:
        return 'Rejected';
      default:
        return capitalize(status);
    }
  }

  /// Gets a human-readable role text
  static String getRoleText(String role) {
    switch (role.toLowerCase()) {
      case AppConstants.roleParent:
        return 'Parent';
      case AppConstants.roleChild:
        return 'Child';
      default:
        return capitalize(role);
    }
  }

  /// Validates image file extension
  static bool isValidImageExtension(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    return AppConstants.allowedImageExtensions.contains(extension);
  }

  /// Shows a snackbar message (helper for common UI pattern)
  static void showSnackBar(dynamic context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? const Color(0xFFB00020) : const Color(0xFF4CAF50),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Truncates text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
