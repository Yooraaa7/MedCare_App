import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/services/user_service.dart';

class EditProfileScreen
    extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _nameController;

  late final TextEditingController
      _phoneController;

  late final TextEditingController
      _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
      text: widget.user.name,
    );

    _phoneController =
        TextEditingController(
      text: widget.user.phone,
    );

    _emailController =
        TextEditingController(
      text: 'user@gmail.com',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    if (!(_formKey.currentState
            ?.validate() ??
        false)) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final String? error =
        await UserService.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (error != null) {
      showCustomSnackbar(
        context,
        error,
        type: SnackbarType.error,
      );

      return;
    }

    showCustomSnackbar(
      context,
      'Profile updated successfully!',
      type: SnackbarType.success,
    );

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Name',
                controller:
                    _nameController,
                validator:
                    Validators.name(),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Phone Number',
                controller:
                    _phoneController,
                keyboardType:
                    TextInputType.phone,
                validator:
                    Validators.phone(),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Email',
                controller:
                    _emailController,
                keyboardType:
                    TextInputType.emailAddress,
                validator:
                    Validators.email(),
              ),

              AppSpacing.xlarge,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}