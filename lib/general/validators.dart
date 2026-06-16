import 'package:flutter/material.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/models/reminder.dart';

typedef Validator = String? Function(String? value);

class Validators {
  // Required / non-null check
  static Validator required(String fieldName) => (String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName should not be empty.';
    }
    return null;
  };

  // Length check
  static Validator length(String fieldName, int minLength, int maxLength) =>
      (String? value) {
        if (value != null) {
          final len = value.trim().length;
          if (len < minLength || len > maxLength) {
            return '$fieldName must have $minLength to $maxLength characters.';
          }
        }
        return null;
      };

  // Range check
  static Validator range(String fieldName, int min, int max) =>
      (String? value) {
        if (value != null) {
          int num = int.parse(value);
          if (num < min || num > max) {
            return '$fieldName must be between $min - $max';
          }
        }
        return null;
      };

  // Name pattern check
  static Validator name([String fieldName = 'Name']) => (String? value) {
    final requiredError = required('Name')(value);
    if (requiredError != null) return requiredError;

    final lengthError = length('Name', 2, 50)(value);
    if (lengthError != null) return lengthError;

    if (value != null && !RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes.';
    }
    return null;
  };

  // Title clashing check
  static Validator title([
    String fieldName = 'Title',
    Reminder? currentReminder,
  ]) => (String? value) {
    if (value != null &&
        DataService.allReminders.any(
          (r) => r.id != currentReminder?.id && r.title == value,
        )) {
      return '$fieldName has been used for other reminders.';
    }
    return null;
  };

  // Email pattern check — required
  static Validator email() => (String? value) {
    final requiredError = required('Email')(value);
    if (requiredError != null) return requiredError;

    if (value != null &&
        !RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        ).hasMatch(value)) {
      return 'Invalid email format.';
    }
    return null;
  };

  // Email pattern check — optional (can be left blank)
  static Validator emailOptional() => (String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value.trim())) {
      return 'Invalid email format.';
    }
    return null;
  };

  static Validator icOrPassport() => (String? value) {
    final error = required('IC/Passport')(value);
    if (error != null) return error;

    final trimmed = value!.trim();
    final icRegex = RegExp(r'^\d{12}$');
    final passportRegex = RegExp(r'^[A-Za-z0-9]{6,9}$');

    if (!icRegex.hasMatch(trimmed) && !passportRegex.hasMatch(trimmed)) {
      return 'Invalid IC or Passport number.';
    }
    return null;
  };

  static Validator phone() => (String? value) {
    final error = required('Phone Number')(value);
    if (error != null) return error;

    final trimmed = value!.trim().replaceAll(RegExp(r'[^\d+]'), '');
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Invalid phone format.';
    }
    return null;
  };

  // Card Number Validator (Luhn Algorithm + Length)
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty)
      return "Card number should not be empty.";

    final clean = value.replaceAll(RegExp(r'\D'), '');

    if (clean.length < 13 || clean.length > 19) {
      return "Invalid card number length.";
    }

    if (!RegExp(r'^(4|5[1-5]|2[2-7]|3[47]|6)').hasMatch(clean)) {
      return "Unsupported card type.";
    }
    return null;
  }

  // Validate expiry date of card
  static String? validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return "Expiry date should not be empty.";
    }

    final match = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').firstMatch(value);
    if (match == null) {
      return "Invalid expiry date format.";
    }

    final month = int.parse(match.group(1)!);
    final year = int.parse(match.group(2)!);
    final now = DateTime.now();
    final currentYear = now.year % 100;

    if (year < currentYear || (year == currentYear && month < now.month)) {
      return "Card expired.";
    }
    return null;
  }

  // CVV Validator
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) return "CVV should not be empty.";
    if (value.length < 3 || value.length > 4) {
      return "CVV should have only 3-4 digits.";
    }
    return null;
  }

  // Validate policy number
  static Validator validatePolicyNumber() => (String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Policy number is required.';
    }
    if (!RegExp(r'^[A-Za-z0-9#\-\/]+$').hasMatch(value.trim())) {
      return 'Invalid policy number format.';
    }
    return null;
  };

  // Validate insurance expiry date
  static Validator validateInsuranceExpiry() => (String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required.';
    }

    final match =
        RegExp(r'^(0[1-9]|1[0-2])\s*\/\s*(\d{4})$').firstMatch(value);

    if (match == null) {
      return 'Invalid expiry date format.';
    }

    final month = int.parse(match.group(1)!);
    final year = int.parse(match.group(2)!);
    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0);

    if (expiryDate.isBefore(now)) {
      return 'Insurance has expired.';
    }
    return null;
  };

  // Password rules
  static Validator password({int minLength = 12, int maxLength = 15}) =>
      (String? value) {
        final requiredError = required('Password')(value);
        if (requiredError != null) return requiredError;

        final lengthError = length('Password', 2, 50)(value);
        if (lengthError != null) return lengthError;

        if (value != null && !RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least 1 uppercase letter.';
        }
        if (value != null && !RegExp(r'[a-z]').hasMatch(value)) {
          return 'Password must contain at least 1 lowercase letter.';
        }
        if (value != null &&
            !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return 'Password must contain at least 1 special character.';
        }
        return null;
      };

  static Validator matchPassword(TextEditingController passwordController) {
    return (String? value) {
      final requiredError = required('Confirm Password')(value);
      if (requiredError != null) return requiredError;

      if (value != passwordController.text) {
        return 'Passwords do not match.';
      }
      return null;
    };
  }

  // Combines multiple validators
  static Validator combine(List<Validator> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}