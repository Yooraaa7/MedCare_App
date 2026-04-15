import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

class PasswordRules extends StatelessWidget {
  final String password;
  const PasswordRules({super.key, required this.password});

  bool _hasUpper(String v) => RegExp(r'[A-Z]').hasMatch(v);
  bool _hasLower(String v) => RegExp(r'[a-z]').hasMatch(v);
  bool _hasSpecial(String v) => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v);
  bool _validLength(String v) => v.length >= 12 && v.length <= 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3,
      children: [
        rule('12–15 characters', _validLength(password)),
        rule('At least 1 uppercase letter', _hasUpper(password)),
        rule('At least 1 lowercase letter', _hasLower(password)),
        rule('At least 1 special character', _hasSpecial(password)),
      ],
    );
  }

  Widget rule(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          size: 20,
          color: passed ? AppColors.green : AppColors.strongRed,
        ),
        const SizedBox(width: 20),
        Text(
          text,
          style: TextStyle(
            color: passed ? AppColors.green : AppColors.strongRed,
          ),
        ),
      ],
    );
  }
}
