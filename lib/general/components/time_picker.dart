import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget timePicker({
  required BuildContext context,
  required List<TimeOfDay> selectedTimes,
  required Function(int index, TimeOfDay newTime) onTimeChanged,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(selectedTimes.length, (index) {
            return _buildTimeTile(
              context: context,
              selectedTime: selectedTimes[index],
              // Pass a callback so the tile can update the parent state
              onTap: (newTime) => onTimeChanged(index, newTime),
            );
          }),
        ),
      ],
    );

Widget _buildTimeTile({
  required BuildContext context,
  required TimeOfDay selectedTime,
  required Function(TimeOfDay) onTap,
}) {
  return InkWell(
    onTap: () async {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null) {
        onTap(pickedTime); // Send the result back to the parent
      }
    },
    borderRadius: BorderRadius.circular(10),
    child: Ink(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatTime(selectedTime),
          ),
        ],
      ),
    ),
  );
}

String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm a').format(dt);
}