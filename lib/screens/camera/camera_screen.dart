import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isAnalyzing = false;
  bool _useCloudRecognition = true;
  String? _scanResult;

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _scanResult = null;
      });
      _analyzeImage();
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _scanResult = null;
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isAnalyzing = true);

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock result - in real app, this would call plant identification API
    setState(() {
      _isAnalyzing = false;
      _scanResult = 'Tulsi (Holy Basil)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plant Scanner',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: DesignTokens.spacingXxs),
                      Text(
                        'Identify any Ayurvedic plant',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  // Cloud/Local toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSm,
                      vertical: DesignTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _useCloudRecognition ? Icons.cloud : Icons.smartphone,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _useCloudRecognition ? 'Cloud' : 'Local',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Switch(
                          value: _useCloudRecognition,
                          onChanged: (value) {
                            setState(() => _useCloudRecognition = value);
                          },
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Camera/Image preview area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  border: Border.all(
                    color: AppColors.border,
                    width: 2,
                  ),
                ),
                child: _isAnalyzing
                    ? _buildAnalyzingState()
                    : _scanResult != null
                        ? _buildResultState()
                        : _buildEmptyState(),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recent scans
            _buildRecentScans(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Point at a plant to identify',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            'Take a clear photo of leaves or the whole plant',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Analyzing plant...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            _useCloudRecognition ? 'Using cloud AI' : 'Using local recognition',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildResultState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Plant Identified!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            _scanResult ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _scanResult = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Scan Again'),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to plant detail
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScans() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Scans',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: DesignTokens.spacingXs),
              itemBuilder: (context, index) {
                return Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_florist,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
