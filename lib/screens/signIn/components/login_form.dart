import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/password_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  String? _password;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (SampleData.sampleUser.phone == _phoneNumber &&
          SampleData.sampleUser.password == _password) {
        String token = '123456';
        authService.login(token);
        showCustomSnackbar(
          context,
          'Signed in successfully!',
          type: SnackbarType.success,
        );
      } else {
        showCustomSnackbar(
          context,
          'Invalid login credentials.',
          type: SnackbarType.error,
        );
      }
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
            label: "Phone Number",
            hintText: 'Enter your phone number',
            autofillHints: const [AutofillHints.telephoneNumberLocalPrefix],
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: Validators.phone(),
            onSaved: (value) => _phoneNumber = value,
          ),

          AppSpacing.medium,

          PasswordField(
            validator: Validators.required('Password'),
            onSaved: (value) => _password = value,
          ),

          AppSpacing.small,

          passwordForgottenText(context),

          AppSpacing.medium,

          ElevatedButton(onPressed: _submit, child: const Text('Sign In')),
        ],
      ),
    );
  }
}

Widget passwordForgottenText(BuildContext context) => GestureDetector(
  onTap: () {
    context.push('/sms-reset');
  },
  child: Text(
    'Password forgotten?',
    textAlign: TextAlign.end, // Optional: aligns it to the right
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),
  ),
);
