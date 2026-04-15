import 'package:flutter/material.dart';

Widget buildList(List<String> items, bool isBullet) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items.asMap().entries.map((entry) {
      int idx = entry.key + 1;
      String text = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns number/bullet with top of text
          children: [
            SizedBox(
              width: 24, // Fixed width for numbers
              child: Text(isBullet? "• " : "$idx."),
            ),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      );
    }).toList(),
  );
}