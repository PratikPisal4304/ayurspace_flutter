import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// State for the Scanner
class ScanState {
  final bool isAnalyzing;
  final String? scanResult;
  final XFile? selectedImage;
  final bool useCloudRecognition;
  final String? error;

  const ScanState({
    this.isAnalyzing = false,
    this.scanResult,
    this.selectedImage,
    this.useCloudRecognition = true,
    this.error,
  });

  ScanState copyWith({
    bool? isAnalyzing,
    String? scanResult,
    XFile? selectedImage,
    bool? useCloudRecognition,
    String? error,
    bool clearImage = false,
    bool clearResult = false,
  }) {
    return ScanState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      scanResult: clearResult ? null : (scanResult ?? this.scanResult),
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      useCloudRecognition: useCloudRecognition ?? this.useCloudRecognition,
      error: error,
    );
  }
}

/// Notifier for Scanner
class ScanNotifier extends StateNotifier<ScanState> {
  final ImagePicker _picker = ImagePicker();

  ScanNotifier() : super(const ScanState());

  /// Toggle Cloud/Local
  void toggleCloudRecognition(bool value) {
    state = state.copyWith(useCloudRecognition: value);
  }

  /// Pick image from source
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        state = state.copyWith(
          selectedImage: image,
          clearResult: true,
          error: null,
        );
        analyzeImage();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  /// Analyze the selected image
  Future<void> analyzeImage() async {
    if (state.selectedImage == null) return;

    state = state.copyWith(isAnalyzing: true);

    // Communicate with Service here. For now, mocking logic.
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      isAnalyzing: false,
      scanResult: 'Tulsi (Holy Basil)', // Mock result
    );
  }

  /// Reset scanner
  void reset() {
    state = state.copyWith(
      clearImage: true,
      clearResult: true,
      error: null,
    );
  }
}

/// Scan Provider
final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  return ScanNotifier();
});
