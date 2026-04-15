import 'package:flutter/material.dart';

List<DateTime> generateDateTimes(
  String selectedUnit,
  List<TimeOfDay> selectedTimes, {
  List<int>? selectedWeekdays,
  int? selectedDayOfMonth,
  DateTime? selectedYearlyDate,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  List<DateTime> reminderDateTimes = [];

  // 1. DAILY & WEEKLY
  if (selectedUnit == 'day' || selectedUnit == 'week') {
    for (int i = 0; i < 30; i++) {
      DateTime currentDay = today.add(Duration(days: i));
      
      // Use ?.contains and fallback to false if selectedWeekdays is null
      bool shouldAdd = selectedUnit == 'day' || 
       (selectedWeekdays?.contains(currentDay.weekday) ?? false);  
      
      if (shouldAdd) {
        for (var time in selectedTimes) {
          reminderDateTimes.add(
            DateTime(currentDay.year, currentDay.month, currentDay.day, time.hour, time.minute),
          );
        }
      }
    }
  } 
  
  // 2. MONTHLY
  else if (selectedUnit == 'month' && selectedDayOfMonth != null) {
    // We only take the first time selected for monthly
    TimeOfDay time = selectedTimes.first;

    for (int i = 0; i < 12; i++) {
      int year = now.year;
      int month = now.month + i;
      
      // Proper month overflow logic
      while (month > 12) {
        month -= 12;
        year += 1;
      }
      
      reminderDateTimes.add(
        DateTime(year, month, selectedDayOfMonth, time.hour, time.minute)
      );
    }
  }

  // 3. YEARLY
  else if (selectedUnit == 'year' && selectedYearlyDate != null) {
    TimeOfDay time = selectedTimes.first;

    for (int i = 0; i < 5; i++) {
      reminderDateTimes.add(
        DateTime(
          selectedYearlyDate.year + i, 
          selectedYearlyDate.month, 
          selectedYearlyDate.day, 
          time.hour, 
          time.minute
        ),
      );
    }
  }

  // Sort and filter out past times
  reminderDateTimes.sort();
  return reminderDateTimes.where((dt) => dt.isAfter(now)).toList();
}