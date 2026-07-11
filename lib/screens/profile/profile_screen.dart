import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/screens/profile/components/info_row.dart';
import 'package:medcare_app/screens/profile/components/language_dialog.dart';
import 'package:medcare_app/screens/profile/components/profile_tile.dart';
import 'package:medcare_app/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  static const String defaultEmail =
      'user@gmail.com';

  void _refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser =
        UserService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: const CustomAppbar(
          title: 'Profile',
        ),
        body: _buildNoUserState(context),
      );
    }

    final String displayName =
        currentUser.name.trim().isEmpty
            ? 'Patient'
            : currentUser.name.trim();

    final String avatarLetter =
        displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : 'P';

    final String mrNumber =
        currentUser.mrNo.trim().isEmpty
            ? '-'
            : currentUser.mrNo.trim();

    final String identification =
        currentUser.identification.trim().isEmpty
            ? '-'
            : currentUser.identification.trim();

    final String phoneNumber =
        currentUser.phone.trim().isEmpty
            ? '-'
            : currentUser.phone.trim();

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor:
                  Theme.of(context).brightness ==
                          Brightness.dark
                      ? Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                      : Colors.blue.shade50,
              child: Text(
                avatarLetter,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness ==
                              Brightness.dark
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                          : AppColors.defaultBlack,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              mrNumber,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),

            const SizedBox(height: 20),

            infoRow(
              context,
              Icons.credit_card,
              currentUser.idLabel,
              identification,
            ),

            infoRow(
              context,
              Icons.phone,
              'Contact',
              phoneNumber,
            ),

            infoRow(
              context,
              Icons.email,
              'Email',
              defaultEmail,
            ),

            const SizedBox(height: 10),

            const CustomDivider(),

            ProfileTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () async {
                final bool? isUpdated =
                    await context.push<bool>(
                  '/profile/edit-profile',
                  extra: currentUser,
                );

                if (isUpdated == true &&
                    mounted) {
                  await UserService
                      .refreshCurrentUser();

                  _refreshProfile();
                }
              },
            ),

            ProfileTile(
              icon: Icons.lock,
              title: 'Reset Password',
              onTap: () {
                context.push('/verify-otp');
              },
            ),

            ProfileTile(
              icon: Icons.payment,
              title: 'Manage Payment Method',
              onTap: () {
                context.push(
                  '/profile/manage-payment',
                );
              },
            ),

            ProfileTile(
              icon: Icons.language,
              title: 'Change Language',
              onTap: () {
                showLanguageDialog(context);
              },
            ),

            ProfileTile(
              icon: Icons.help_outline,
              title: 'Help and Support',
              onTap: () {
                context.push(
                  '/profile/help-and-support',
                );
              },
            ),

            ProfileTile(
              icon: Icons.description,
              title: 'Terms and Conditions',
              onTap: () {
                context.push(
                  '/profile/terms-menu',
                );
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.strongRed,
              ),
              onPressed: () async {
                await authService.logout();
              },
              child: const Text(
                'Log Out',
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNoUserState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 70,
              color: Theme.of(context)
                  .colorScheme
                  .onTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Profile unavailable',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please sign in again to view '
              'your profile information.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}