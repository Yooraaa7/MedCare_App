import 'package:flutter/material.dart';
import 'package:medcare_app/screens/online_banking/m2u_authorize_screen.dart';

class MaeLoginScreen extends StatelessWidget {
  const MaeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFED700), // 👈 Yellow background from image
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const M2uAuthorizeScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/payment/mae.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
