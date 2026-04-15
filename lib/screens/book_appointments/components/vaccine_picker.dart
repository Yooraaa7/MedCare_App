import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:medcare_app/screens/book_appointments/components/vaccine_info_dialog.dart';

class VaccinePicker extends StatefulWidget {
  final List<Vaccine> vaccines;
  final List<Vaccine>? initialSelection;
  final void Function(List<Vaccine>)? onChanged;
  final bool hasError;

  const VaccinePicker({
    super.key,
    required this.vaccines,
    required this.hasError,
    this.onChanged,
    this.initialSelection,
  });

  @override
  State<VaccinePicker> createState() => _VaccinePickerState();
}

class _VaccinePickerState extends State<VaccinePicker> {
  // Initialize with the passed selection or an empty list
  late List<Vaccine> _selected;

  @override
  void initState() {
    super.initState();
    // Copy the list to avoid modifying the original list by reference accidentally
    _selected = widget.initialSelection != null
        ? List<Vaccine>.from(widget.initialSelection!)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          authService.isGuest
              ? 'View Vaccine Details'
              : 'Select Vaccine (Maximum 2)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.medium,

        Column(
          children: widget.vaccines.map((vaccine) {
            if (authService.isGuest) {
              return ListTile(
                title: Text(vaccine.name),
                trailing: IconButton(
                  onPressed: () => showVaccineInfoDialog(context, vaccine),
                  icon: const Icon(Icons.info_outline, size: 20),
                ),
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -3),
              );
            }

            // Use ID for comparison to be safe across different data instances
            final isChecked = _selected.any((v) => v.id == vaccine.id);

            return CheckboxListTile(
              value: isChecked,
              title: Text(vaccine.name),
              secondary: IconButton(
                onPressed: () => showVaccineInfoDialog(context, vaccine),
                icon: const Icon(Icons.info_outline, size: 20),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -3),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    // Maximum 2 selection logic
                    if (_selected.length < 2) {
                      _selected.add(vaccine);
                    } else {
                      showCustomSnackbar(
                        context,
                        'You may select a maximum of 2 vaccines only.',
                        type: SnackbarType.error,
                      );
                    }
                  } else {
                    // Remove by ID to ensure consistency
                    _selected.removeWhere((v) => v.id == vaccine.id);
                  }
                });

                widget.onChanged?.call(_selected);
              },
            );
          }).toList(),
        ),

        customErrorText(
          widget.hasError,
          'At least 1 vaccine should be selected',
        ),
      ],
    );
  }
}
