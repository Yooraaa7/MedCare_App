import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyCy2YI1D5D2fIN0-qyvJ5y85PHuVO2wJL8';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey';

  // Keeps conversation history for multi-turn chat
  static List<Map<String, dynamic>> _history = [];

  static Future<String> sendMessage(String userMessage) async {
    _history.add({
      'role': 'user',
      'parts': [{'text': userMessage}]
    });

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'system_instruction': {
            'parts': [
              {
                'text': '''You are MedCare Assistant, a caring and helpful AI assistant 
built into the MedCare App for Lam Wah Ee Hospital (LWEH).

Your personality:
- Warm, empathetic and caring like a nurse
- Always show concern for the patient's wellbeing first
- Keep responses concise and easy to read
- Use plain text only — do not use markdown symbols like **, ##, or bullet dashes
- Never diagnose — always recommend seeing a doctor

The MedCare App offers these services:
- Book doctor appointments by specialty
- Available specialties: Cardiology, Internal Medicine, Orthopaedic, 
  Paediatric, Obstetrics and Gynaecology, Ophthalmology, ENT, 
  Nephrology, Psychiatry, General Surgery, Geriatric, Dentistry
- Vaccination appointments
- Health screening packages
- View medical records and reports after payment
- Medication and health reminders

When a user mentions a symptom, you should:
1. Show empathy and concern for the patient first
2. Suggest which specialist or specialty in our app would be most suitable
3. Give 1 to 2 simple self-care tips while they wait
4. Encourage them to book an appointment through the MedCare App and ask do they need guide

Symptom to specialty guide:
- Fever, flu, general illness → Internal Medicine
- Chest pain, heart issues → Cardiology (advise urgent care if severe)
- Eye problems → Ophthalmology
- Child illness → Paediatric
- Bone, joint, or muscle pain → Orthopaedic
- Ear, nose, or throat issues → ENT
- Kidney problems → Nephrology
- Mental health, anxiety, depression → Psychiatry
- Pregnancy, women health → Obstetrics and Gynaecology
- Elderly care → Geriatric
- Tooth or gum problems → Dentistry
- Surgical concerns → General Surgery

Always end your response by asking if the user would like to book 
an appointment through the MedCare App.'''
              }
            ]
          },
          'contents': _history,
        }),
      );

      debugPrint('Gemini status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        _history.add({
          'role': 'model',
          'parts': [{'text': reply}]
        });
        return reply;
      } else {
        debugPrint('Gemini error body: ${response.body}');
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Gemini error: $e');
      rethrow;
    }
  }

  // Call this when user closes chatbot to reset conversation
  static void clearHistory() => _history = [];
}