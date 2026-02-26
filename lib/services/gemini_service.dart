import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Response from Gemini API
class GeminiResponse {
  final String text;
  final bool isError;

  const GeminiResponse({
    required this.text,
    this.isError = false,
  });
}

/// A single turn in a multi-turn conversation
class ChatTurn {
  final String role; // 'user' or 'model'
  final String text;

  const ChatTurn({required this.role, required this.text});

  Map<String, dynamic> toJson() => {
        'role': role,
        'parts': [
          {'text': text}
        ],
      };
}

/// Service for Google Gemini API integration
class GeminiService {
  final http.Client _client;

  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  /// Standard safety settings for all requests
  static const List<Map<String, String>> _safetySettings = [
    {
      'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
      'threshold': 'BLOCK_ONLY_HIGH',
    },
    {
      'category': 'HARM_CATEGORY_HARASSMENT',
      'threshold': 'BLOCK_ONLY_HIGH',
    },
    {
      'category': 'HARM_CATEGORY_HATE_SPEECH',
      'threshold': 'BLOCK_ONLY_HIGH',
    },
    {
      'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
      'threshold': 'BLOCK_ONLY_HIGH',
    },
  ];

  /// Standard generation config
  static const Map<String, dynamic> _generationConfig = {
    'temperature': 0.8,
    'maxOutputTokens': 2048,
    'topP': 0.95,
    'topK': 40,
  };

