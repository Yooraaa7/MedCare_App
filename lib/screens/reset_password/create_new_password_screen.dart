import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/back_widget.dart';
import 'package:medcare_app/general/components/password_field.dart';
import 'package:medcare_app/general/components/root_screen.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/general/components/root_header.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.go('/');
      // TODO: submit new password
      debugPrint('Password reset successfully!');
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RootScreen(
      cardWidgets: [
        backWidget(context),
        AppSpacing.large,

        const CustomHeader(
          titleText: 'Create New Password',
          subtitleText:
              'Your new password must be different from previously used passwords.',
        ),

        AppSpacing.large,

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PasswordField(
                controller: newPasswordController,
                validator: Validators.password(),
                isCreatePassword: true,
              ),

              AppSpacing.medium,

              PasswordField(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                validator: Validators.matchPassword(newPasswordController),
              ),

              AppSpacing.large,

              ElevatedButton(
                onPressed: _onPressed,
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
