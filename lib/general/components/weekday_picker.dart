import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class WeekdayPicker extends StatelessWidget {
  final List<int> selectedDays; // 1 for Mon, 7 for Sun
  final int selectedFrequency;
  final Function(int) onDayTapped;

  const WeekdayPicker({
    super.key,
    required this.selectedFrequency,
    required this.selectedDays,
    required this.onDayTapped,
  });

  String getFormattedDays() {
    if (selectedDays.isEmpty) return '';

    final dayNames = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };

    // Sort to ensure the text matches the visual order M -> S
    final sortedDays = List<int>.from(selectedDays)..sort();
    return sortedDays.map((d) => dayNames[d]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final bool isFull = selectedDays.length >= selectedFrequency;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. The Dynamic Label
        Text(
          getFormattedDays(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),

        AppSpacing.small,

        // 2. The Interactive Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = selectedDays.contains(dayNumber);
            final bool isDisabled = isFull && !isSelected;

            return GestureDetector(
              onTap: isDisabled ? null : () => onDayTapped(dayNumber),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : isDisabled
                      ? AppColors.disabled
                      : Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color: isDisabled
                          ? AppColors
                                .defaultGrey // Disabled always takes precedence
                          : (isSelected || isDark)
                          ? Colors
                                .white // Selected or Dark mode items are white
                          : AppColors
                                .defaultBlack, // Default light mode active state
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        AppSpacing.small,
      ],
    );
  }
}
