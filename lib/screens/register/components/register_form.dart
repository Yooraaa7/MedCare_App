import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/password_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/screens/register/components/policy_checkbox.dart';
import 'package:medcare_app/services/user_service.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedPolicy = false;
  bool _isLoading = false;

  String? _name;
  String? _icNo;
  String? _phone;
  String? _email;
  String? _password;

  Future<void> _submit() async {
    if (!_acceptedPolicy) {
      showCustomSnackbar(
        context,
        "Please accept the Terms and Policy before proceeding.",
        type: SnackbarType.error,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final error = await UserService.register(
      name: _name!,
      phone: _phone!,
      password: _password!,
      icNo: _icNo!,
      isForeign: _isIcForeign(_icNo!),
      email: _email,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      showCustomSnackbar(
        context,
        'Account created successfully! Please sign in.',
        type: SnackbarType.success,
      );
      // Navigate back to login
      context.go('/login');
    } else {
      showCustomSnackbar(context, error, type: SnackbarType.error);
    }
  }

  // Simple check — passport numbers are typically longer or contain letters
  bool _isIcForeign(String value) {
    return value.contains(RegExp(r'[a-zA-Z]')) || value.length > 12;
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
            onSaved: (value) => _name = value,
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "IC / Passport",
            hintText: 'Enter your IC or Passport',
            prefixIcon: const Icon(Icons.badge_outlined),
            validator: Validators.icOrPassport(),
            onSaved: (value) => _icNo = value,
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "Phone Number",
            hintText: 'Enter your phone number',
            autofillHints: const [AutofillHints.telephoneNumberLocalPrefix],
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: Validators.phone(),
            onSaved: (value) => _phone = value,
            keyboardType: TextInputType.phone,
          ),

          AppSpacing.medium,

          CustomTextField(
            label: "Email (Optional)",
            hintText: 'Enter your email address',
            autofillHints: const [AutofillHints.email],
            prefixIcon: const Icon(Icons.mail_outline),
            validator: Validators.emailOptional(),
            onSaved: (value) => _email = value?.isEmpty == true ? null : value,
            keyboardType: TextInputType.emailAddress,
          ),

          AppSpacing.medium,

          PasswordField(
            validator: Validators.password(),
            isCreatePassword: true,
            onSaved: (value) => _password = value,
          ),

          AppSpacing.medium,

          PolicyCheckbox(
            value: _acceptedPolicy,
            onChanged: (val) => setState(() => _acceptedPolicy = val),
          ),

          AppSpacing.large,

          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}