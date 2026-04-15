import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const FieldLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodySmall,
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.strongRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
