import 'package:flutter/material.dart';

Widget paymentCard(
  BuildContext context, {
  required String label,
  String? imagePath,
  required VoidCallback onTap,
}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            // Label
            Expanded(
              child: Text(label, style: TextStyle(
                fontWeight: FontWeight.w600
              ),),
            ),

            // Payment Logo
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: 50,
                height: 30,
                fit: BoxFit.contain
              ),
          ],
        ),
      ),
    ),
  );
}