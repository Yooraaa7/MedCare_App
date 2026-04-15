import 'package:flutter/material.dart';

class CardAgreementSection extends StatelessWidget {
  final bool isPayment;
  final bool isDefault;
  final bool saveCard;
  final ValueChanged<bool?> onSaveCardChanged;
  final ValueChanged<bool?> onIsDefaultChanged;

  const CardAgreementSection({
    super.key,
    required this.isPayment,
    required this.saveCard,
    required this.isDefault,
    required this.onSaveCardChanged,
    required this.onIsDefaultChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The "Authorization" master switch
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            "I authorize this app to securely store my card details for future payments",
            style: TextStyle(fontSize: 14),
          ),
          value: saveCard,
          onChanged: onSaveCardChanged,
        ),

        // The "Default" option (only shown if authorized)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: saveCard
              ? CheckboxListTile(
                  key: const ValueKey('default_checkbox'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Set card as default",
                    style: TextStyle(fontSize: 14),
                  ),
                  value: isDefault,
                  onChanged: onIsDefaultChanged, // Fixed callback
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}