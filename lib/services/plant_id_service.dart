import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// A single health issue detected on a plant
class HealthIssue {
  final String name;
  final double probability;
  final String? description;
  final String? treatment;

  const HealthIssue({
    required this.name,
    required this.probability,
    this.description,
    this.treatment,
  });
}

/// Result from Plant.id identification
class PlantIdResult {
  final String scientificName;
  final String commonName;
  final List<String> commonNames;
  final double probability;
  final String? description;
  final String? imageUrl;
  final List<String> similarImages;
  final bool isHealthy;
  final String? healthAssessment;
  final List<HealthIssue> healthIssues;
  final List<String>? edibleParts;
  final Map<String, dynamic>? watering;
  final List<String>? propagationMethods;

  const PlantIdResult({
    required this.scientificName,
    required this.commonName,
    this.commonNames = const [],
    required this.probability,
    this.description,
    this.imageUrl,
    this.similarImages = const [],
    this.isHealthy = true,
    this.healthAssessment,
    this.healthIssues = const [],
    this.edibleParts,
    this.watering,
    this.propagationMethods,
  });

  factory PlantIdResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    if (result == null) {
      throw const PlantIdException('Invalid API response: missing "result" field');
    }

    // Guard: check suggestions exist and are non-empty
    final suggestions = result['classification']?['suggestions'] as List?;
    if (suggestions == null || suggestions.isEmpty) {
      throw const PlantIdException(
        'Could not identify the plant. Try a clearer photo with the plant centered.',
      );
    }

    final suggestion = suggestions[0] as Map<String, dynamic>;
    final details = (suggestion['details'] as Map<String, dynamic>?) ?? {};

    // Parse common names safely
    final rawCommonNames = details['common_names'] as List?;
    final commonNamesList = rawCommonNames != null && rawCommonNames.isNotEmpty
        ? List<String>.from(rawCommonNames)
        : <String>[];

    final primaryCommonName = commonNamesList.isNotEmpty
        ? commonNamesList.first
        : (suggestion['name'] as String?) ?? 'Unknown';

    // Parse similar images — filter out empty URLs
    final rawSimilarImages = suggestion['similar_images'] as List?;
    final similarImageUrls = rawSimilarImages != null
        ? rawSimilarImages
              .map((img) => (img as Map<String, dynamic>)['url'] as String?)
              .where((url) => url != null && url.isNotEmpty)
              .cast<String>()
              .toList()
        : <String>[];

    // Parse health data
    final healthData = result['is_healthy'] as Map<String, dynamic>?;
    final isHealthy = healthData?['binary'] as bool? ?? true;
    final healthAssessment = healthData?['assessment'] as String?;

    // Parse health issues / diseases
    final diseaseData = result['disease'] as Map<String, dynamic>?;
    final diseaseSuggestions = diseaseData?['suggestions'] as List?;
    final healthIssues = <HealthIssue>[];
    if (diseaseSuggestions != null) {
      for (final disease in diseaseSuggestions) {
        final d = disease as Map<String, dynamic>;
        healthIssues.add(HealthIssue(
          name: d['name'] as String? ?? 'Unknown Issue',
          probability: (d['probability'] as num?)?.toDouble() ?? 0.0,
          description: (d['details'] as Map<String, dynamic>?)?['description']
              as String?,
          treatment: (d['details'] as Map<String, dynamic>?)?['treatment']
              ?['biological'] as String?,
        ));
      }
    }

    // Parse edible parts
    final rawEdible = details['edible_parts'] as List?;
    final edibleParts = rawEdible != null && rawEdible.isNotEmpty
        ? List<String>.from(rawEdible)
        : null;

    // Parse watering info
    final wateringData = details['watering'] as Map<String, dynamic>?;

    // Parse propagation methods
    final rawPropagation = details['propagation_methods'] as List?;
    final propagationMethods = rawPropagation != null && rawPropagation.isNotEmpty
        ? List<String>.from(rawPropagation)
        : null;

