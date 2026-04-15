import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/screens/profile/components/profile_tile.dart';

class TermsMenuScreen extends StatelessWidget {
  const TermsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Terms and Conditions'),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () => context.push('/privacy-policy'),
            ),

            const SizedBox(height: 12),

            ProfileTile(
              icon: Icons.description,
              title: 'Terms of Use',
              onTap: () => context.push('/terms-of-use'),
            ),
          ],
        ),
      ),
    );
  }
}
