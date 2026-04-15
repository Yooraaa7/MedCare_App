import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/screens/profile/components/info_row.dart';
import 'package:medcare_app/screens/profile/components/language_dialog.dart';
import 'package:medcare_app/screens/profile/components/profile_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Use a helper to trigger rebuild
  void _refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade50,
              child: Text(
                // Use first letter of name dynamically
                SampleData.sampleUser.name.isNotEmpty
                    ? SampleData.sampleUser.name[0].toUpperCase()
                    : "G",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.defaultBlack,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Patient Name
            Text(
              SampleData.sampleUser.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              SampleData.sampleUser.mrNo,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            infoRow(
              context,
              Icons.credit_card,
              "IC / Passport",
              SampleData.sampleUser.identification,
            ),
            infoRow(
              context,
              Icons.phone,
              "Contact",
              SampleData.sampleUser.phone,
            ),
            infoRow(context, Icons.email, "Email", SampleData.sampleUser.email),

            const SizedBox(height: 10),
            CustomDivider(),

            ProfileTile(
              icon: Icons.edit,
              title: "Edit Profile",
              onTap: () async {
                // Wait for the result from EditProfileScreen
                bool? isUpdated = await context.push<bool>(
                  '/profile/edit-profile',
                  extra: SampleData.sampleUser,
                );

                // If it returned true, refresh the UI
                if (isUpdated == true) {
                  _refreshProfile();
                }
              },
            ),

            ProfileTile(
              icon: Icons.lock,
              title: "Reset Password",
              onTap: () => context.push('/verify-otp'),
            ),
            ProfileTile(
              icon: Icons.payment,
              title: "Manage Payment Method",
              onTap: () => context.push('/profile/manage-payment'),
            ),
            ProfileTile(
              icon: Icons.language,
              title: "Change Language",
              onTap: () => showLanguageDialog(context),
            ),
            ProfileTile(
              icon: Icons.help_outline,
              title: "Help and Support",
              onTap: () => context.push('/profile/help-and-support'),
            ),
            ProfileTile(
              icon: Icons.description,
              title: "Terms and Conditions",
              onTap: () => context.push('/profile/terms-menu'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.strongRed,
              ),
              onPressed: () => authService.logout(),
              child: const Text("Log Out"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
