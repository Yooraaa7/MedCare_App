import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget customErrorText(bool hasError, String errorText) {
  return hasError
      ? Padding(
          padding: EdgeInsets.only(top: 0.0, left: 15.0),
          child: Text(
            errorText,
            style: TextStyle(color: AppColors.strongRed, fontSize: 12),
          ),
        )
      : const SizedBox.shrink();
}
