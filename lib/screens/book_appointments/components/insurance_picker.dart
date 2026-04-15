import 'package:flutter/material.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';

class InsuranceSelector extends StatelessWidget {
  final List<InsuranceDetails> options;
  final InsuranceDetails? selectedValue;
  final ValueChanged<InsuranceDetails?> onChanged;
  final VoidCallback onAddTap;

  const InsuranceSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 54.0, right: 16.0),
        child: ListTile(
          onTap: onAddTap,
          contentPadding: EdgeInsets.only(left: 10),
          dense: true,
          leading: Icon(Icons.add, size: 20),
          title: Text("Add new insurance", style: TextStyle(fontSize: 14)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 54.0, right: 16.0, bottom: 8.0),
      child: DropdownButton<InsuranceDetails?>(
        value: selectedValue,
        isExpanded: true,
        itemHeight: null,
        underline: Container(height: 0.5, color: Colors.grey.shade300),
        items: [
          // 1. Existing Insurance Items
          ...options.map((insurance) {
            return DropdownMenuItem<InsuranceDetails?>(
              value: insurance,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Image.asset(insurance.logoPath, height: 20, width: 40),
                title: Text(
                  insurance.provider,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  insurance.policy,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            );
          }),

          // 2. The "Add New" Tile at the bottom
          DropdownMenuItem<InsuranceDetails?>(
            value: null, // Value is null to distinguish it from a selection
            onTap: onAddTap,
            child: const ListTile(
              contentPadding: EdgeInsets.only(left: 10),
              dense: true,
              leading: Icon(Icons.add),
              title: Text("Add new insurance", style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}
