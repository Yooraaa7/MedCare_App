import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? format;
  final TextEditingController controller;
  final ValueChanged<DateTime> onDateSelected;
  final bool isLabelDisplayed;
  final GlobalKey<FormFieldState<DateTime>>? fieldKey;

  const DatePicker({
    super.key,
    this.format = 'dd MMM yyyy, EEEE',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.isLabelDisplayed = true,
    this.fieldKey,
    required this.onDateSelected,
    required this.controller,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // Use a local variable to track the internal selection
  DateTime? _internalDate;

  @override
  void initState() {
    super.initState();
    _internalDate = widget.initialDate;
    _updateTextController();
  }

  // Handle updates if the parent screen changes the date (e.g., clearing the form)
  @override
  void didUpdateWidget(DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _internalDate = widget.initialDate;
      _updateTextController();
    }
  }

  // Updates the display date
  void _updateTextController() {
    if (_internalDate != null) {
      widget.controller.text = DateFormat(widget.format).format(_internalDate!);
    } else {
      widget.controller.clear();
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? now.add(const Duration(days: 1));
    final lastDate = widget.lastDate ?? now.add(const Duration(days: 365));

    // Ensure initialDate is within the valid range
    final initialDate =
        (_internalDate != null && !_internalDate!.isBefore(firstDate))
        ? _internalDate!
        : firstDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              dividerColor: Colors.transparent,
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary,
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: const WidgetStatePropertyAll(
                  AppColors.strongRed,
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                side: WidgetStatePropertyAll(BorderSide.none),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _internalDate = pickedDate;
        _updateTextController();
      });
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isLabelDisplayed) ...[
          Text('Select Date', style: Theme.of(context).textTheme.titleMedium),
        ],
        CustomTextField(
          fieldKey: widget.fieldKey,
          label: '',
          hintText: 'Choose a date',
          readonly: true,
          onTap: _pickDate,
          prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
          validator: Validators.required('Date'),
          controller: widget.controller,
        ),
      ],
    );
  }
}
