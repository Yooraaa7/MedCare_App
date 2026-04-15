import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class OtpInput extends StatefulWidget {
  final List<TextEditingController> otpControllers;
  final bool shake;

  const OtpInput({
    super.key,
    required this.otpControllers,
    this.shake = false,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput>
    with SingleTickerProviderStateMixin {
  late final List<FocusNode> focusNodes;
  late final AnimationController shakeController;
  late final Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();

    focusNodes = List.generate(6, (_) => FocusNode());

    shakeController = AnimationController(
      vsync: this, // Stops animation when off-screen
      duration: const Duration(milliseconds: 400),
    );

    shakeAnimation = Tween<double>(begin: 0, end: 8) // Horizontal pixels 0 - 8
        .chain(CurveTween(curve: Curves.elasticIn))  // Springy movements
        .animate(shakeController);
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    // When the parent updates 'shake', trigger the animation from the start
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    shakeController.dispose();
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void handleChange(String value, int index) {
    // Auto-paste full OTP
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        widget.otpControllers[i].text = value[i];
      }
      // Unfocus once all boxes are filled
      FocusScope.of(context).unfocus();
      return;
    }

    // Move forward after the current box is filled
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (_, child) {
        // Converts linear motion to oscillation
        // 8 represents the shake strength
        final offset = sin(shakeAnimation.value * pi) * 8;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return digitBox(
            otpController: widget.otpControllers[index],
            focusNode: focusNodes[index],
            index: index,
            onChanged: (value) => handleChange(value, index),
            onBackspace: () {
              if (index > 0) {
                // Allows moving backwards via Backspace
                widget.otpControllers[index - 1].clear();
                focusNodes[index - 1].requestFocus();
              }
            },
          );
        }),
      ),
    );
  }
}

Widget digitBox({
  required TextEditingController otpController,
  required FocusNode focusNode,
  required int index,
  required ValueChanged<String> onChanged,
  required VoidCallback onBackspace,
}) {
  return SizedBox(
    width: 45,
    height: 60,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        // Empty the previous box only if the current box is empty
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otpController.text.isEmpty) {
          onBackspace();
        }
      },
      child: TextFormField(
        controller: otpController,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        autofillHints:
            index == 0 ? const [AutofillHints.oneTimeCode] : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          counterText: '',
          // Avoid error box from floating
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? ' ' : null,
      ),
    ),
  );
}
