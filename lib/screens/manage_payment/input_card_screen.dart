import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/screens/manage_payment/components/card_agreement_section.dart';
import 'package:medcare_app/screens/manage_payment/components/card_number_formatter.dart';
import 'package:medcare_app/screens/manage_payment/components/expiry_date_formatter.dart';

class InputCardScreen extends StatefulWidget {
  final double? amount;

  const InputCardScreen({super.key, this.amount});

  @override
  State<InputCardScreen> createState() => _InputCardScreenState();
}

class _InputCardScreenState extends State<InputCardScreen> {
  final _formKey = GlobalKey<FormState>();

  bool get isPayment => widget.amount != null;

  // Form values
  String _cardNumber = '';
  String _expiry = '';
  String _cvv = '';
  String _cardholderName = '';
  bool _saveCard = true;
  bool _isDefault = false;

  void _submitForm() {
    // Authorization rule
    if (!isPayment && !_saveCard) {
      showCustomSnackbar(
        context,
        'Please authorize card storage to proceed.',
        type: SnackbarType.error,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Build card only AFTER validation
    final card = CardDetails(
      cardNumber: _cardNumber,
      expiry: _expiry,
      cvv: _cvv,
      cardholderName: _cardholderName,
      saveCard: _saveCard,
      isDefault: _isDefault,
    );

    if (!isPayment || (isPayment && card.saveCard)) {
      DataService.allCards.add(card);

      if (_isDefault) {
        for (final c in DataService.allCards) {
          if (c != card) c.isDefault = false;
        }
      }
    }

    showCustomSnackbar(
      context,
      'Card added successfully!',
      type: SnackbarType.success,
    );

    context.pop({'isUpdated': true, 'card': card});
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Add Card';
    final buttonText = 'Add Card';

    return Scaffold(
      appBar: CustomAppbar(title: title),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Debit / Credit Card",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Image.asset(
                          'assets/images/payment/dbcd.jpg',
                          width: 70,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Card Number',
                      hintText: 'Enter card number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberFormatter(),
                      ],
                      validator: Validators.validateCardNumber,
                      onSaved: (v) => _cardNumber = v!.trim(),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Expiry date',
                            hintText: 'MM / YY',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              ExpiryDateFormatter(),
                            ],
                            validator: Validators.validateExpiry,
                            onSaved: (v) => _expiry = v!.trim(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'CVV',
                            hintText: 'CVV',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: Validators.validateCVV,
                            onSaved: (v) => _cvv = v!.trim(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Cardholder Name',
                      hintText: 'Enter cardholder name',
                      validator: Validators.name(),
                      onSaved: (v) => _cardholderName = v!.trim(),
                    ),

                    const SizedBox(height: 16),

                    CardAgreementSection(
                      isDefault: _isDefault,
                      isPayment: isPayment,
                      saveCard: _saveCard,
                      onSaveCardChanged: (val) {
                        setState(() => _saveCard = val!);
                        if (!_saveCard) {
                          _isDefault =
                              false; // Reset default status if saving is revoked
                        }
                      },
                      onIsDefaultChanged: (val) =>
                          setState(() => _isDefault = val!),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
