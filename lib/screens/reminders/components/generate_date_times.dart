import 'package:flutter/material.dart';
import 'package:medcare_app/models/reminder.dart';

List<DateTime> generateDateTimes(
  UnitType selectedUnit,
  List<TimeOfDay> selectedTimes, {
  required int duration,
  List<int>? selectedWeekdays,
  List<int>? selectedDaysOfMonth,
  DateTime? selectedYearlyDate,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  List<DateTime> reminderDateTimes = [];

  if (selectedUnit == UnitType.week) {
    duration *= 7;
  }

  // 1. DAILY & WEEKLY
  if (selectedUnit == UnitType.day || selectedUnit == UnitType.week) {
    for (int i = 0; i <= duration; i++) {
      DateTime currentDay = today.add(Duration(days: i));

      // Use ?.contains and fallback to false if selectedWeekdays is null
      bool shouldAdd =
          selectedUnit == UnitType.day ||
          (selectedWeekdays?.contains(currentDay.weekday) ?? false);

      if (shouldAdd) {
        for (var time in selectedTimes) {
          reminderDateTimes.add(
            DateTime(
              currentDay.year,
              currentDay.month,
              currentDay.day,
              time.hour,
              time.minute,
            ),
          );
        }
      }
    }
  }
  // 2. MONTHLY
  else if (selectedUnit == UnitType.month && selectedDaysOfMonth != null) {
    TimeOfDay time = selectedTimes.first;

    for (int i = 0; i < duration; i++) {
      for (int day in selectedDaysOfMonth) {
        final generatedDate = DateTime(
          now.year,
          now.month + i,
          day,
          time.hour,
          time.minute,
        );

        // Validation: Ensure we don't include February 30th or April 31st
        DateTime targetMonth = DateTime(now.year, now.month + i, 1);
        if (generatedDate.month == targetMonth.month &&
            generatedDate.isAfter(now)) {
          reminderDateTimes.add(generatedDate);
        }
      }
    }
  }
  // 3. YEARLY
  else if (selectedUnit == UnitType.year && selectedYearlyDate != null) {
    TimeOfDay time = selectedTimes.first;

    for (int i = 0; i < duration; i++) {
      reminderDateTimes.add(
        DateTime(
          selectedYearlyDate.year + i,
          selectedYearlyDate.month,
          selectedYearlyDate.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  // Sort and filter out past times
  reminderDateTimes.sort();
  return reminderDateTimes.where((dt) => dt.isAfter(now)).toList();
}
