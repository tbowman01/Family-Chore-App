import '../constants/app_constants.dart';

/// Form validation utilities
class Validators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates name (not empty)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validates chore title
  static String? validateChoreTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Chore title is required';
    }

    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }

    if (value.length > AppConstants.maxChoreTitleLength) {
      return 'Title must be less than ${AppConstants.maxChoreTitleLength} characters';
    }

    return null;
  }

  /// Validates chore description
  static String? validateChoreDescription(String? value) {
    // Description is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.length > AppConstants.maxChoreDescriptionLength) {
      return 'Description must be less than ${AppConstants.maxChoreDescriptionLength} characters';
    }

    return null;
  }

  /// Validates point value
  static String? validatePoints(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Points are required';
    }

    final points = int.tryParse(value);
    if (points == null) {
      return 'Please enter a valid number';
    }

    if (points < AppConstants.minChorePoints) {
      return 'Points must be at least ${AppConstants.minChorePoints}';
    }

    if (points > AppConstants.maxChorePoints) {
      return 'Points cannot exceed ${AppConstants.maxChorePoints}';
    }

    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
