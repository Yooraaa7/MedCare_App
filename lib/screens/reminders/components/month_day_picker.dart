import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

// Changed 'int selectedDayOfMonth' to 'List<int> selectedDays'
Widget monthDayPicker(
  int selecctedFrequency,
  List<int> selectedDays,
  ValueChanged<int> onTap,
) => GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 7,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  ),
  itemCount: 28,
  itemBuilder: (context, index) {
    int day = index + 1;
    // Check if this specific day is in our selected list
    bool isSelected = selectedDays.contains(day);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isDisabled =
        (selectedDays.length >= selecctedFrequency) && !isSelected;

    return InkWell(
      onTap: () => isDisabled ? null : onTap(day),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(200)
              : isDisabled
              ? AppColors.disabled
              : Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: Text(
          "$day",
          style: TextStyle(
            color: isDisabled
                ? AppColors
                      .defaultGrey // Disabled always takes precedence
                : (isSelected || isDark)
                ? Colors
                      .white // Selected or Dark mode items are white
                : AppColors.defaultBlack, // Default light mode active state
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  },
);
