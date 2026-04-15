import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

class PolicyCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PolicyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<PolicyCheckbox> createState() => _PolicyCheckboxState();
}

class _PolicyCheckboxState extends State<PolicyCheckbox> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push('/terms-of-use');
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push('/privacy-policy');
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle requiredStyle = TextStyle(
      color: AppColors.strongRed,
      fontWeight: FontWeight.bold,
    );

    final TextStyle linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationColor: Theme.of(context).colorScheme.primary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.value,
          onChanged: (value) => widget.onChanged(value ?? false),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(
                  text:
                      "By creating an account, I have read and agreed to Hospital Lam Wah Ee's ",
                ),
                TextSpan(
                  text: 'Terms of Use',
                  style: linkStyle,
                  recognizer: _termsRecognizer,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: _privacyRecognizer,
                ),
                const TextSpan(text: ' *', style: requiredStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
