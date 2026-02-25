import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Configuration
/// Loads keys from .env file
class ApiConfig {
  ApiConfig._();

  /// Plant.id API Key
  /// Free tier: 500 identifications/month
  static String get plantIdApiKey => dotenv.env['PLANT_ID_API_KEY'] ?? '';
  
  /// Plant.id API Endpoint
  static const String plantIdBaseUrl = 'https://plant.id/api/v3';
  
  /// Google Gemini API Key
  /// Free tier: 60 requests/minute
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  /// Gemini Model to use
  static const String geminiModel = 'gemini-2.5-flash';
  
  /// Check if Plant.id is configured
  static bool get isPlantIdConfigured => 
      plantIdApiKey.isNotEmpty && plantIdApiKey != 'YOUR_PLANT_ID_API_KEY';
  
  /// Check if Gemini is configured
  static bool get isGeminiConfigured => 
      geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY';
}
