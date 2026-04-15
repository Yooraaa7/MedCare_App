import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key});

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Flexible(
                    child: Text(
                      "Do you have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ),
                GestureDetector(
                    onTap: () {
                        context.push('/');
                    },
                    child: Text(
                        'Sign in',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                ),
            ],
        );
    }
}
