import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_divider.dart';

Widget paymentRow(
  BuildContext context, {
  required String title,
  required Widget trailing,
}) => Column(
  children: [
    ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: trailing,
    ),
    const CustomDivider(),
  ],
);
