import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.disabled,
      height: 20,
      thickness: 1,
      indent: 0,
      endIndent: 0,
    );
  }
}
