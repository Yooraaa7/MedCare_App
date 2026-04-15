import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';

void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select Language', textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              _handleLanguageChange(context, 'en');
            },
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: const Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () {
              _handleLanguageChange(context, 'zh');
            },
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: const Text('中文 (Chinese)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              _handleLanguageChange(context, 'ms');
            },
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: const Text('Bahasa Melayu (Malay)'),
          ),
        ],
      );
    },
  );
}

void _handleLanguageChange(BuildContext context, String langCode) {
  // 1. Close the dialog
  context.pop();

  // 2. Add your logic here (e.g., updating Locale or saving to SharedPreferences)
  print("Language changed to: $langCode");

  // 3. Show a confirmation snackbar
  showCustomSnackbar(
    context,
    "Language updated successfully!",
    type: SnackbarType.success,
  );
}
