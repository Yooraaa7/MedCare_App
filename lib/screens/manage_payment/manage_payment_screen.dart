import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/status_badge.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/screens/manage_payment/components/payment_section_box.dart';

class ManagePaymentScreen extends StatefulWidget {
  const ManagePaymentScreen({super.key});

  @override
  State<ManagePaymentScreen> createState() => _ManagePaymentScreenState();
}

class _ManagePaymentScreenState extends State<ManagePaymentScreen> {
  late List<CardDetails> cardItems;
  late List<InsuranceDetails> insuranceItems;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Helper method to sync local state with DataService
  void _refreshData() {
    setState(() {
      cardItems = List<CardDetails>.from(DataService.allCards)
        ..sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));

      insuranceItems = List<InsuranceDetails>.from(DataService.allInsurance)
        ..sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Manage Payment Method'),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          // 1. Credit Cards Section
          PaymentSectionBox<CardDetails>(
            sectionTitle: "Credit / Debit Card Linked",
            items: cardItems,
            onAddMore: () async {
              final result = await context.push<Map<String, dynamic>>(
                '/profile/manage-payment/input-card',
              );

              if (result != null && result['isUpdated'] == true) {
                _refreshData();
              }
            },
            itemBuilder: (card) => _buildPaymentTile(
              context,
              title: "${card.cardType} ${card.maskedNumber}",
              isDefault: card.isDefault,
              imagePath:
                  'assets/images/cards/${card.cardType.toLowerCase()}.png',
              fallbackIcon: Icons.credit_card,
              onTap: () async {
                await context.push(
                  '/profile/manage-payment/card-details',
                  extra: card,
                );
                _refreshData();
              },
            ),
          ),

          const SizedBox(height: 32),

          // 2. Insurance Section
          PaymentSectionBox<InsuranceDetails>(
            sectionTitle: "Insurance Linked",
            items: insuranceItems,
            onAddMore: () async {
              bool? isUpdated = await context.push<bool>(
                '/profile/manage-payment/input-insurance',
              );
              if (isUpdated == true) {
                _refreshData();
              }
            },
            itemBuilder: (insurance) => _buildPaymentTile(
              context,
              title: insurance.provider,
              subtitle: insurance.policy,
              isDefault: insurance.isDefault,
              imagePath: insurance.logoPath,
              fallbackIcon: Icons.shield_outlined,
              onTap: () async {
                await context.push(
                  '/profile/manage-payment/insurance-details',
                  extra: insurance,
                );
                _refreshData();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a standardized Tile with a "Default" badge
  Widget _buildPaymentTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool isDefault,
    required String imagePath,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Image.asset(
        imagePath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(fallbackIcon),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
          : null,
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8, // Space between badge and chevron
        children: [
          if (isDefault)
            statusBadge(text: 'Default', color: AppColors.defaultGrey),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}
