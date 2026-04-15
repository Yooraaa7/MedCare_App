import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget saveCancelRow(BuildContext context, VoidCallback onSave) => Row(
  children: [
    Expanded(
      child: TextButton(
        onPressed: () => context.pop(),
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppColors.strongRed),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(side: BorderSide.none),
          ),
        ),
        child: const Text('Cancel'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton(onPressed: onSave, child: const Text('Save')),
    ),
  ],
);
