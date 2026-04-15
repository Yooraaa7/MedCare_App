import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/font_size.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            "Don't have an account yet? ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push('/register');
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: FontSize.regular,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
