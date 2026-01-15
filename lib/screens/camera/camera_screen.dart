import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/scan_provider.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanProvider);
    final notifier = ref.read(scanProvider.notifier);

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
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusFull),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          scanState.useCloudRecognition ? Icons.cloud : Icons.smartphone,
                          size: 16,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          scanState.useCloudRecognition ? 'Cloud' : 'Local',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Switch(
                          value: scanState.useCloudRecognition,
                          onChanged: notifier.toggleCloudRecognition,
                          activeThumbColor: AppColors.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                child: scanState.isAnalyzing
                    ? _buildAnalyzingState(context, scanState)
                    : scanState.scanResult != null
                        ? _buildResultState(context, notifier, scanState)
                        : _buildEmptyState(context),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => notifier.pickImage(ImageSource.gallery),
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
                      onPressed: () => notifier.pickImage(ImageSource.camera),
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

            // Recent scans (Mock)
            _buildRecentScans(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
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

  Widget _buildAnalyzingState(BuildContext context, ScanState state) {
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
            state.useCloudRecognition ? 'Using cloud AI' : 'Using local recognition',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(BuildContext context, ScanNotifier notifier, ScanState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
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
            state.scanResult ?? '',
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
                onPressed: notifier.reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Scan Again'),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Tulsi (plant ID 1) as mock result
                  context.push('/plant/1');
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

  Widget _buildRecentScans(BuildContext context) {
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
