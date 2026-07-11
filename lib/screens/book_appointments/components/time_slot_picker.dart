import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class TimeSlotPicker
    extends StatefulWidget {
  final List<String> timeSlots;
  final Set<String> fullyBookedSlots;
  final ValueChanged<String>? onSelected;
  final String? initialSlot;
  final bool hasError;

  const TimeSlotPicker({
    super.key,
    required this.timeSlots,
    this.fullyBookedSlots =
        const <String>{},
    this.onSelected,
    this.initialSlot,
    this.hasError = false,
  });

  @override
  State<TimeSlotPicker> createState() =>
      _TimeSlotPickerState();
}

class _TimeSlotPickerState
    extends State<TimeSlotPicker> {
  String? _selectedTime;

  @override
  void initState() {
    super.initState();

    _selectedTime =
        widget.initialSlot;
  }

  @override
  void didUpdateWidget(
    covariant TimeSlotPicker oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    final bool initialSlotChanged =
        oldWidget.initialSlot !=
            widget.initialSlot;

    final bool bookedSlotsChanged =
        !_setsAreEqual(
      oldWidget.fullyBookedSlots,
      widget.fullyBookedSlots,
    );

    if (initialSlotChanged) {
      _selectedTime =
          widget.initialSlot;
    }

    // Clear a selected slot when it
    // becomes booked by another user.
    if (bookedSlotsChanged &&
        _selectedTime != null &&
        widget.fullyBookedSlots
            .contains(_selectedTime)) {
      _selectedTime = null;
    }
  }

  bool _setsAreEqual(
    Set<String> first,
    Set<String> second,
  ) {
    return first.length ==
            second.length &&
        first.containsAll(second);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),

        AppSpacing.medium,

        _buildLegend(),

        AppSpacing.medium,

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            childAspectRatio: 3.0,
          ),
          itemCount:
              widget.timeSlots.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            final String time =
                widget.timeSlots[index];

            final bool isFull =
                widget.fullyBookedSlots
                    .contains(time);

            final bool isSelected =
                !isFull &&
                    time ==
                        _selectedTime;

            final Color backgroundColor;
            final Color textColor;

            if (isFull) {
              backgroundColor =
                  AppColors.strongRed;

              textColor =
                  AppColors.defaultWhite;
            } else if (isSelected) {
              backgroundColor =
                  Theme.of(context)
                      .colorScheme
                      .primary;

              textColor =
                  AppColors.defaultWhite;
            } else {
              backgroundColor =
                  AppColors.secondary;

              textColor =
                  AppColors.defaultBlack;
            }

            return Material(
              color: backgroundColor,
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
                onTap: isFull
                    ? null
                    : () {
                        setState(() {
                          _selectedTime =
                              time;
                        });

                        widget.onSelected
                            ?.call(time);
                      },
                child: Center(
                  child: Text(
                    time,
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color:
                              textColor,
                        ),
                  ),
                ),
              ),
            );
          },
        ),

        AppSpacing.small,

        customErrorText(
          widget.hasError,
          'Time slot should not be empty.',
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(
          color:
              AppColors.secondary,
          label: 'Available',
        ),
        _legendItem(
          color:
              AppColors.strongRed,
          label: 'Booking Full',
        ),
        _legendItem(
          color: Theme.of(context)
              .colorScheme
              .primary,
          label: 'Selected',
        ),
      ],
    );
  }

  Widget _legendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(
              5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall,
        ),
      ],
    );
  }
}