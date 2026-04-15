import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/build_list.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/appointments_list/components/file_tile.dart';
import 'package:medcare_app/services/data_service.dart';

class AppointmentSectionBox extends StatelessWidget {
  final String title;
  final String? trialing;
  final dynamic data; // Accepts List<File>, List<String>, or List<Reminder>

  const AppointmentSectionBox({
    super.key,
    required this.title,
    this.trialing,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // If data is null or an empty list, don't show the section at all
    if (data == null || (data is List && data.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.medium,
        const CustomDivider(),
        AppSpacing.medium,

        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trialing != null) ...[
              AppSpacing.widthSmall,
              Text(
                trialing!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Dynamic Content Switch
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return switch (data) {
      // Handling both List of Files and Single File using the same logic
      List<File> files => Column(
        children: files.map((file) => buildFileTile(context, file)).toList(),
      ),
      File file => buildFileTile(context, file),

      // List of Strings (Comments)
      List<String> comments => buildList(comments, true),

      // List of Reminders (Prescriptions)
      List<Reminder> reminders => Column(
        children: reminders
            .map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(item.frequencyLabel),
                  trailing: IconButton(
                    icon: const Icon(Icons.notifications, size: 18),
                    onPressed: () {
                      // Check if the reminder already exists in your list
                      final int index = DataService.allReminders.indexWhere(
                        (r) => r.id == item.id,
                      );
                      final bool alreadyExists = index != -1;

                      if (alreadyExists) {
                        DataService.allReminders[index].enabled = true;
                        showCustomSnackbar(
                          context,
                          'Reminder enabled successfully!',
                          type: SnackbarType.success,
                        );
                        return;
                      }

                      // Add to your local data list
                      DataService.allReminders.add(item);

                      showCustomSnackbar(
                        context,
                        'Reminder added successfully!',
                        type: SnackbarType.success,
                      );
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),

      _ => const Text("No details available"),
    };
  }
}
