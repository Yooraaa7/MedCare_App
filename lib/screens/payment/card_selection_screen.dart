import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';

class CardSelectionScreen extends StatefulWidget {
  final double amount;
  const CardSelectionScreen({super.key, required this.amount});

  @override
  State<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  late List<CardDetails> _cards;
  CardDetails? _selectedCard;

  @override
  void initState() {
    super.initState();

    // Clone and sort cards: default first
    _cards = [...DataService.allCards]..sort((a, b) => b.isDefault ? 1 : -1);

    // Preselect default card if exists
    if (DataService.allCards.isNotEmpty) {
      _selectedCard = DataService.allCards.firstWhere(
        (c) => c.isDefault,
        orElse: () => _cards.first,
      );
    } else {
      // 3. Explicitly null if no cards exist
      _selectedCard = null;
    }
  }

  // TODO: Replace with real payment
  void _confirmPayment() {
    if (_selectedCard == null) return;

    // Filter completed but unpaid appointments
    final unpaidAppointments = DataService.getAppointmentsByStatus(
      AppointmentStatus.completed,
    ).where((appt) => appt.paymentStatus != PaymentStatus.paid);

    // Update each appointment: mark paid and generate a receipt
    for (var appt in unpaidAppointments) {
      appt.paymentStatus = PaymentStatus.paid;

      // TODO: Replace with real receipt generation
      appt.billing?.add(File('/dummy/receipt.pdf'));
    }

    // Reset user total payable
    SampleData.sampleUser.totalPayable = 0;

    // Notify user
    showCustomSnackbar(
      context,
      'Payment processed successfully!',
      type: SnackbarType.success,
    );

    // Navigate away
    context.go('/payment');
  }

  void _addNewCard() async {
    final result = await context.push<Map<String, dynamic>>(
      '/profile/manage-payment/input-card?amount=${widget.amount}',
    );

    // Only update list if user chose to save the card
    if (result?["card"] != null) {
      setState(() {
        if (result?["card"].isDefault) {
          for (final c in _cards) {
            c.isDefault = false;
          }
          _cards.insert(0, result?["card"]);
        } else {
          _cards.add(result?["card"]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Select Card'),
      body: Column(
        children: [
          Expanded(
            child: RadioGroup<CardDetails>(
              groupValue: _selectedCard,
              onChanged: (val) => setState(() => _selectedCard = val),
              child: ListView.separated(
                padding: const EdgeInsets.all(30),
                itemCount: _cards.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == _cards.length) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      onTap: _addNewCard,
                      leading: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                      title: Text(
                        "Add new card",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    );
                  }

                  final card = _cards[index];
                  return RadioListTile<CardDetails>(
                    value: card,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Padding(
                      padding: const EdgeInsetsGeometry.only(bottom: 5),
                      child: Row(
                        children: [
                          // Card Icon
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'assets/images/cards/${card.cardType.toLowerCase()}.png',
                              width: 32,
                              height: 20,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.credit_card, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Card Name
                          Expanded(
                            child: Text(
                              "${card.cardType} ${card.maskedNumber}",
                              style: const TextStyle(fontSize: 15),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: (!card.saveCard)
                        ? Text(
                            'Not saved',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : (card.isDefault)
                        ? Text(
                            'Default',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : null,
                  );
                },
              ),
            ),
          ),

          // Confirm
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: ElevatedButton(
              onPressed: _selectedCard == null ? null : _confirmPayment,
              child: Text('Pay RM ${widget.amount.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
