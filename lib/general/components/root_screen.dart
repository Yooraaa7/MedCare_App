import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class RootScreen extends StatefulWidget {
  final List<Widget> cardWidgets;
  const RootScreen({super.key, required this.cardWidgets});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  static const double _collapsedHeight = 140;
  static const double _expandedHeight = 280;
  static const double _maxOverscroll = _expandedHeight - _collapsedHeight;

  late ScrollController _scrollController;
  double _headerHeight = _collapsedHeight;
  double _scale = 1.3; // Starting zoom level (1.3 = 130%)

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double offset = _scrollController.offset;

    setState(() {
      if (offset < 0) {
        // 1. Handle Height Expansion
        _headerHeight = (_collapsedHeight - offset).clamp(_collapsedHeight, _expandedHeight);

        // 2. Handle Zoom Out Logic
        // We calculate how far we are into the overscroll (0.0 to 1.0)
        double progress = (-offset / _maxOverscroll).clamp(0.0, 1.0);
        
        // Scale moves from 1.3 down to 1.0 based on progress
        _scale = 1.3 - (0.3 * progress);
      } else {
        _headerHeight = _collapsedHeight;
        _scale = 1.3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String logoPath = isDark
        ? 'assets/images/medcare_banner.png'
        : 'assets/images/medcare_banner.png';

    return Scaffold(
      body: Stack(
        children: [
          // THE IMAGE LAYER
          SizedBox(
            height: _headerHeight,
            width: double.infinity,
            child: ClipRect( 
              child: Transform.scale(
                scale: _scale,
                child: Image.asset(
                  'assets/images/medcare_building.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // THE CONTENT LAYER
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: _collapsedHeight - 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          logoPath,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      AppSpacing.large,
                      ...widget.cardWidgets,
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}