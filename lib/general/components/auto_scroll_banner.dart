import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AutoScrollBanner extends StatefulWidget {
  final List<String> bannerImages;
  final List<ColorFilter>? colorFilters;

  const AutoScrollBanner({
    super.key,
    required this.bannerImages,
    this.colorFilters,
  });

  @override
  State<AutoScrollBanner> createState() => _AutoScrollBannerState();
}

class _AutoScrollBannerState extends State<AutoScrollBanner> {
  late final PageController _controller;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController();

    if (widget.bannerImages.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;

      _currentPage =
          (_currentPage + 1) % widget.bannerImages.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bannerImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.bannerImages.length,
            onPageChanged: (index) {
              _currentPage = index;
            },
            itemBuilder: (_, index) {
              final filter = widget.colorFilters != null &&
                      index < widget.colorFilters!.length
                  ? widget.colorFilters![index]
                  : null;

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColorFiltered(
                  colorFilter: filter ??
                    const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.dst,
                    ),
                  child: Image.asset(
                    widget.bannerImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        SmoothPageIndicator(
          controller: _controller,
          count: widget.bannerImages.length,
          effect: WormEffect(
            dotColor: Theme.of(context).colorScheme.onTertiary,
            activeDotColor:
                Theme.of(context).colorScheme.primary,
            dotHeight: 9,
            dotWidth: 9,
          ),
        ),
      ],
    );
  }
}
