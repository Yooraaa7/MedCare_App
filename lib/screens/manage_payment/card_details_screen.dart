import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/screens/manage_payment/components/payment_row.dart';

class CardDetailsScreen extends StatefulWidget {
  final CardDetails card;

  const CardDetailsScreen({super.key, required this.card});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String assetPath =
        'assets/images/cards/${widget.card.cardType.toLowerCase()}.png';

    return Scaffold(
      appBar: const CustomAppbar(title: 'Card Details'),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Logo
            Center(
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                width: 80,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.credit_card, size: 40),
              ),
            ),

            AppSpacing.small,

            /// Card Name
            Center(
              child: Text(
                widget.card.cardType,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            AppSpacing.small,

            /// Masked Number
            Center(
              child: Text(
                widget.card.maskedNumber,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

            AppSpacing.xlarge,

            // Expiry Date
            paymentRow(
              context,
              title: 'Expiry Date',
              trailing: Text(
                widget.card.formattedExpiry,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Set Default
            paymentRow(
              context,
              title: 'Set as Default',
              trailing: Switch(
                value: widget.card.isDefault,
                onChanged: (value) {
                  // Ensure only one card is set as default
                  if (value == true) {
                    for (final c in DataService.allCards) {
                      if (c != widget.card) c.isDefault = false;
                    }
                  }

                  setState(() {
                    widget.card.isDefault = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            /// Delete
            GestureDetector(
              onTap: () {
                _showDeleteDialog(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: AppColors.strongRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showWarningDialog(
      context,
      title: 'Delete Card',
      content: 'Are you sure you want to delete this card?',
      actionColor: AppColors.strongRed,
      actionText: 'Delete',
      onTapAction: () {
        DataService.allCards.remove(widget.card);
        showCustomSnackbar(
          context,
          'Card deleted successfully!',
          type: SnackbarType.success,
        );
        context.pop();
        context.pop();
      },
      onTapBack: () => context.pop(),
    );
  }
}
