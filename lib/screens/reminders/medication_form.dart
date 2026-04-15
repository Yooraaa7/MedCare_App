import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/components/field_label.dart';
import 'package:medcare_app/general/components/time_picker.dart';
import 'package:medcare_app/general/components/weekday_picker.dart';
import 'package:medcare_app/general/themes/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/reminders/components/duration_input.dart';
import 'package:medcare_app/screens/reminders/components/frequency_input.dart';
import 'package:medcare_app/screens/reminders/components/generate_date_times.dart';
import 'package:medcare_app/screens/reminders/components/save_cancel_row.dart';
import 'package:uuid/v4.dart';

class MedicationForm extends StatefulWidget {
  final Reminder? reminder;
  const MedicationForm({super.key, this.reminder});

  @override
  State<MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _durationKey = GlobalKey<FormFieldState>();

  late String _medicineName;
  late UnitType selectedUnit;
  late int selectedFrequency;
  late List<TimeOfDay> selectedTimes;
  late List<int>? _selectedWeekdays;
  int _durationValue = 14;
  bool _validateWeekdays = false;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    _medicineName = r?.title.replaceFirst('Take ', '') ?? '';
    selectedUnit = r?.unit ?? UnitType.day;
    selectedFrequency = r?.frequency ?? 1;
    selectedTimes = r?.selectedTimes ?? [const TimeOfDay(hour: 8, minute: 0)];
    _selectedWeekdays = r?.unit == UnitType.week ? r?.selectedWeekdays : [];
    _durationValue = r?.duration ?? 14;
  }

  void _onScheduleChanged(List<TimeOfDay> times, UnitType unit, int freq) {
    setState(() {
      selectedTimes = times;
      selectedUnit = unit;
      selectedFrequency = freq;
      if (unit == UnitType.week) _selectedWeekdays = [];
    });
  }

  void handleSave() async {
    setState(() => _validateWeekdays = true);

    // 2. Perform Validations
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool isWeekValid = selectedUnit == UnitType.week
        ? (_selectedWeekdays?.length == selectedFrequency)
        : true;

    if (!isFormValid || !isWeekValid) return;

    _formKey.currentState!.save();

    // 3. Generate Dates
    List<DateTime> generatedDates = generateDateTimes(
      selectedUnit,
      selectedTimes,
      duration: _durationValue,
      selectedWeekdays: _selectedWeekdays,
    );

    // 4. Preserve existing ID if it exists, otherwise generate new
    final String reminderId = widget.reminder?.id ?? const UuidV4().generate();

    final newReminder = Reminder(
      id: reminderId,
      title: 'Take $_medicineName',
      unit: selectedUnit,
      frequency: selectedFrequency,
      duration: _durationValue,
      dateTime: generatedDates,
      type: ReminderType.medication,
    );

    // 5. Update DataService
    setState(() {
      if (widget.reminder == null) {
        DataService.allReminders.add(newReminder);
      } else {
        // Use indexWhere with ID for 100% reliability
        int index = DataService.allReminders.indexWhere(
          (r) => r.id == reminderId,
        );
        if (index != -1) {
          DataService.allReminders[index] = newReminder;
        }
      }
    });

    if (mounted) {
      context.pop(true);
      showCustomSnackbar(
        context,
        "Reminder saved successfully!",
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

          _buildNameField(),
          AppSpacing.large,

          FrequencyInput(
            selectedUnit: selectedUnit,
            selectedFreq: selectedFrequency,
            initialTimes: selectedTimes,
            onChanged: _onScheduleChanged,
          ),

          if (selectedUnit == UnitType.week) _buildWeekdaySection(),
          AppSpacing.large,

          const FieldLabel('Reminder Times'),
          AppSpacing.small,
          timePicker(
            context: context,
            selectedTimes: selectedTimes,
            onTimeChanged: (i, t) => setState(() => selectedTimes[i] = t),
          ),
          AppSpacing.large,

          DurationInput(
            fieldKey: _durationKey,
            selectedUnit: selectedUnit,
            initialValue: _durationValue,
            onChanged: (val) => setState(() => _durationValue = val),
          ),
          AppSpacing.xlarge,
          saveCancelRow(context, handleSave),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildHeader() => Center(
    child: Text(
      widget.reminder == null
          ? "New Medication Reminder"
          : "Edit Medication Reminder",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildNameField() => CustomTextField(
    label: 'Medicine Name',
    initialValue: _medicineName,
    hintText: 'Enter medicine name',
    prefixIcon: const Icon(Icons.medication),
    onSaved: (v) => _medicineName = v ?? '',
    validator: Validators.combine([
      Validators.required('Medicine name'),
      Validators.title('Title', widget.reminder),
    ]),
  );

  Widget _buildWeekdaySection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSpacing.large,
      const FieldLabel('Select Days'),
      WeekdayPicker(
        selectedFrequency: selectedFrequency,
        selectedDays: _selectedWeekdays ?? [],
        onDayTapped: (day) => setState(() {
          _selectedWeekdays ??= [];
          // Remove if already selected, Add if not yet selected
          _selectedWeekdays!.contains(day)
              ? _selectedWeekdays!.remove(day)
              // Ensure it does not exceed the frequency selected
              : (_selectedWeekdays!.length < selectedFrequency
                    ? _selectedWeekdays!.add(day)
                    : null);
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
}