  /// Parse response text safely from Gemini API JSON
  String? _parseResponseText(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) return null;
      final content = candidates[0]['content'] as Map<String, dynamic>?;
      if (content == null) return null;
      final parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) return null;
      return parts[0]['text'] as String?;
    } catch (e) {
      debugPrint('Error parsing Gemini response: $e');
      return null;
    }
  }

  /// Get Ayurvedic information for a plant
  Future<GeminiResponse> getAyurvedicInfo({
    required String plantName,
    String? scientificName,
  }) async {
    final prompt = '''
You are AyurBot 🙏, a friendly Ayurvedic wellness guide.
Tell me about the plant: **$plantName**${scientificName != null ? ' (Scientific name: *$scientificName*)' : ''}.

Please include:
🌿 **Hindi Name** — What it's called in Hindi
⚖️ **Dosha Effect** — Which doshas (Vata, Pitta, Kapha) it helps balance
💊 **Ayurvedic Uses** — What it's traditionally used for
✨ **Health Benefits** — Top 3-4 benefits in simple words
🍵 **How to Use at Home** — 2-3 easy preparation methods (tea, powder, paste, etc.) with quantities
⚠️ **Precautions** — Any warnings, especially for pregnant women or those on medication

Keep it friendly, practical, and under 300 words. Use emojis and bullet points for readability.
''';

    return await sendMessage(prompt);
  }

  /// Send a simple single-turn message to Gemini (used by plant info, etc.)
  Future<GeminiResponse> sendMessage(String message) async {
    if (!ApiConfig.isGeminiConfigured) {
      debugPrint('⚠️ Gemini API not configured, using mock response');
      await Future.delayed(const Duration(seconds: 1));
      return _getMockResponse(message);
    }

    try {
      const url = 'https://generativelanguage.googleapis.com/v1beta/models/'
          '${ApiConfig.geminiModel}:generateContent';

      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': ApiConfig.geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ],
          'generationConfig': _generationConfig,
          'safetySettings': _safetySettings,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = _parseResponseText(json);
        if (text != null && text.isNotEmpty) {
          return GeminiResponse(text: text);
        }
        return const GeminiResponse(
          text:
              'I received an empty response. Could you try rephrasing your question?',
          isError: true,
        );
      } else {
        debugPrint(
            'Gemini API error: ${response.statusCode} - ${response.body}');
        return const GeminiResponse(
          text: 'Sorry, I encountered an error. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Gemini error: $e');
      return const GeminiResponse(
        text:
            'Sorry, I couldn\'t connect to the AI service. Please check your internet connection.',
        isError: true,
      );
    }
  }

  /// Send a multi-turn chat to Gemini with system instruction and conversation history
  Future<GeminiResponse> sendChat({
    required String systemInstruction,
    required List<ChatTurn> conversationHistory,
  }) async {
    if (!ApiConfig.isGeminiConfigured) {
      debugPrint('⚠️ Gemini API not configured, using mock response');
      await Future.delayed(const Duration(seconds: 1));
      final lastUserMsg = conversationHistory
          .lastWhere((t) => t.role == 'user',
              orElse: () => const ChatTurn(role: 'user', text: ''))
          .text;
      return _getMockResponse(lastUserMsg);
    }

    try {
      const url = 'https://generativelanguage.googleapis.com/v1beta/models/'
          '${ApiConfig.geminiModel}:generateContent';

      final body = <String, dynamic>{
        'system_instruction': {
          'parts': [
            {'text': systemInstruction}
          ],
        },
        'contents': conversationHistory.map((t) => t.toJson()).toList(),
        'generationConfig': _generationConfig,
        'safetySettings': _safetySettings,
      };

      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': ApiConfig.geminiApiKey,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = _parseResponseText(json);
        if (text != null && text.isNotEmpty) {
          return GeminiResponse(text: text);
        }
        return const GeminiResponse(
          text:
              'I received an empty response. Could you try rephrasing your question?',
          isError: true,
        );
      } else {
        debugPrint(
            'Gemini Chat error: ${response.statusCode} - ${response.body}');
        return const GeminiResponse(
          text: 'Sorry, I encountered an error. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Gemini Chat error: $e');
      return const GeminiResponse(
        text:
            'Sorry, I couldn\'t connect to the AI service. Please check your internet connection.',
        isError: true,
      );
    }
  }

  /// Analyze an image with Gemini Vision
  Future<GeminiResponse> analyzeImage({
    required Uint8List imageBytes,
    required String prompt,
  }) async {
    if (!ApiConfig.isGeminiConfigured) {
      debugPrint('⚠️ Gemini API not configured, using mock response');
      await Future.delayed(const Duration(seconds: 2));
      return _getMockImageAnalysis();
    }

    try {
      final base64Image = base64Encode(imageBytes);

      const url = 'https://generativelanguage.googleapis.com/v1beta/models/'
          '${ApiConfig.geminiModel}:generateContent';

      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': ApiConfig.geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.4,
            'maxOutputTokens': 2048,
            'topP': 0.95,
            'topK': 40,
          },
          'safetySettings': _safetySettings,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = _parseResponseText(json);
        if (text != null && text.isNotEmpty) {
          return GeminiResponse(text: text);
        }
        return const GeminiResponse(
          text:
              'Sorry, I couldn\'t analyze this image clearly. Could you try with a different photo?',
          isError: true,
        );
      } else {
        debugPrint(
            'Gemini Vision error: ${response.statusCode} - ${response.body}');
        return const GeminiResponse(
          text: 'Sorry, I couldn\'t analyze this image. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Gemini Vision error: $e');
      return const GeminiResponse(
        text: 'Sorry, I couldn\'t connect to the AI service.',
        isError: true,
      );
    }
  }

  /// Mock response for testing when API is not configured
  GeminiResponse _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('tulsi') || lowerMessage.contains('basil')) {
      return const GeminiResponse(
        text: '''**Hindi Name**: तुलसी (Tulsi)

**Dosha Properties**: Balances Vata and Kapha, may increase Pitta in excess

**Ayurvedic Uses**:
- Respiratory health and cough relief
- Immune system support
- Stress and anxiety reduction
- Digestive aid

**Health Benefits**:
- Rich in antioxidants
- Natural antibacterial properties
- Supports healthy blood sugar levels
- Promotes mental clarity

**How to Use**:
- Fresh leaves chewed daily
- Tulsi tea (2-3 leaves in hot water)
- Tulsi powder with honey

**Precautions**:
- May affect blood clotting
- Pregnant women should consult a doctor
- May interact with diabetes medications''',
      );
    }

    return const GeminiResponse(
      text: '''I'm your Ayurveda assistant. I can help you with:
- Plant identification and Ayurvedic properties
- Dosha-balancing remedies
- Traditional herbal preparations
- Wellness tips based on Ayurveda

How can I assist you today?''',
    );
  }

  GeminiResponse _getMockImageAnalysis() {
    return const GeminiResponse(
      text:
          '''Based on the image, this appears to be **Tulsi (Holy Basil)** - *Ocimum sanctum*.

**Ayurvedic Properties**:
- **Dosha**: Balances Vata and Kapha
- **Taste (Rasa)**: Pungent, bitter
- **Energy (Virya)**: Heating
- **Post-digestive effect (Vipaka)**: Pungent

**Traditional Uses**:
This sacred plant is used for respiratory health, stress relief, and immune support in Ayurveda.

*Note: This is AI-generated information. Please verify with an Ayurvedic practitioner.*''',
    );
  }

  void dispose() {
    _client.close();
  }
}
