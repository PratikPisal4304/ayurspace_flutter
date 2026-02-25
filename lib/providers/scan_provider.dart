import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/plant.dart';
import '../data/repositories/plants_repository.dart';
import '../services/plant_id_service.dart';
import '../services/gemini_service.dart';
import 'plants_provider.dart';

/// Data source for a scan result
enum ScanSource {
  local,
  aiGenerated,
  mock,
  error,
}

/// Steps during the analysis pipeline
enum AnalysisStep {
  idle,
  identifying,
  searchingDatabase,
  gettingAyurvedic,
  done,
}

/// Result of a plant scan
class PlantScanResult {
  final String plantName;
  final String scientificName;
  final double confidence;
  final Plant? matchedPlant;
  final String? ayurvedicInfo;
  final ScanSource source;
  final bool isHealthy;
  final String? description;
  final List<String> commonNames;
  final List<HealthIssue> healthIssues;
  final List<String>? edibleParts;
  final Map<String, dynamic>? watering;
  final List<String>? propagationMethods;
  final String? imageUrl;
  final List<String> similarImages;
  final Uint8List? capturedImageBytes;

  const PlantScanResult({
    required this.plantName,
    required this.scientificName,
    required this.confidence,
    this.matchedPlant,
    this.ayurvedicInfo,
    required this.source,
    this.isHealthy = true,
    this.description,
    this.commonNames = const [],
    this.healthIssues = const [],
    this.edibleParts,
    this.watering,
    this.propagationMethods,
    this.imageUrl,
    this.similarImages = const [],
    this.capturedImageBytes,
  });
}

/// State for the Scanner
class ScanState {
  final bool isAnalyzing;
  final AnalysisStep analysisStep;
  final PlantScanResult? scanResult;
  final XFile? selectedImage;
  final Uint8List? imageBytes;
  final String? error;
  final List<PlantScanResult> scanHistory;

  const ScanState({
    this.isAnalyzing = false,
    this.analysisStep = AnalysisStep.idle,
    this.scanResult,
    this.selectedImage,
    this.imageBytes,
    this.error,
    this.scanHistory = const [],
  });

  /// Human-readable status text for the current analysis step
  String get analysisStatus {
    switch (analysisStep) {
      case AnalysisStep.idle:
        return '';
      case AnalysisStep.identifying:
        return 'Identifying plant...';
      case AnalysisStep.searchingDatabase:
        return 'Searching Ayurvedic database...';
      case AnalysisStep.gettingAyurvedic:
        return 'Getting Ayurvedic insights...';
      case AnalysisStep.done:
        return 'Done!';
    }
  }

  ScanState copyWith({
    bool? isAnalyzing,
    AnalysisStep? analysisStep,
    PlantScanResult? scanResult,
    XFile? selectedImage,
    Uint8List? imageBytes,
    String? error,
    List<PlantScanResult>? scanHistory,
    bool clearImage = false,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return ScanState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      analysisStep: analysisStep ?? this.analysisStep,
      scanResult: clearResult ? null : (scanResult ?? this.scanResult),
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      error: clearError ? null : (error ?? this.error),
      scanHistory: scanHistory ?? this.scanHistory,
    );
  }
}

/// Max number of scan history items to keep
const _maxHistoryItems = 10;

/// Notifier for Scanner with hybrid Plant.id + Gemini approach
class ScanNotifier extends StateNotifier<ScanState> {
  final ImagePicker _picker;
  final PlantIdService _plantIdService;
  final GeminiService _geminiService;
  final PlantsRepository _plantsRepository;

  /// Guard to prevent concurrent analysis runs
  bool _isAnalysisRunning = false;

  ScanNotifier(
    this._plantsRepository, {
    ImagePicker? picker,
    PlantIdService? plantIdService,
    GeminiService? geminiService,
  })  : _picker = picker ?? ImagePicker(),
        _plantIdService = plantIdService ?? PlantIdService(),
        _geminiService = geminiService ?? GeminiService(),
        super(const ScanState());

