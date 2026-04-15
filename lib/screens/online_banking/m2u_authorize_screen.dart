import 'package:flutter/material.dart';
import 'package:medcare_app/screens/online_banking/bank_success_screen.dart';

class M2uAuthorizeScreen extends StatelessWidget {
  const M2uAuthorizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/payment/m2u_authorize.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            bottom: 40,
            right: 30,
            child: GestureDetector(
              onTap: () {
                // Navigate to Payment Success screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentSuccessScreen(),
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
