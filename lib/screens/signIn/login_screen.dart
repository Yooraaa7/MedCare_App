import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/root_screen.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/components/root_header.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/screens/signIn/components/sign_prompt.dart';
import 'package:medcare_app/screens/signIn/components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onPressed() {
    authService.setGuestMode();
  }

  @override
  Widget build(BuildContext context) {
    return RootScreen(
      cardWidgets: [
        const CustomHeader(
          titleText: 'Sign In',
          subtitleText: "Hope you're doing fine.",
        ),
        AppSpacing.large,
        const LoginForm(),
        AppSpacing.medium,
        const CustomDivider(),
        AppSpacing.medium,
        const SignUpPrompt(),
        AppSpacing.medium,

        TextButton(onPressed: _onPressed, child: Text('Continue as a guest')),
      ],
    );
  }
}
