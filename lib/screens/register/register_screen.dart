import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/root_screen.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/screens/register/components/register_form.dart';
import 'package:medcare_app/general/components/root_header.dart';
import 'package:medcare_app/screens/register/components/sign_prompt.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return RootScreen(
      cardWidgets: [
        const CustomHeader(
          titleText: 'Create Account',
          subtitleText: 'Please enter your personal details.',
        ),
        AppSpacing.large,
        const RegisterForm(),
        AppSpacing.medium,
        const CustomDivider(),
        AppSpacing.medium,
        const SignInPrompt(),
      ],
    );
  }
}
