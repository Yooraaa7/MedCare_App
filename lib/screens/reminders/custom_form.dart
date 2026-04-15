import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/date_picker.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/components/field_label.dart';
import 'package:medcare_app/general/components/time_picker.dart';
import 'package:medcare_app/general/components/weekday_picker.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/reminders/components/duration_input.dart';
import 'package:medcare_app/screens/reminders/components/frequency_input.dart';
import 'package:medcare_app/screens/reminders/components/generate_date_times.dart';
import 'package:medcare_app/screens/reminders/components/month_day_picker.dart';
import 'package:medcare_app/screens/reminders/components/save_cancel_row.dart';
import 'package:uuid/v4.dart';

class CustomForm extends StatefulWidget {
  final Reminder? reminder;
  const CustomForm({super.key, this.reminder});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _durationKey = GlobalKey<FormFieldState>();
  final _dateController = TextEditingController();

  late String _title;
  late UnitType selectedUnit;
  late int selectedFrequency;
  late List<int> _selectedDaysOfMonth;

  late List<TimeOfDay> selectedTimes;
  late List<int>? _selectedWeekdays;
  late List<NotificationLeadTime> selectedNotifications;
  late DateTime _selectedYearlyDate;
  int _durationValue = 14;
  bool _validateWeekdays = false;
  bool _validateMonthDays = false;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;

    _title = r?.title ?? '';
    selectedUnit = r?.unit ?? UnitType.day;
    selectedFrequency = r?.frequency ?? 1;
    selectedTimes = r?.selectedTimes ?? [const TimeOfDay(hour: 8, minute: 0)];
    _selectedWeekdays = r?.selectedWeekdays ?? [];
    selectedNotifications = r?.notificationType != null
        ? List.from(r!.notificationType)
        : [NotificationLeadTime.onTime];

