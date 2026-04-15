import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/font_size.dart';

class ResendOtpTimer extends StatefulWidget {
  final VoidCallback onResend;
  const ResendOtpTimer({super.key, required this.onResend});

  @override
  State<ResendOtpTimer> createState() => _ResendOtpTimerState();
}

class _ResendOtpTimerState extends State<ResendOtpTimer> {
  static const int _seconds = 60;
  late int _remaining;
  Timer? _timer;

  TextStyle resendTextStyle() => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w600,
  );

  TextStyle? disabledTextStyle() => Theme.of(
    context,
  ).textTheme.bodySmall?.copyWith(fontSize: FontSize.regular);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remaining = _seconds;
    // Stop any existing timers and restart
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining == 0) {
        timer.cancel();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // Only allow resend if the remaining is 0
      onPressed: _remaining == 0
          ? () {
              widget.onResend();
              _startTimer();
            }
          : null,
      style: TextButton.styleFrom(
        side: BorderSide.none, // removes border
      ),
      child: Text(
        _remaining == 0 ? 'Resend Code' : 'Resend in $_remaining seconds',
        style: _remaining == 0 ? resendTextStyle() : disabledTextStyle(),
      ),
    );
  }
}
