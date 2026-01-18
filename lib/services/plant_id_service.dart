import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Result from Plant.id identification
class PlantIdResult {
  final String scientificName;
  final String commonName;
  final double probability;
  final String? description;
  final String? imageUrl;
  final List<String> similarImages;
  final bool isHealthy;
  final String? healthAssessment;

  const PlantIdResult({
    required this.scientificName,
    required this.commonName,
    required this.probability,
    this.description,
    this.imageUrl,
    this.similarImages = const [],
    this.isHealthy = true,
    this.healthAssessment,
  });

  factory PlantIdResult.fromJson(Map<String, dynamic> json) {
    final suggestion = json['result']['classification']['suggestions'][0];
    final details = suggestion['details'] ?? {};
    
    return PlantIdResult(
      scientificName: suggestion['name'] ?? 'Unknown',
      commonName: details['common_names']?.first ?? suggestion['name'] ?? 'Unknown',
      probability: (suggestion['probability'] ?? 0.0).toDouble(),
      description: details['description']?['value'],
      imageUrl: details['image']?['value'],
      similarImages: List<String>.from(
        (suggestion['similar_images'] ?? []).map((img) => img['url'] ?? ''),
      ),
      isHealthy: json['result']['is_healthy']?['binary'] ?? true,
      healthAssessment: json['result']['is_healthy']?['assessment'],
    );
  }

  /// Create a mock result for testing when API is not configured
  factory PlantIdResult.mock() {
    return const PlantIdResult(
      scientificName: 'Ocimum sanctum',
      commonName: 'Tulsi (Holy Basil)',
      probability: 0.95,
      description: 'Holy basil, also called tulsi, is a plant native to India.',
      isHealthy: true,
    );
  }
}

/// Service for Plant.id API integration
class PlantIdService {
  final http.Client _client;
  
  PlantIdService({http.Client? client}) : _client = client ?? http.Client();

  /// Identify a plant from image bytes
  Future<PlantIdResult> identifyFromBytes(Uint8List imageBytes) async {
    // Check if API is configured
    if (!ApiConfig.isPlantIdConfigured) {
      debugPrint('⚠️ Plant.id API not configured, using mock result');
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
      return PlantIdResult.mock();
    }

    try {
      final base64Image = base64Encode(imageBytes);
      
      final response = await _client.post(
        Uri.parse('${ApiConfig.plantIdBaseUrl}/identification'),
        headers: {
          'Api-Key': ApiConfig.plantIdApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': ['data:image/jpeg;base64,$base64Image'],
          'latitude': 20.5937, // India center coordinates
          'longitude': 78.9629,
          'similar_images': true,
          'health': 'auto',
          'language': 'en',
          'details': [
            'common_names',
            'description',
            'image',
            'edible_parts',
            'watering',
            'propagation_methods',
          ],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return PlantIdResult.fromJson(json);
      } else {
        debugPrint('Plant.id API error: ${response.statusCode} - ${response.body}');
        throw PlantIdException('API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Plant.id error: $e');
      rethrow;
    }
  }

  /// Identify a plant from a file path (for mobile)
  Future<PlantIdResult> identifyFromPath(String imagePath) async {
    // For web, we'll need to handle this differently
    // This is primarily for mobile where we have file system access
    throw UnimplementedError('Use identifyFromBytes for cross-platform support');
  }

  void dispose() {
    _client.close();
  }
}

/// Exception for Plant.id errors
class PlantIdException implements Exception {
  final String message;
  const PlantIdException(this.message);
  
  @override
  String toString() => 'PlantIdException: $message';
}
