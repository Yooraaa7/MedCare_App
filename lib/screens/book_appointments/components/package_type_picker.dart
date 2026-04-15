import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class PackageTypePicker extends StatefulWidget {
  final List<String>? packageTypes;
  final ValueChanged<String>? onChanged;
  final String selected;

  const PackageTypePicker({
    super.key,
    required this.packageTypes,
    this.selected = '',
    this.onChanged,
  });

  @override
  State<PackageTypePicker> createState() => _PackageTypePickerState();
}

class _PackageTypePickerState extends State<PackageTypePicker> {
  @override
  Widget build(BuildContext context) {
    // Safety check
    if (widget.packageTypes == null || widget.packageTypes!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Package Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.medium,

        RadioGroup<String>(
          groupValue: widget.selected,
          onChanged: (value) {
            if (value != null) {
              widget.onChanged?.call(value);
            }
          },
          child: Column(
            children: widget.packageTypes!.map((type) {
              return RadioListTile<String>(
                value: type,
                title: Text(type.toUpperCase()),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
