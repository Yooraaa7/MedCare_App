import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/components/password_rules.dart';

class PasswordField extends StatefulWidget {
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool isCreatePassword;
  final String label;

  const PasswordField({
    super.key,
    this.onSaved,
    this.validator,
    this.controller,
    this.label = 'Password',
    this.isCreatePassword = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final FocusNode _focusNode = FocusNode();

  bool _obscureText = true;
  bool _showRules = false;
  String _password = '';

  @override
  void initState() {
    super.initState();
    if (widget.isCreatePassword) {
      _focusNode.addListener(() {
        setState(() => _showRules = _focusNode.hasFocus);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: widget.label,
          hintText: '*************',
          obscureText: _obscureText,
          controller: widget.controller,
          onSaved: widget.onSaved,
          validator: widget.validator,
          autofillHints: const [AutofillHints.password],
          focusNode: _focusNode,
          onChanged: (value) {
            setState(() => _password = value);
          },
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.onTertiary,
              size: 20,
            ),
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showRules
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(15, 16, 0, 0),
                  child: PasswordRules(password: _password),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
