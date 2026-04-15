import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/main.dart';

class GuestGuardScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GuestGuardScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: title, implyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  authService.logout();
                },
                child: const Text("Sign In Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