    return PlantIdResult(
      scientificName: (suggestion['name'] as String?) ?? 'Unknown',
      commonName: primaryCommonName,
      commonNames: commonNamesList,
      probability: (suggestion['probability'] as num?)?.toDouble() ?? 0.0,
      description: (details['description'] as Map<String, dynamic>?)?['value']
          as String?,
      imageUrl: (details['image'] as Map<String, dynamic>?)?['value']
          as String?,
      similarImages: similarImageUrls,
      isHealthy: isHealthy,
      healthAssessment: healthAssessment,
      healthIssues: healthIssues,
      edibleParts: edibleParts,
      watering: wateringData,
      propagationMethods: propagationMethods,
    );
  }

  /// Create a mock result for testing when API is not configured
  factory PlantIdResult.mock() {
    return const PlantIdResult(
      scientificName: 'Ocimum sanctum',
      commonName: 'Tulsi (Holy Basil)',
      commonNames: ['Tulsi', 'Holy Basil', 'Sacred Basil'],
      probability: 0.95,
      description:
          'Holy basil, also called tulsi, is a sacred plant native to India. '
          'It is widely used in Ayurvedic medicine for its adaptogenic and '
          'immune-boosting properties.',
      isHealthy: true,
      healthIssues: [],
      edibleParts: ['leaves', 'seeds'],
      propagationMethods: ['seeds', 'stem cuttings'],
    );
  }
}

/// HTTP timeout duration for Plant.id API calls
const _apiTimeout = Duration(seconds: 15);

/// Service for Plant.id API integration
class PlantIdService {
  final http.Client _client;

  PlantIdService({http.Client? client}) : _client = client ?? http.Client();

  /// Identify a plant from image bytes.
  ///
  /// Returns a [PlantIdResult] with identification data and health assessment.
  /// Throws [PlantIdException] on API errors or unrecognizable images.
  Future<PlantIdResult> identifyFromBytes(Uint8List imageBytes) async {
    // Check if API is configured
    if (!ApiConfig.isPlantIdConfigured) {
      debugPrint('⚠️ Plant.id API not configured, using mock result');
      await Future.delayed(const Duration(seconds: 2));
      return PlantIdResult.mock();
    }

    try {
      final base64Image = base64Encode(imageBytes);

      final response = await _client
          .post(
            Uri.parse(
              '${ApiConfig.plantIdBaseUrl}/identification'
              '?details=common_names,description,image,edible_parts,watering,propagation_methods'
              '&lang=en',
            ),
            headers: {
              'Api-Key': ApiConfig.plantIdApiKey,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'images': ['data:image/jpeg;base64,$base64Image'],
              'latitude': 20.5937,
              'longitude': 78.9629,
              'similar_images': true,
              'health': 'auto',
            }),
          )
          .timeout(_apiTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PlantIdResult.fromJson(json);
      } else {
        debugPrint(
            'Plant.id API error: ${response.statusCode} - ${response.body}');

        // Parse user-friendly error message
        String message;
        switch (response.statusCode) {
          case 400:
            message = 'Invalid image format. Please try a different photo.';
            break;
          case 401:
            message = 'API key is invalid. Please check your configuration.';
            break;
          case 429:
            message = 'Too many requests. Please wait a moment and try again.';
            break;
          case 500:
          case 502:
          case 503:
            message =
                'Plant identification service is temporarily unavailable. Please try again later.';
            break;
          default:
            message = 'Identification failed (error ${response.statusCode}).';
        }
        throw PlantIdException(message);
      }
    } on TimeoutException {
      throw const PlantIdException(
        'Request timed out. Please check your internet connection and try again.',
      );
    } on PlantIdException {
      rethrow;
    } catch (e) {
      debugPrint('Plant.id error: $e');
      throw const PlantIdException(
        'Could not connect to the identification service. '
        'Please check your internet connection.',
      );
    }
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
