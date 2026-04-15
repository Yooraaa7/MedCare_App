import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class PaymentSectionBox<T> extends StatelessWidget {
  final String sectionTitle;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final VoidCallback onAddMore;

  const PaymentSectionBox({
    super.key,
    required this.sectionTitle,
    required this.items,
    required this.itemBuilder,
    required this.onAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Column(children: [itemBuilder(item), AppSpacing.medium]),
        ),
        const CustomDivider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          title: Text(
            "Add more",
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          ),
          onTap: onAddMore,
        ),
      ],
    );
  }
}
