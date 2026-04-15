import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/field_label.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/reminder.dart';

class FrequencyInput extends StatefulWidget {
  final UnitType selectedUnit;
  final int selectedFreq;
  final List<TimeOfDay> initialTimes;
  final Function(List<TimeOfDay>, UnitType, int) onChanged;
  final bool includeMonthYear;

  const FrequencyInput({
    super.key,
    required this.selectedFreq,
    required this.selectedUnit,
    required this.initialTimes,
    required this.onChanged,
    this.includeMonthYear = false,
  });

  @override
  State<FrequencyInput> createState() => _FrequencyInputState();
}

class _FrequencyInputState extends State<FrequencyInput> {
  late List<TimeOfDay> _currentTimes;
  late UnitType _currentUnit;
  late int _currentFreq;

  @override
  void initState() {
    super.initState();
    _currentTimes = List.from(widget.initialTimes);
    _currentUnit = widget.selectedUnit;
    _currentFreq = widget.selectedFreq;
  }

  // Generate numbers based on the unit context
  List<int> _getDigitOptions(UnitType unit) {
    switch (unit) {
      case UnitType.day:
        return [1, 2, 3, 4];
      case UnitType.week:
        return [1, 2, 3, 4];
      case UnitType.month:
        return [1, 2, 3, 4, 5, 6, 7];
      case UnitType.year:
        return [1];
    }
  }

  void _updateSchedule(int freq, UnitType unit) {
    List<int> options = _getDigitOptions(unit);
    int newFreq = freq;

    // Ensure freq stays within new unit's bounds
    if (!options.contains(newFreq)) {
      newFreq = options.last;
    }

    setState(() {
      _currentUnit = unit;
      _currentFreq = newFreq;

      // Logic for time presets (only for Daily)
      if (unit == UnitType.day) {
        final Map<int, List<TimeOfDay>> dailyPresets = {
          1: [const TimeOfDay(hour: 08, minute: 0)],
          2: [
            const TimeOfDay(hour: 08, minute: 0),
            const TimeOfDay(hour: 20, minute: 0),
          ],
          3: [
            const TimeOfDay(hour: 08, minute: 0),
            const TimeOfDay(hour: 14, minute: 0),
            const TimeOfDay(hour: 20, minute: 0),
          ],
          4: [
            const TimeOfDay(hour: 08, minute: 0),
            const TimeOfDay(hour: 12, minute: 0),
            const TimeOfDay(hour: 16, minute: 0),
            const TimeOfDay(hour: 20, minute: 0),
          ],
        };
        _currentTimes = List.from(
          dailyPresets[newFreq] ?? [const TimeOfDay(hour: 08, minute: 0)],
        );
      } else {
        _currentTimes = [const TimeOfDay(hour: 08, minute: 0)];
      }
    });

    widget.onChanged(_currentTimes, _currentUnit, _currentFreq);
  }

  @override
  Widget build(BuildContext context) {
    final unitOptions = widget.includeMonthYear
        ? UnitType.values
        : [UnitType.day, UnitType.week];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Frequency'),
        AppSpacing.small,
        Row(
          children: [
            // Frequency Number Dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                initialValue: _currentFreq,
                items: _getDigitOptions(_currentUnit)
                    .map(
                      (val) => DropdownMenuItem(
                        value: val,
                        child: Text('$val', style: TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => _updateSchedule(val!, _currentUnit),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("times per"),
            ),
            // Unit Dropdown
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<UnitType>(
                initialValue: _currentUnit,
                items: unitOptions
                    .map(
                      (val) => DropdownMenuItem(
                        value: val,
                        child: Text(val.name, style: TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => _updateSchedule(_currentFreq, val!),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
