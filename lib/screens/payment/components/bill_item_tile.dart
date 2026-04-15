import 'package:flutter/material.dart';
import 'package:medcare_app/models/bill_item.dart';

class BillItemTile extends StatelessWidget {
  final BillItem item;

  const BillItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Qty
          Expanded(
            flex: 1,
            child: Text("${item.qty}", style: TextStyle(fontSize: 14)),
          ),

          // Description
          Expanded(
            flex: 6,
            child: Text(
              item.description,
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
          ),

          // Amount
          Expanded(
            flex: 3,
            child: Text(
              item.amount.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