    _selectedDaysOfMonth = r?.selectedDays ?? [];
    _selectedYearlyDate = r?.dateTime.first ?? DateTime.now();
    _durationValue = r?.duration ?? 14;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void handleSave() {
    setState(() => _validateWeekdays = _validateMonthDays = true);

    // 1. Validations
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isWeekValid = selectedUnit == UnitType.week
        ? (_selectedWeekdays?.length == selectedFrequency)
        : true;

    if (!isFormValid || !isWeekValid) return;
    _formKey.currentState!.save();

    // 2. Generate Dates
    final dates = generateDateTimes(
      selectedUnit,
      selectedTimes,
      duration: _durationValue,
      selectedWeekdays: _selectedWeekdays,
      selectedDaysOfMonth: _selectedDaysOfMonth,
      selectedYearlyDate: _selectedYearlyDate,
    );

    // 3. Object Creation
    final String reminderId = widget.reminder?.id ?? const UuidV4().generate();

    final newReminder = Reminder(
      id: reminderId,
      type: ReminderType.custom,
      title: _title,
      frequency: selectedFrequency,
      unit: selectedUnit,
      dateTime: dates,
      duration: _durationValue,
      notificationType: List.from(selectedNotifications),
      enabled: widget.reminder?.enabled ?? true,
    );

    // 4. Update Global List
    setState(() {
      if (widget.reminder == null) {
        DataService.allReminders.add(newReminder);
      } else {
        int index = DataService.allReminders.indexWhere(
          (r) => r.id == reminderId,
        );
        if (index != -1) {
          DataService.allReminders[index] = newReminder;
        }
      }
    });

    // 5. Success UI
    if (mounted) {
      context.pop(true);
      showCustomSnackbar(
        context,
        'Reminder saved successfully!',
        type: SnackbarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AppSpacing.large,
          _buildTitleField(),
          AppSpacing.large,

          FrequencyInput(
            selectedUnit: selectedUnit,
            selectedFreq: selectedFrequency,
            initialTimes: selectedTimes,
            includeMonthYear: true,
            onChanged: (list, unit, freq) => setState(() {
              selectedTimes = list;
              selectedUnit = unit;
              // Apply your 4 times per week limit logic here
              selectedFrequency = (unit == UnitType.week && freq > 4)
                  ? 4
                  : freq;
              if (unit == UnitType.week) _selectedWeekdays = [];
            }),
          ),

          _buildConditionalPickers(),

          AppSpacing.large,
          const FieldLabel('Set Reminder Times'),
          AppSpacing.small,
          timePicker(
            context: context,
            selectedTimes: selectedTimes,
            onTimeChanged: (i, time) => setState(() => selectedTimes[i] = time),
          ),

          AppSpacing.large,
          DurationInput(
            fieldKey: _durationKey,
            selectedUnit: selectedUnit,
            initialValue: _durationValue,
            onChanged: (val) => setState(() => _durationValue = val),
          ),

          AppSpacing.large,
          _buildNotificationsSection(),

          AppSpacing.xlarge,
          saveCancelRow(context, handleSave),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildHeader() => Center(
    child: Text(
      widget.reminder == null ? "New Custom Reminder" : "Edit Custom Reminder",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildTitleField() => CustomTextField(
    label: 'Title',
    initialValue: _title,
    hintText: 'Enter title (e.g. Drink water)',
    prefixIcon: const Icon(Icons.notifications_active_outlined),
    validator: Validators.combine([
      Validators.required('Title'),
      Validators.title('Title', widget.reminder),
    ]),
    onSaved: (v) => _title = v ?? '',
  );

  Widget _buildConditionalPickers() {
    if (selectedUnit == UnitType.week) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.large,
          const FieldLabel('Select Days'),
          WeekdayPicker(
            selectedFrequency: selectedFrequency,
            selectedDays: _selectedWeekdays ?? [],
            onDayTapped: (day) => setState(() {
              _selectedWeekdays ??= [];
              if (_selectedWeekdays!.contains(day)) {
                _selectedWeekdays!.remove(day);
              } else if (_selectedWeekdays!.length < selectedFrequency) {
                _selectedWeekdays!.add(day);
              }
              _selectedWeekdays!.sort();
            }),
          ),
          customErrorText(
            _validateWeekdays &&
                (_selectedWeekdays?.length ?? 0) < selectedFrequency,
            'Please select $selectedFrequency day(s).',
          ),
        ],
      );
    } else if (selectedUnit == UnitType.month) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.large,
          const FieldLabel('Day of the Month'),
          AppSpacing.small,
          monthDayPicker(
            selectedFrequency,
            _selectedDaysOfMonth,
            (day) => setState(() {
              if (_selectedDaysOfMonth.contains(day)) {
                if (_selectedDaysOfMonth.isNotEmpty)
                  _selectedDaysOfMonth.remove(day);
              } else if (_selectedDaysOfMonth.length < selectedFrequency) {
                _selectedDaysOfMonth.add(day);
                _selectedDaysOfMonth.sort();
              }
            }),
          ),
          AppSpacing.small,
          customErrorText(
            _validateMonthDays &&
                (_selectedDaysOfMonth.length) < selectedFrequency,
            'Please select $selectedFrequency day(s).',
          ),
        ],
      );
    } else if (selectedUnit == UnitType.year) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.large,
          const FieldLabel('Select Date'),
          DatePicker(
            initialDate: _selectedYearlyDate,
            // Range starts from January 1st to December 31st
            firstDate: DateTime(_selectedYearlyDate.year, 1, 1),
            lastDate: DateTime(_selectedYearlyDate.year, 12, 31),
            format: 'dd MMMM',
            controller: _dateController,
            isLabelDisplayed: false,
            onDateSelected: (date) =>
                setState(() => _selectedYearlyDate = date),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Notifications'),
        Wrap(
          spacing: 8.0,
          children: NotificationLeadTime.values.map((type) {
            final isSelected = selectedNotifications.contains(type);
            return FilterChip(
              label: Text(
                _getLeadTimeLabel(type),
                style: TextStyle(color: isSelected ? Colors.white : null),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Colors.white,
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(color: Theme.of(context).colorScheme.onTertiary),
              onSelected: (bool selected) {
                if (type == NotificationLeadTime.onTime) return;
                setState(
                  () => selected
                      ? selectedNotifications.add(type)
                      : selectedNotifications.remove(type),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

String _getLeadTimeLabel(NotificationLeadTime type) {
  switch (type) {
    case NotificationLeadTime.onTime:
      return 'On time';
    case NotificationLeadTime.fifteenMinutes:
      return '15 mins before';
    case NotificationLeadTime.thirtyMinutes:
      return '30 mins before';
    case NotificationLeadTime.oneHour:
      return '1 hour before';
    case NotificationLeadTime.oneDay:
      return '1 day before';
    case NotificationLeadTime.oneWeek:
      return '1 week before';
  }
}
