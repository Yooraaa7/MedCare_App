import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/password_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/user_service.dart';
import 'package:medcare_app/services/appointment_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  String? _password;

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final error = await UserService.login(
      phone: _phoneNumber!,
      password: _password!,
    );

    if (!mounted) return;
    if (error != null) {
      setState(() => _isLoading = false);
      showCustomSnackbar(context, error, type: SnackbarType.error);
      return;
    }

    await authService.login(UserService.currentUserId!);
    await AppointmentService.loadCurrentUserAppointments();
    if (!mounted) return;
    setState(() => _isLoading = false);
    showCustomSnackbar(
      context,
      'Signed in successfully!',
      type: SnackbarType.success,
    );
    context.go('/home');
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

          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Sign In'),
          ),
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
