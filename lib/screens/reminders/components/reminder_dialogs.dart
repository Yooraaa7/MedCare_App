import 'package:flutter/material.dart';

class ReminderDialogs {
  static Future<bool?> showForm(BuildContext context, Widget content) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      // Hide the bottom navigation bar
      useRootNavigator: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // Calculate the top safe area (status bar height)
        final topPadding = MediaQuery.of(context).padding.top;
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          // Ensure the modal doesn't touch the very top of the screen
          padding: EdgeInsets.only(top: topPadding + 10), 
          constraints: BoxConstraints(
            // Limit max height to 80% of screen
            maxHeight: screenHeight * 0.8, 
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              // Handles keyboard overlap
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: content, 
            ),
          ),
        );
      },
    );
  }
}