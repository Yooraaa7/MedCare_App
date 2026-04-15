import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/font_size.dart';

class CustomHeader extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  const CustomHeader({
    super.key,
    required this.titleText,
    required this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titleText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          subtitleText,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontSize: FontSize.regular),
        ),
      ],
    );
  }
}