  /// Pick image from source and start analysis
  Future<void> pickImage(ImageSource source) async {
    // Prevent picking while already analyzing
    if (_isAnalysisRunning) return;

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
          clearError: true,
        );
        await analyzeImage();
      }
    } catch (e) {
      if (e.toString().contains('photo_access_denied') ||
          e.toString().contains('camera_access_denied')) {
        state = state.copyWith(
          error: 'Permission denied. Please enable access in Settings.',
        );
      } else {
        state = state.copyWith(error: 'Failed to pick image: $e');
      }
    }
  }

  /// Analyze the selected image using hybrid approach.
  /// Guarded against concurrent execution.
  Future<void> analyzeImage() async {
    if (state.imageBytes == null || _isAnalysisRunning) return;

    _isAnalysisRunning = true;
    state = state.copyWith(
      isAnalyzing: true,
      analysisStep: AnalysisStep.identifying,
      clearError: true,
    );

    try {
      // Step 1: Use Plant.id for identification
      final plantIdResult =
          await _plantIdService.identifyFromBytes(state.imageBytes!);

      debugPrint(
          'Plant.id result: ${plantIdResult.scientificName} (${plantIdResult.probability})');

      state = state.copyWith(
        analysisStep: AnalysisStep.searchingDatabase,
      );

      // Step 2: Try to find in local database
      final matchedPlant =
          await _findPlantByScientificName(plantIdResult.scientificName);

      PlantScanResult scanResult;

      if (matchedPlant != null) {
        debugPrint('Found in local database: ${matchedPlant.name}');

        scanResult = PlantScanResult(
          plantName: matchedPlant.name,
          scientificName: plantIdResult.scientificName,
          confidence: plantIdResult.probability,
          matchedPlant: matchedPlant,
          source: ScanSource.local,
          isHealthy: plantIdResult.isHealthy,
          description: matchedPlant.description,
          commonNames: plantIdResult.commonNames,
          healthIssues: plantIdResult.healthIssues,
          edibleParts: plantIdResult.edibleParts,
          watering: plantIdResult.watering,
          propagationMethods: plantIdResult.propagationMethods,
          imageUrl: plantIdResult.imageUrl,
          similarImages: plantIdResult.similarImages,
          capturedImageBytes: state.imageBytes,
        );
      } else {
        // Not in local database — get Ayurvedic info from Gemini
        state = state.copyWith(
          analysisStep: AnalysisStep.gettingAyurvedic,
        );

        final geminiResponse = await _geminiService.getAyurvedicInfo(
          plantName: plantIdResult.commonName,
          scientificName: plantIdResult.scientificName,
        );

        scanResult = PlantScanResult(
          plantName: plantIdResult.commonName,
          scientificName: plantIdResult.scientificName,
          confidence: plantIdResult.probability,
          ayurvedicInfo: geminiResponse.text,
          source:
              geminiResponse.isError ? ScanSource.error : ScanSource.aiGenerated,
          isHealthy: plantIdResult.isHealthy,
          description: plantIdResult.description,
          commonNames: plantIdResult.commonNames,
          healthIssues: plantIdResult.healthIssues,
          edibleParts: plantIdResult.edibleParts,
          watering: plantIdResult.watering,
          propagationMethods: plantIdResult.propagationMethods,
          imageUrl: plantIdResult.imageUrl,
          similarImages: plantIdResult.similarImages,
          capturedImageBytes: state.imageBytes,
        );
      }

      // Add to scan history
      final updatedHistory = [scanResult, ...state.scanHistory];
      if (updatedHistory.length > _maxHistoryItems) {
        updatedHistory.removeRange(_maxHistoryItems, updatedHistory.length);
      }

      state = state.copyWith(
        isAnalyzing: false,
        analysisStep: AnalysisStep.done,
        scanResult: scanResult,
        scanHistory: updatedHistory,
      );
    } catch (e) {
      debugPrint('Scan error: $e');
      state = state.copyWith(
        isAnalyzing: false,
        analysisStep: AnalysisStep.idle,
        error: e is PlantIdException
            ? e.message
            : 'Failed to analyze image. Please try again.',
      );
    } finally {
      _isAnalysisRunning = false;
    }
  }

  /// Retry analysis with the existing image (no need to re-pick)
  Future<void> retryAnalysis() async {
    if (state.imageBytes == null) return;
    state = state.copyWith(clearError: true, clearResult: true);
    await analyzeImage();
  }

  /// Find plant in local database by scientific name (exact match only)
  Future<Plant?> _findPlantByScientificName(String scientificName) async {
    final plants = await _plantsRepository.getPlants();
    final lowerScientific = scientificName.toLowerCase().trim();

    for (final plant in plants) {
      final dbName = plant.scientificName.toLowerCase().trim();

      // Exact match
      if (dbName == lowerScientific) {
        return plant;
      }

      // Genus-level match: compare first word (genus) if species doesn't match
      final queryGenus = lowerScientific.split(' ').first;
      final dbGenus = dbName.split(' ').first;
      if (queryGenus.length > 3 && queryGenus == dbGenus) {
        return plant;
      }
    }
    return null;
  }

  /// Reset scanner to initial state
  void reset() {
    _isAnalysisRunning = false;
    state = ScanState(scanHistory: state.scanHistory);
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
