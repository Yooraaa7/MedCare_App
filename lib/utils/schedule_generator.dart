import 'package:flutter/material.dart';
import 'package:medcare_app/models/reminder.dart';

List<DateTime> generateSchedule({
  required UnitType unit,
  required List<TimeOfDay> times,
  required DateTime startDate,
  required DateTime endDate,
  List<int> weekdays = const [],
}) {
  final List<DateTime> result = [];

  DateTime cursor = startDate;

  while (!cursor.isAfter(endDate)) {
    switch (unit) {
      // ---------------- DAILY ----------------
      case UnitType.day:
        for (final time in times) {
          result.add(_atTime(cursor, time));
        }
        cursor = cursor.add(const Duration(days: 1));
        break;

      // ---------------- WEEKLY ----------------
      case UnitType.week:
        if (weekdays.contains(cursor.weekday)) {
          for (final time in times) {
            result.add(_atTime(cursor, time));
          }
        }
        cursor = cursor.add(const Duration(days: 1));
        break;

      // ---------------- MONTHLY ----------------
      case UnitType.month:
        final baseDay = startDate.day;

        if (cursor.day == baseDay) {
          final time = times.first;
          result.add(_atTime(cursor, time));
        }

        cursor = DateTime(cursor.year, cursor.month + 1, cursor.day);
        break;

      // ---------------- YEARLY ----------------
      case UnitType.year:
        if (cursor.month == startDate.month && cursor.day == startDate.day) {
          final time = times.first;
          result.add(_atTime(cursor, time));
        }

        cursor = DateTime(cursor.year + 1, cursor.month, cursor.day);
        break;
    }
  }

  result.sort();
  return result;
}

// Helper
DateTime _atTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
