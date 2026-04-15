import 'package:flutter/material.dart';

enum NotificationCategory { 
  queue,      // High Priority: "You are next!"
  medication, // Routine: "Time for your 2pm pill"
  custom,
  appointment,// Updates: "Dr. Ali is delayed"
  billing,    // Financial: "Statement ready" or "Late Payment"
  reports,    // Medical Results
  general     // Info/Tips/Notice
}

class AppNotification {
  final String id;
  final NotificationCategory category;
  final String? subjectName;    
  final String? customMessage; 
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.category,
    this.subjectName,
    this.customMessage,
    required this.timestamp,
    this.isRead = false,
  });

  // Check if bill is older than 14 days (2 weeks)
  bool get isLateBill {
    if (category != NotificationCategory.billing) return false;
    return DateTime.now().difference(timestamp).inDays >= 14;
  }

  // Dynamic Title
  String get title {
    if (isLateBill) return "Overdue Payment";
    switch (category) {
      case NotificationCategory.queue: return "Queue Alert";
      case NotificationCategory.medication: return "Medication Reminder";
      case NotificationCategory.custom: return "Custom Reminder";
      case NotificationCategory.appointment: return "Appointment Update";
      case NotificationCategory.billing: return "New Bill Available";
      case NotificationCategory.reports: return "Medical Reports";
      case NotificationCategory.general: return "Hospital Info";
    }
  }

  // Dynamic Message
  String get message {
    if (customMessage != null) return customMessage!;

    switch (category) {
      case NotificationCategory.billing:
        if (isLateBill) {
          int weeks = DateTime.now().difference(timestamp).inDays ~/ 7;
          return "Attention: Your bill from ${subjectName ?? 'your visit'} is now $weeks weeks overdue. Please settle it soon.";
        }
        return "Your consultation bill for ${subjectName ?? 'your visit'} is ready.";
      case NotificationCategory.queue:
        return "Please proceed to ${subjectName ?? 'the counter'}. You are next in line.";
      case NotificationCategory.medication:
        return "It's time for your scheduled medication, ${subjectName ?? 'your medicine'}. Check your dosage.";
      case NotificationCategory.custom:
        return "It's time for ${subjectName ?? 'your reminder'}.";
      case NotificationCategory.appointment:
        return "Your appointment with ${subjectName ?? ''} has been updated.";
      case NotificationCategory.reports:
        return "Your lab results are ready for viewing.";
      case NotificationCategory.general:
        return "Stay healthy with the latest updates from HLWE.";
    }
  }

  // Icon & Color
  IconData get icon => isLateBill ? Icons.warning_rounded : _getCategoryIcon();
  Color get color => isLateBill ? Color(0xFFFF9F43) : _getCategoryColor();

  IconData _getCategoryIcon() {
    switch (category) {
      case NotificationCategory.queue: return Icons.airline_seat_recline_normal;
      case NotificationCategory.medication: return Icons.medication;
      case NotificationCategory.appointment: return Icons.event;
      case NotificationCategory.billing: return Icons.credit_card;
      case NotificationCategory.custom: return Icons.notifications_active;
      case NotificationCategory.reports: return Icons.assignment;
      case NotificationCategory.general: return Icons.campaign;
    }
  }

  Color _getCategoryColor() {
    switch (category) {
      case NotificationCategory.medication: 
        return const Color(0xFF27AE60);
      case NotificationCategory.custom:
        return const Color(0xFFFD79A8); 
      case NotificationCategory.queue: 
        return const Color(0xFF16A085);
      case NotificationCategory.appointment: 
        return const Color(0xFF4D96FF); 
      case NotificationCategory.billing: 
        return const Color(0xFFFF9F43); 
      case NotificationCategory.reports: 
        return const Color(0xFF9254C8); 
      case NotificationCategory.general: 
        return const Color(0xFF607D8B);
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}