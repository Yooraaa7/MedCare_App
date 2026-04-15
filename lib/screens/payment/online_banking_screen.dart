import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/screens/online_banking/mae_login_screen.dart';

class OnlineBankingScreen extends StatelessWidget {
  final double amount;
  const OnlineBankingScreen({super.key, required this.amount});

  final List<Map<String, String>> banks = const [
    {"name": "Maybank", "logo": "assets/images/payment/maybank.png"},
    {"name": "Public Bank", "logo": "assets/images/payment/public.png"},
    {"name": "CIMB Bank", "logo": "assets/images/payment/cimb.png"},
    {"name": "Hong Leong Bank", "logo": "assets/images/payment/hongleong.png"},
    {"name": "AmBank", "logo": "assets/images/payment/ambank.png"},
    {"name": "OCBC Bank", "logo": "assets/images/payment/ocbc.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Online Banking'),
      body: ListView.separated(
        padding: const EdgeInsets.all(30),
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                bank["logo"]!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(bank["name"]!, style: const TextStyle(fontSize: 16)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (bank["name"] == "Maybank") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaeLoginScreen(),
                  ),
                );
              } else {
                Navigator.pop(context, bank["name"]);
              }
            },
          );
        },
      ),
    );
  }
}
