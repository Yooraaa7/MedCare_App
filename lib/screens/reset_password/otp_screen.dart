import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/back_widget.dart';
import 'package:medcare_app/general/components/root_screen.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/root_header.dart';
import 'package:medcare_app/screens/reset_password/components/otp_input.dart';
import 'package:medcare_app/screens/reset_password/components/resend_otp_timer.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  bool shakeOtp = false;

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      otpControllers.map((c) => c.text).join();
      // TODO: submit OTP code
      context.push('/create-new-password');
    } else {
      setState(() {
        shakeOtp = true;
      });
      return;
    }
  }

  @override
  void dispose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RootScreen(
      cardWidgets: [
        backWidget(context),
        AppSpacing.large,

        const CustomHeader(
          titleText: 'Verify Code',
          subtitleText:
              'Please enter the code we just sent you through your SMS.',
        ),

        AppSpacing.large,

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OtpInput(otpControllers: otpControllers, shake: shakeOtp),
              AppSpacing.medium,
              ResendOtpTimer(
                onResend: () {
                  // TODO: call resend OTP API
                },
              ),
              AppSpacing.large,
              ElevatedButton(onPressed: _onPressed, child: Text('Verify')),
            ],
          ),
        ),
      ],
    );
  }
}
