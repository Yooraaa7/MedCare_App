import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

// TODO: The current timeslot is hardcoded
class TimeSlotPicker extends StatefulWidget {
  final List<String> timeSlots;
  final Set<String> fullyBookedSlots;
  final ValueChanged<String>? onSelected;
  final String? initialSlot;
  final bool hasError;

  const TimeSlotPicker({
    super.key,
    required this.timeSlots,
    this.fullyBookedSlots = const {},
    this.onSelected,
    this.initialSlot,
    this.hasError = false,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize local state from widget property
    _selectedTime = widget.initialSlot;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Select Time Slot',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.medium,

        // Legend
        _buildLegend(),
        AppSpacing.medium,

        // Time slots
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            childAspectRatio: 3.0,
          ),
          itemCount: widget.timeSlots.length,
          itemBuilder: (context, index) {
            final time = widget.timeSlots[index];
            final isSelected = time == _selectedTime;
            final isFull = widget.fullyBookedSlots.contains(time);

            Color backgroundColor;
            Color textColor;

            if (isFull) {
              backgroundColor = AppColors.strongRed;
              textColor = AppColors.defaultWhite;
            } else if (isSelected) {
              backgroundColor = Theme.of(context).colorScheme.primary;
              textColor = AppColors.defaultWhite;
            } else {
              backgroundColor = AppColors.secondary;
              textColor = AppColors.defaultBlack;
            }

            return Material(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: isFull
                    ? null
                    : () {
                        setState(() => _selectedTime = time);
                        widget.onSelected?.call(time);
                      },
                child: Center(
                  child: Text(
                    time,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: textColor),
                  ),
                ),
              ),
            );
          },
        ),

        AppSpacing.small,
        customErrorText(widget.hasError, 'Time slot should not be empty.'),
      ],
    );
  }

  // Legend widget
  Widget _buildLegend() {
    return Row(
      children: [
        _legendItem(color: AppColors.secondary, label: 'Available'),
        const SizedBox(width: 16),
        _legendItem(color: AppColors.strongRed, label: 'Booking Full'),
        const SizedBox(width: 16),
        _legendItem(
          color: Theme.of(context).colorScheme.primary,
          label: 'Selected',
        ),
      ],
    );
  }

  Widget _legendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
