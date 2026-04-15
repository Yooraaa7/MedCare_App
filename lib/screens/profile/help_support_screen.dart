import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/filter_search_bar.dart';
import 'package:medcare_app/screens/profile/components/faq.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  late Future<List<FAQ>> _faqFuture;
  List<FAQ> _allFaqs = []; // Cache for all data
  List<FAQ> _filteredFaqs = []; // Data shown in UI

  @override
  void initState() {
    super.initState();
    _faqFuture = _loadFaqs();
  }

  // Load JSON from assets
  Future<List<FAQ>> _loadFaqs() async {
    final String response = await rootBundle.loadString(
      'assets/terms/faq.json',
    );
    final List<dynamic> data = json.decode(response);

    _allFaqs = data.map((json) => FAQ.fromJson(json)).toList();
    _filteredFaqs = _allFaqs; // Initially, show everything
    return _allFaqs;
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredFaqs = _allFaqs.where((faq) {
        final q = faq.question.toLowerCase();
        final a = faq.answer.toLowerCase();
        final search = query.toLowerCase();
        return q.contains(search) || a.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Help and Support'),
      body: FutureBuilder<List<FAQ>>(
        future: _faqFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading FAQs"));
          }

          return Column(
            children: [
              // Integrated your custom search bar
              Padding(
                padding: const EdgeInsets.all(30),
                child: FilterSearchBar(
                  hintText: 'Search FAQs...',
                  onChanged: _filterSearch,
                ),
              ),

              Expanded(
                child: _filteredFaqs.isEmpty
                    ? const Center(child: Text("No results found."))
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                        itemCount: _filteredFaqs.length,
                        itemBuilder: (context, index) {
                          final faq = _filteredFaqs[index];
                          return ExpansionTile(
                            title: Text(
                              faq.question,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [faqBox(faq.answer)],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget faqBox(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Keeps 'A:' at the top
        children: [
          Text("Ans: ", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8), // Space between 'A:' and the text
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
