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

/// Service for Google Gemini API integration
class GeminiService {
  final http.Client _client;
  
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  /// Get Ayurvedic information for a plant
  Future<GeminiResponse> getAyurvedicInfo({
    required String plantName,
    String? scientificName,
  }) async {
    final prompt = '''
You are an expert in Ayurveda and traditional Indian medicine.
Provide detailed Ayurvedic information about the plant: $plantName${scientificName != null ? ' (Scientific name: $scientificName)' : ''}.

Include the following in your response:
1. **Hindi Name**: The name in Hindi
2. **Dosha Properties**: Which doshas it balances (Vata, Pitta, Kapha)
3. **Ayurvedic Uses**: Traditional medicinal uses in Ayurveda
4. **Health Benefits**: Key health benefits
5. **How to Use**: Common preparation methods (tea, powder, paste, etc.)
6. **Precautions**: Any warnings or contraindications

Keep the response concise but informative. Format with clear sections.
''';

    return await sendMessage(prompt);
  }

  /// Send a chat message to Gemini
  Future<GeminiResponse> sendMessage(String message) async {
    if (!ApiConfig.isGeminiConfigured) {
      debugPrint('⚠️ Gemini API not configured, using mock response');
      await Future.delayed(const Duration(seconds: 1));
      return _getMockResponse(message);
    }

    try {
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/'
          '${ApiConfig.geminiModel}:generateContent?key=${ApiConfig.geminiApiKey}';

      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1024,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = json['candidates'][0]['content']['parts'][0]['text'];
        return GeminiResponse(text: text);
      } else {
        debugPrint('Gemini API error: ${response.statusCode} - ${response.body}');
        return const GeminiResponse(
          text: 'Sorry, I encountered an error. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Gemini error: $e');
      return const GeminiResponse(
        text: 'Sorry, I couldn\'t connect to the AI service. Please check your internet connection.',
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
      
      // Use Gemini 1.5 Flash for vision tasks as it supports images
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/'
          'gemini-1.5-flash:generateContent?key=${ApiConfig.geminiApiKey}';

      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = json['candidates'][0]['content']['parts'][0]['text'];
        return GeminiResponse(text: text);
      } else {
        debugPrint('Gemini Vision error: ${response.statusCode} - ${response.body}');
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
      text: '''Based on the image, this appears to be **Tulsi (Holy Basil)** - *Ocimum sanctum*.

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
