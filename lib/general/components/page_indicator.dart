import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget pageIndicator(
  BuildContext context, 
  {
    required PageController controller,
    required int count
  }
) => Center(
  child: SmoothPageIndicator(
    controller: controller,
    count: count,
    effect: WormEffect(
      dotColor: Theme.of(context).colorScheme.onTertiary,
      activeDotColor: Theme.of(context).colorScheme.primary,
      dotHeight: 9,
      dotWidth: 9,
    ),
  ),
);