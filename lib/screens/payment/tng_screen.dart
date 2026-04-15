import 'package:flutter/material.dart';

class TouchNGoPaymentScreen extends StatefulWidget {
  const TouchNGoPaymentScreen({super.key});

  @override
  State<TouchNGoPaymentScreen> createState() => _TouchNGoPaymentScreenState();
}

class _TouchNGoPaymentScreenState extends State<TouchNGoPaymentScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final List<String> _pinDigits = List.filled(6, '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Touch 'n Go eWallet",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Blue Header with Payment Info + Logo bridging
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Blue header
              Container(
                width: double.infinity,
                color: const Color(0xFF007AFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Payment to Lam Wah Ee Hospital",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "RM 315.00",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Logo overlapping bottom of blue box
              Positioned(
                left: 24, // 👈 keep it left aligned
                bottom: -40, // 👈 overlaps into white background
                child: Image.asset("assets/images/payment/tng.png", width: 70),
              ),
            ],
          ),

          const SizedBox(height: 60), // extra spacing after logo

          // 🔐 Log In Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Log In",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),

          // 📱 Mobile Input Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text("MY +60", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔐 PIN Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "6-digit PIN",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),

          // 🔢 PIN Boxes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Container(
                  width: 45,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _pinDigits[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 12),

          // 🔗 Forgot PIN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Forgot PIN flow
                },
                child: const Text("Forgot your PIN?"),
              ),
            ),
          ),

          const Spacer(),

          // 🔘 Log In Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Handle login and payment
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}