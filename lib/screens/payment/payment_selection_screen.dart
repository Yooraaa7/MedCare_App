import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/payment/components/payment_card.dart';
import 'package:medcare_app/screens/payment/tng_screen.dart';

class PaymentSelectionScreen extends StatelessWidget {
  final double amount;
  const PaymentSelectionScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Select Payment Method'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Total Payable Section
            Text(
              "Total Payable",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppSpacing.small,
            Text(
              "RM ${amount.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.strongRed,
              ),
            ),

            AppSpacing.xlarge,

            paymentCard(
              context,
              label: "CREDIT / DEBIT CARD",
              imagePath: "assets/images/payment/dbcd.jpg",
              onTap: () => _processPayment(context, "Card"),
            ),

            AppSpacing.large,

            paymentCard(
              context,
              label: "ONLINE BANKING",
              imagePath: "assets/images/payment/onlinebanking.jpg",
              onTap: () => _processPayment(context, "FPX"),
            ),

            AppSpacing.large,

            paymentCard(
              context,
              label: "TOUCH 'N GO E-WALLET",
              imagePath: "assets/images/payment/tng.png",
              onTap: () => _processPayment(context, "TnG"),
            ),

            AppSpacing.large,

            paymentCard(
              context,
              label: "PAY AT COUNTER / KIOSK",
              imagePath: null,
              onTap: () => _processPayment(context, "Counter"),
            ),
          ],
        ),
      ),
    );
  }

  // Immediate Action Logic
  void _processPayment(BuildContext context, String method) {
    // Add your navigation or API call here
    switch (method.toLowerCase()) {
      case 'card':
        context.push('/payment-selection/card?amount=$amount');
        break;
      case 'counter':
        context.push('/payment-selection/pay-at-counter?amount=$amount');
        break;
      case 'tng':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TouchNGoPaymentScreen(),
          ),
        );
        break;
      case 'fpx':
        context.push('/payment-selection/online-banking?amount=$amount');
      case _:
        break;
    }
  }
}
