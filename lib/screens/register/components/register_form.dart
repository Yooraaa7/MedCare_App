import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/password_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/screens/register/components/policy_checkbox.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedPolicy = false;

  void _submit() {
    if (!_acceptedPolicy) {
      showCustomSnackbar(
        context,
        "Please accept the Terms and Policy before proceeding.",
        type: SnackbarType.error,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: submit register data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: "Name",
            hintText: 'Enter your name',
            prefixIcon: const Icon(Icons.person_outline),
            validator: Validators.name(),
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "IC / Passport",
            hintText: 'Enter your IC or Passport',
            prefixIcon: const Icon(Icons.badge_outlined),
            validator: Validators.icOrPassport(),
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "Phone Number",
            hintText: 'Enter your phone number',
            autofillHints: const [AutofillHints.telephoneNumberLocalPrefix],
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: Validators.phone(),
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "Email",
            hintText: 'Enter your email address',
            autofillHints: const [AutofillHints.email],
            prefixIcon: const Icon(Icons.mail_outline),
            validator: Validators.email(),
          ),

          AppSpacing.medium,

          PasswordField(
            validator: Validators.password(),
            isCreatePassword: true,
          ),

          AppSpacing.medium,

          PolicyCheckbox(
            value: _acceptedPolicy,
            onChanged: (val) => setState(() => _acceptedPolicy = val),
          ),

          AppSpacing.large,

          ElevatedButton(onPressed: _submit, child: Text('Create Account')),
        ],
      ),
    );
  }
}
