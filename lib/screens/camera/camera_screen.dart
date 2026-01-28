import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../l10n/app_localizations.dart';
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
                        AppLocalizations.of(context)!.scannerTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: DesignTokens.spacingXxs),
                      Text(
                        AppLocalizations.of(context)!.scannerSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
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
                        ? _buildResultState(context, ref, scanState)
                        : scanState.error != null
                            ? _buildErrorState(context, notifier, scanState)
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
                      onPressed: scanState.isAnalyzing 
                          ? null 
                          : () => notifier.pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: Text(AppLocalizations.of(context)!.gallery),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: scanState.isAnalyzing 
                          ? null 
                          : () => notifier.pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: Text(AppLocalizations.of(context)!.takePhoto),
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
            AppLocalizations.of(context)!.pointToIdentify,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            AppLocalizations.of(context)!.clearPhotoHint,
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
            state.analysisStatus.isNotEmpty 
                ? state.analysisStatus 
                : AppLocalizations.of(context)!.analyzing,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            AppLocalizations.of(context)!.aiPowered,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ScanNotifier notifier, ScanState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              AppLocalizations.of(context)!.identificationFailed,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            Text(
              state.error ?? AppLocalizations.of(context)!.errorGeneric,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            OutlinedButton.icon(
              onPressed: notifier.reset,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(BuildContext context, WidgetRef ref, ScanState state) {
    final result = state.scanResult!;
    final isLocalMatch = result.source == 'local';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        children: [
          // Success indicator
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 48,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          
          // Confidence badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingSm,
              vertical: DesignTokens.spacingXxs,
            ),
            decoration: BoxDecoration(
              color: _getConfidenceColor(result.confidence).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              AppLocalizations.of(context)!.confidenceMatch(
                (result.confidence * 100).toInt()
              ),
              style: TextStyle(
                color: _getConfidenceColor(result.confidence),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          
          // Plant name
          Text(
            result.plantName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          
          // Scientific name
          Text(
            result.scientificName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          
          // Source badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingSm,
              vertical: DesignTokens.spacingXxs,
            ),
            decoration: BoxDecoration(
              color: isLocalMatch 
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.saffron.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLocalMatch ? Icons.local_florist : Icons.auto_awesome,
                  size: 14,
                  color: isLocalMatch ? AppColors.primary : AppColors.saffron,
                ),
                const SizedBox(width: 4),
                Text(
                  isLocalMatch 
                    ? AppLocalizations.of(context)!.ayurvedicDatabase 
                    : AppLocalizations.of(context)!.aiGeneratedInfo,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isLocalMatch ? AppColors.primary : AppColors.saffron,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Ayurvedic info preview (for AI-generated results)
          if (!isLocalMatch && result.ayurvedicInfo != null) ...[
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.spa, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.ayurvedicInfo,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    result.ayurvedicInfo!.length > 300
                        ? '${result.ayurvedicInfo!.substring(0, 300)}...'
                        : result.ayurvedicInfo!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: ref.read(scanProvider.notifier).reset,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.scanAgain),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              if (isLocalMatch && result.matchedPlant != null)
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/plant/${result.matchedPlant!.id}');
                  },
                  icon: const Icon(Icons.visibility),
                  label: Text(AppLocalizations.of(context)!.viewDetails),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    // Show full AI-generated info in a dialog or new screen
                    _showFullInfoDialog(context, result);
                  },
                  icon: const Icon(Icons.info_outline),
                  label: Text(AppLocalizations.of(context)!.fullInfo),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFullInfoDialog(BuildContext context, PlantScanResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.spa, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                result.plantName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.scientificName,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result.ayurvedicInfo ?? result.description ?? 'No additional information available.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.aiDisclaimer,
                        style: const TextStyle(fontSize: 12, color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppColors.success;
    if (confidence >= 0.5) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildRecentScans(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.recentScans,
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
