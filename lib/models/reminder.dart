import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ReminderType { medication, custom }

enum UnitType { day, week, month, year }

enum NotificationLeadTime {
  onTime,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  oneDay,
  oneWeek,
}

class Reminder {
  final ReminderType type;
  final String id;
  String title;
  int frequency;
  int duration;
  UnitType unit;
  List<DateTime> dateTime;
  List<NotificationLeadTime> notificationType;
  bool enabled;

  Reminder({
    required this.type,
    required this.id,
    required this.title,
    required this.frequency,
    required this.duration,
    required this.unit,
    required this.dateTime,
    List<NotificationLeadTime>? notificationType,
    this.enabled = false,
  }) : notificationType = notificationType ?? [NotificationLeadTime.onTime];

  // Helper method to display frequency as a string
  String get frequencyLabel {
    if (frequency == 1) return "Once a ${unit.name}";
    return "$frequency times per ${unit.name}";
  }

  // Helper method to obtain the specific time slots, weekdays, and day
  List<TimeOfDay> get selectedTimes {
    return dateTime.map((d) => TimeOfDay.fromDateTime(d)).toSet().toList()
      ..sort(
        (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
      );
  }

  List<int> get selectedWeekdays {
    return dateTime.map((d) => d.weekday).toSet().toList()..sort();
  }

  List<int> get selectedDays {
    return dateTime.map((d) => d.day).toSet().toList()..sort();
  }

  // Helper method to display the reminder date / time
  String formatReminderDisplay() {
    if (dateTime.isEmpty) return "No time set";

    // Sort the source list first
    final sortedDates = List<DateTime>.from(dateTime)..sort();

    // Get unique TimeOfDay objects and sort them chronologically
    final uniqueTimes = selectedTimes;

    // Format those sorted times into strings
    final joinedTimes = uniqueTimes
        .map((t) {
          final now = DateTime.now();
          final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          return DateFormat('h:mm a').format(dt);
        })
        .join(', ');

    switch (unit) {
      case UnitType.day:
        return joinedTimes;

      case UnitType.week:
        // Sort weekdays by their integer value (1-7)
        final uniqueDays = selectedWeekdays;

        final dayStrings = uniqueDays.map((wd) {
          // Map the int back to a String name
          return DateFormat(
            'EEEE',
          ).format(DateTime(2024, 1, wd)); // Jan 2024 starts on a Monday
        }).toList();

        return "${dayStrings.join(', ')} at $joinedTimes";

      case UnitType.year:
        final date = sortedDates.first;
        return "${DateFormat('d MMM').format(date)} at ${DateFormat('h:mm a').format(date)}";

      case UnitType.month:
        final date = sortedDates.first;
        return "Monthly on day ${selectedDays.join(', ')} at ${DateFormat('h:mm a').format(date)}";
    }
  }

  void debugPrintSchedule() {
    debugPrint('--- SCHEDULE DEBUG: $title ---');
    debugPrint('Unit: ${unit.name}');
    debugPrint('Frequency: $frequency');
    debugPrint('Total Occurrences: ${dateTime.length}');

    // Grouping DateTime list by Date (yyyy-MM-dd)
    final Map<String, List<String>> grouped = {};

    for (var dt in dateTime) {
      final dateKey = DateFormat('EEE, MMM d').format(dt);
      final timeVal = DateFormat('h:mm a').format(dt);

      grouped.putIfAbsent(dateKey, () => []).add(timeVal);
    }

    // Print the grouped results
    grouped.forEach((date, times) {
      debugPrint('$date -> ${times.join(", ")}');
    });

    debugPrint('-------------------------------------------');
  }
}
