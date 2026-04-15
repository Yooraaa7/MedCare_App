import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/components/field_label.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/reminder.dart';

class DurationInput extends StatefulWidget {
  final UnitType selectedUnit;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final GlobalKey<FormFieldState>? fieldKey;

  const DurationInput({
    super.key,
    required this.selectedUnit,
    required this.initialValue,
    required this.onChanged,
    this.fieldKey,
  });

  @override
  State<DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends State<DurationInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(DurationInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If unit changed, check the max limit
    if (oldWidget.selectedUnit != widget.selectedUnit) {
      final maxLimit = _unitConfig['max'];
      final currentVal = int.tryParse(_controller.text) ?? 0;

      if (currentVal > maxLimit) {
        // Use a tiny delay to prevent the "building" error
        Future.microtask(() {
          if (!mounted) return;
          _controller.text = maxLimit.toString();
          widget.onChanged(maxLimit);
          widget.fieldKey?.currentState?.validate();
        });
      }
    }
  }

  Map<String, dynamic> get _unitConfig {
    switch (widget.selectedUnit) {
      case UnitType.week:
        return {'label': 'weeks', 'max': 24};
      case UnitType.month:
        return {'label': 'months', 'max': 12};
      case UnitType.year:
        return {'label': 'years', 'max': 5};
      default:
        return {'label': 'days', 'max': 100};
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _unitConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Ends after'),
        AppSpacing.small,
        Row(
          children: [
            SizedBox(
              width: 80,
              child: TextFormField(
                key: widget.fieldKey,
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) => widget.onChanged(int.tryParse(val) ?? 1),
                validator: (val) =>
                    Validators.range('Duration', 1, config['max'])(val),
              ),
            ),
            const SizedBox(width: 12),
            Text(config['label']),
          ],
        ),
        customErrorText(
          widget.fieldKey?.currentState?.hasError ?? false,
          'Max ${config['max']} ${config['label']}',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
