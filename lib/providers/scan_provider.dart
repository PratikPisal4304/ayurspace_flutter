import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/plant.dart';
import '../data/repositories/plants_repository.dart';
import '../services/plant_id_service.dart';
import '../services/gemini_service.dart';
import 'plants_provider.dart';

/// Result of a plant scan
class PlantScanResult {
  final String plantName;
  final String scientificName;
  final double confidence;
  final Plant? matchedPlant; // From local database
  final String? ayurvedicInfo; // From Gemini if no local match
  final String source; // 'local', 'ai_generated', or 'mock'
  final bool isHealthy;
  final String? description;

  const PlantScanResult({
    required this.plantName,
    required this.scientificName,
    required this.confidence,
    this.matchedPlant,
    this.ayurvedicInfo,
    required this.source,
    this.isHealthy = true,
    this.description,
  });
}

/// State for the Scanner
class ScanState {
  final bool isAnalyzing;
  final PlantScanResult? scanResult;
  final XFile? selectedImage;
  final Uint8List? imageBytes;
  final String? error;
  final String analysisStatus;

  const ScanState({
    this.isAnalyzing = false,
    this.scanResult,
    this.selectedImage,
    this.imageBytes,
    this.error,
    this.analysisStatus = '',
  });

  ScanState copyWith({
    bool? isAnalyzing,
    PlantScanResult? scanResult,
    XFile? selectedImage,
    Uint8List? imageBytes,
    String? error,
    String? analysisStatus,
    bool clearImage = false,
    bool clearResult = false,
  }) {
    return ScanState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      scanResult: clearResult ? null : (scanResult ?? this.scanResult),
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      error: error,
      analysisStatus: analysisStatus ?? this.analysisStatus,
    );
  }
}

/// Notifier for Scanner with hybrid Plant.id + Gemini approach
class ScanNotifier extends StateNotifier<ScanState> {
  final ImagePicker _picker = ImagePicker();
  final PlantIdService _plantIdService = PlantIdService();
  final GeminiService _geminiService = GeminiService();
  final PlantsRepository _plantsRepository;

  ScanNotifier(this._plantsRepository) : super(const ScanState());



  /// Pick image from source
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        state = state.copyWith(
          selectedImage: image,
          imageBytes: bytes,
          clearResult: true,
          error: null,
        );
        await analyzeImage();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  /// Analyze the selected image using hybrid approach
  Future<void> analyzeImage() async {
    if (state.imageBytes == null) return;

    state = state.copyWith(
      isAnalyzing: true,
      analysisStatus: 'Identifying plant...',
    );

    try {
      // Step 1: Use Plant.id for identification
      final plantIdResult = await _plantIdService.identifyFromBytes(state.imageBytes!);
      
      debugPrint('Plant.id result: ${plantIdResult.scientificName} (${plantIdResult.probability})');

      state = state.copyWith(
        analysisStatus: 'Searching Ayurvedic database...',
      );

      // Step 2: Try to find in local database
      final matchedPlant = await _findPlantByScientificName(plantIdResult.scientificName);

      if (matchedPlant != null) {
        // Found in local Ayurvedic database!
        debugPrint('Found in local database: ${matchedPlant.name}');
        
        state = state.copyWith(
          isAnalyzing: false,
          scanResult: PlantScanResult(
            plantName: matchedPlant.name,
            scientificName: plantIdResult.scientificName,
            confidence: plantIdResult.probability,
            matchedPlant: matchedPlant,
            source: 'local',
            isHealthy: plantIdResult.isHealthy,
            description: matchedPlant.description,
          ),
        );
      } else {
        // Not in local database - get Ayurvedic info from Gemini
        state = state.copyWith(
          analysisStatus: 'Getting Ayurvedic information...',
        );

        final geminiResponse = await _geminiService.getAyurvedicInfo(
          plantName: plantIdResult.commonName,
          scientificName: plantIdResult.scientificName,
        );

        state = state.copyWith(
          isAnalyzing: false,
          scanResult: PlantScanResult(
            plantName: plantIdResult.commonName,
            scientificName: plantIdResult.scientificName,
            confidence: plantIdResult.probability,
            ayurvedicInfo: geminiResponse.text,
            source: geminiResponse.isError ? 'error' : 'ai_generated',
            isHealthy: plantIdResult.isHealthy,
            description: plantIdResult.description,
          ),
        );
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      state = state.copyWith(
        isAnalyzing: false,
        error: 'Failed to analyze image: $e',
      );
    }
  }

  /// Find plant in local database by scientific name
  Future<Plant?> _findPlantByScientificName(String scientificName) async {
    final plants = await _plantsRepository.getPlants();
    final lowerScientific = scientificName.toLowerCase();
    
    for (final plant in plants) {
      if (plant.scientificName.toLowerCase() == lowerScientific) {
        return plant;
      }
      // Also check partial matches for flexibility
      if (plant.scientificName.toLowerCase().contains(lowerScientific) ||
          lowerScientific.contains(plant.scientificName.toLowerCase())) {
        return plant;
      }
    }
    return null;
  }

  /// Reset scanner
  void reset() {
    state = state.copyWith(
      clearImage: true,
      clearResult: true,
      error: null,
      analysisStatus: '',
    );
  }

  @override
  void dispose() {
    _plantIdService.dispose();
    _geminiService.dispose();
    super.dispose();
  }
}

/// Scan Provider with repository dependency
final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  final repository = ref.watch(plantsRepositoryProvider);
  return ScanNotifier(repository);
});
