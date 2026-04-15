import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: "Name",
                controller: _nameController,
                validator: Validators.name(),
              ),
              const SizedBox(height: 16),

              // Editable Fields
              CustomTextField(
                label: "Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.phone(),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email(),
              ),

              AppSpacing.xlarge,

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.user.name = _nameController.text;
                    widget.user.phone = _phoneController.text;
                    widget.user.email = _emailController.text;

                    showCustomSnackbar(
                      context,
                      'Profile updated successfully!',
                      type: SnackbarType.success,
                    );
                    context.pop(true);
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
