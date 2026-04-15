import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/back_widget.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/components/root_header.dart';
import 'package:medcare_app/general/components/root_screen.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';

class SMSResetScreen extends StatefulWidget {
  const SMSResetScreen({super.key});

  @override
  State<SMSResetScreen> createState() => _SMSResetScreenState();
}

class _SMSResetScreenState extends State<SMSResetScreen> {
  void _onPressed() {
    // TODO: Set Verification Code view email
    context.push('/verify-otp');
  }

  @override
  Widget build(BuildContext context) {
    return RootScreen(
      cardWidgets: [
        backWidget(context),
        AppSpacing.large,
        const CustomHeader(
          titleText: 'Forget Password?',
          subtitleText:
              "Please enter your phone number, we will send you a verification code.",
        ),
        AppSpacing.large,
        CustomTextField(
          label: "Phone Number",
          hintText: 'Enter your phone number',
          autofillHints: const [AutofillHints.telephoneNumberLocalPrefix],
          prefixIcon: const Icon(Icons.phone_outlined),
          validator: Validators.phone(),
        ),
        AppSpacing.large,
        ElevatedButton(onPressed: _onPressed, child: Text('Send Code')),
      ],
    );
  }
}
