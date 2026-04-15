import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/root_header.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/terms_and_policy/term_item.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopButton = false;
  late final Future<List<TermItem>> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = loadTerms();

    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 200;
      if (shouldShow != _showTopButton) {
        setState(() => _showTopButton = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<TermItem>> loadTerms() async {
    final jsonString = await rootBundle.loadString(
      'assets/terms/terms_of_use.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList
        .map((e) => TermItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Terms of Use'),
      body: FutureBuilder<List<TermItem>>(
        future: _termsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: const Text('Failed to load terms.'));
          }

          final terms = snapshot.data!;

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(
                  titleText: 'Terms of Use for Online Appointment',
                  subtitleText: '',
                ),
                AppSpacing.large,
                ...terms.map((item) => _buildTermItem(item)),
                AppSpacing.large, // space for floating button
              ],
            ),
          );
        },
      ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _showTopButton ? 1.0 : 0.0,
        child: FloatingActionButton(
          mini: true,
          child: const Icon(Icons.arrow_upward),
          onPressed: () {
            // The button fades out, screen scrolled to the top after being pressed
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTermItem(TermItem item) {
    if (item.number == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(item.text),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${item.number}.'),
          const SizedBox(width: 16),
          Expanded(child: Text(item.text)),
        ],
      ),
    );
  }
}
