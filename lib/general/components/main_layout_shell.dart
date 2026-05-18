import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_bottom_bar.dart';
import 'package:lottie/lottie.dart';

class MainLayoutShell extends StatefulWidget {
  final Widget child;

  const MainLayoutShell({required this.child, super.key});

  @override
  State<MainLayoutShell> createState() => _MainLayoutShellState();
}

class _MainLayoutShellState extends State<MainLayoutShell> {
  bool _showBubble = true;
  Timer? _timer;

  double _fabX = 0;
  double _fabY = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() => _showBubble = !_showBubble);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location == '/home') return 0;
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/payment')) return 2;
    if (location.startsWith('/patient-guide')) return 3;
    if (location == '/reminders') return 4;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_fabX == 0 && _fabY == 0) {
      _fabX = screenSize.width - 110;
      _fabY = screenSize.height - 240;
    }

    return Scaffold(
      body: Stack(
        children: [
          widget.child,

          Positioned(
            left: _fabX,
            top: _fabY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _fabX += details.delta.dx;
                  _fabY += details.delta.dy;

                  // Prevent dragging outside screen
                  _fabX = _fabX.clamp(0, screenSize.width - 90);
                  _fabY = _fabY.clamp(0, screenSize.height - 140);
                });
              },
              onTap: () => context.push('/chatbot'),
              child: SizedBox(
                width: 90,
                height: 120,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: 0,
                      child: AnimatedOpacity(
                        opacity: _showBubble ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Need assist?',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(12, 6),
                              painter: _BubbleArrowPainter(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Lottie.asset(
                        'assets/animations/chatbot_robot.json',
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BubbleArrowPainter oldDelegate) => false;
}