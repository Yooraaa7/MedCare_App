import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionText;
  final VoidCallback onTapAction;
  final Color? actionColor;
  final String backText;
  final VoidCallback onTapBack;
  final Color? backColor;

  const WarningDialog({
    super.key,
    required this.title,
    required this.content,
    this.actionText = 'Cancel anyway',
    this.actionColor,
    required this.onTapAction,
    this.backText = 'Back',
    this.backColor,
    required this.onTapBack,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5.0,
      contentPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 60,
            color: Colors.orange,
          ),
          AppSpacing.large,
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          AppSpacing.medium,
          Text(content, textAlign: TextAlign.center),
          AppSpacing.large,

          // Back button
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: actionColor),
              onPressed: onTapAction,
              child: Text(actionText),
            ),
          ),
          AppSpacing.medium,

          // Action button
          SizedBox(
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: backColor),
              onPressed: onTapBack,
              child: Text(backText),
            ),
          ),
        ],
      ),
    );
  }
}

void showWarningDialog(
  BuildContext context, {
  required String title,
  required String content,
  Color? actionColor,
  String actionText = 'Cancel anyway',
  required VoidCallback onTapAction,
  Color? backColor,
  String backText = 'Back',
  required VoidCallback onTapBack,
}) {
  showDialog(
    context: context,
    builder: (context) => WarningDialog(
      title: title,
      content: content,
      actionColor: actionColor,
      actionText: actionText,
      onTapAction: onTapAction,
      backColor: backColor,
      backText: backText,
      onTapBack: onTapBack,
    ),
  );
}
