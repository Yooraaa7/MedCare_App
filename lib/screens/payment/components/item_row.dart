import 'package:flutter/material.dart';

Widget itemRow(String name, String qty, String price, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150,
          child: Text(name),
        ),
        Text(qty),
        Text(price,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    ),
  );
}