import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcare_app/general/components/field_label.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class CustomTextField extends StatelessWidget {
  final GlobalKey<FormFieldState<DateTime>>? fieldKey;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? forceErrorText;
  final int maxLine;
  final bool readonly;

  const CustomTextField({
    super.key,
    this.fieldKey,
    this.label,
    this.hintText,
    this.initialValue,
    this.obscureText = false,
    this.controller,
    this.onSaved,
    this.validator,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.autofillHints,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.forceErrorText,
    this.maxLine = 1,
    this.readonly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[FieldLabel(label!), AppSpacing.small],

        TextFormField(
          key: fieldKey,
          controller: controller,
          obscureText: obscureText,
          onSaved: onSaved,
          validator: validator,
          autofillHints: autofillHints,
          focusNode: focusNode,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLine,
          readOnly: readonly,
          onTap: onTap,
          forceErrorText: forceErrorText,
          initialValue: initialValue,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
