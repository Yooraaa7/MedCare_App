import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';

  // Keeps conversation history for multi-turn chat
  static List<Map<String, dynamic>> _history = [];

  static Future<String> sendMessage(String userMessage) async {
    // Add user message to history
    _history.add({
      'role': 'user',
      'parts': [{'text': userMessage}]
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [{
            'text': '''You are a helpful assistant for MedCare App, 
            a mobile healthcare application. Help users with:
            - Appointment booking guidance
            - Service navigation
            - General healthcare information
            - Payment and billing inquiries
            Keep responses concise, friendly, and professional.
            Do not provide specific medical diagnoses or prescriptions.'''
          }]
        },
        'contents': _history,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['candidates'][0]['content']['parts'][0]['text'];

      // Add assistant reply to history
      _history.add({
        'role': 'model',
        'parts': [{'text': reply}]
      });

      return reply;
    } else {
      throw Exception('Gemini error: ${response.statusCode}');
    }
  }

  // Call this when user closes chatbot to reset conversation
  static void clearHistory() => _history = [];
}