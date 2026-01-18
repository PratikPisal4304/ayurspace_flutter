/// API Configuration
/// Replace these placeholder values with your actual API keys
class ApiConfig {
  ApiConfig._();

  /// Plant.id API Key
  /// Get yours at: https://plant.id/
  /// Free tier: 500 identifications/month
  static const String plantIdApiKey = 'fL3LPiBTHPIXbR67KDMnsybVF1UxYn1yInssCmhSAMJQOskJmD';
  
  /// Plant.id API Endpoint
  static const String plantIdBaseUrl = 'https://plant.id/api/v3';
  
  /// Google Gemini API Key
  /// Get yours at: https://makersuite.google.com/app/apikey
  /// Free tier: 60 requests/minute
  static const String geminiApiKey = 'AIzaSyD-Q0c3o1nKpLv3epsS0HR_UZ6-FXtpe-4';
  
  /// Gemini Model to use
  static const String geminiModel = 'gemini-1.5-flash';
  
  /// Check if Plant.id is configured
  static bool get isPlantIdConfigured => 
      plantIdApiKey != 'YOUR_PLANT_ID_API_KEY' && plantIdApiKey.isNotEmpty;
  
  /// Check if Gemini is configured
  static bool get isGeminiConfigured => 
      geminiApiKey != 'YOUR_GEMINI_API_KEY' && geminiApiKey.isNotEmpty;
}
