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
                margin: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  border: Border.all(
                    color: AppColors.border,
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedSwitcher(
                  duration: DesignTokens.animationNormal,
                  child: scanState.isAnalyzing
                      ? _buildAnalyzingState(context, scanState)
                      : scanState.scanResult != null
                          ? _buildResultState(context, ref, scanState)
                          : scanState.error != null
                              ? _buildErrorState(context, notifier, scanState)
                              : _buildEmptyState(context),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingSm),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
              ),
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

            // Recent scans
            _buildRecentScans(context, ref, scanState),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
            child: Text(
              AppLocalizations.of(context)!.clearPhotoHint,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingState(BuildContext context, ScanState state) {
    return Stack(
      key: const ValueKey('analyzing'),
      fit: StackFit.expand,
      children: [
        // Show captured image as background
        if (state.imageBytes != null)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppColors.background.withValues(alpha: 0.7),
              BlendMode.srcATop,
            ),
            child: Image.memory(
              state.imageBytes!,
              fit: BoxFit.cover,
            ),
          ),

        // Analysis overlay
        Center(
          child: Container(
            margin: const EdgeInsets.all(DesignTokens.spacingLg),
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              boxShadow: [
                const BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: DesignTokens.shadowBlurLg,
                  offset: Offset(0, DesignTokens.shadowOffsetY),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                // Step indicators
                _buildStepIndicator(
                  context,
                  icon: Icons.search,
                  label: 'Identifying plant...',
                  isActive: state.analysisStep == AnalysisStep.identifying,
                  isDone: state.analysisStep.index >
                      AnalysisStep.identifying.index,
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                _buildStepIndicator(
                  context,
                  icon: Icons.menu_book,
                  label: 'Searching Ayurvedic database...',
                  isActive:
                      state.analysisStep == AnalysisStep.searchingDatabase,
                  isDone: state.analysisStep.index >
                      AnalysisStep.searchingDatabase.index,
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                _buildStepIndicator(
                  context,
                  icon: Icons.spa,
                  label: 'Getting Ayurvedic insights...',
                  isActive:
                      state.analysisStep == AnalysisStep.gettingAyurvedic,
                  isDone: state.analysisStep.index >
                      AnalysisStep.gettingAyurvedic.index,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    final color = isDone
        ? AppColors.success
        : isActive
            ? AppColors.primary
            : AppColors.textTertiary;

    return Row(
      children: [
        if (isDone)
          const Icon(Icons.check_circle, size: 20, color: AppColors.success)
        else if (isActive)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          )
        else
          Icon(icon, size: 20, color: color),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, ScanNotifier notifier, ScanState state) {
    return Stack(
      key: const ValueKey('error'),
      fit: StackFit.expand,
      children: [
        // Show captured image as dim background if we have one
        if (state.imageBytes != null)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppColors.background.withValues(alpha: 0.8),
              BlendMode.srcATop,
            ),
            child: Image.memory(state.imageBytes!, fit: BoxFit.cover),
          ),
        Center(
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
                    size: 48,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Text(
                  AppLocalizations.of(context)!.identificationFailed,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd,
                  ),
                  child: Text(
                    state.error ??
                        AppLocalizations.of(context)!.errorGeneric,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Retry with same image
                    if (state.imageBytes != null)
                      OutlinedButton.icon(
                        onPressed: () => notifier.retryAnalysis(),
                        icon: const Icon(Icons.refresh),
                        label: Text(AppLocalizations.of(context)!.tryAgain),
                      ),
                    if (state.imageBytes != null)
                      const SizedBox(width: DesignTokens.spacingSm),
                    // Take a new photo
                    TextButton.icon(
                      onPressed: notifier.reset,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('New Photo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultState(
      BuildContext context, WidgetRef ref, ScanState state) {
    final result = state.scanResult!;
    final isLocalMatch = result.source == ScanSource.local;

    return Stack(
      key: const ValueKey('result'),
      fit: StackFit.expand,
      children: [
        // Captured image as background
        if (result.capturedImageBytes != null)
          Image.memory(
            result.capturedImageBytes!,
            fit: BoxFit.cover,
          ),

        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.5),
                  AppColors.background.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.35, 0.65],
              ),
            ),
          ),
        ),

        // Result content
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Confidence + Health badges row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(
                      icon: Icons.verified,
                      label:
                          '${(result.confidence * 100).toInt()}% match',
                      color: _getConfidenceColor(result.confidence),
                    ),
                    const SizedBox(width: DesignTokens.spacingXs),
                    _buildBadge(
                      icon: result.isHealthy
                          ? Icons.favorite
                          : Icons.healing,
                      label: result.isHealthy
                          ? 'Healthy'
                          : 'Issues detected',
                      color: result.isHealthy
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingSm),

                // Plant name
                Text(
                  result.plantName,
                  style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                  textAlign: TextAlign.center,
                ),

                // Scientific name
                Text(
                  result.scientificName,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),

                // Source badge
                _buildBadge(
                  icon: isLocalMatch
                      ? Icons.local_florist
                      : Icons.auto_awesome,
                  label: isLocalMatch
                      ? AppLocalizations.of(context)!.ayurvedicDatabase
                      : AppLocalizations.of(context)!.aiGeneratedInfo,
                  color:
                      isLocalMatch ? AppColors.primary : AppColors.saffron,
                ),

                const SizedBox(height: DesignTokens.spacingMd),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            ref.read(scanProvider.notifier).reset,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(
                            AppLocalizations.of(context)!.scanAgain),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          backgroundColor:
                              AppColors.surface.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isLocalMatch &&
                              result.matchedPlant != null) {
                            context.push(
                                '/plant/${result.matchedPlant!.id}');
                          } else {
                            context.push('/scan-result');
                          }
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: Text(
                            AppLocalizations.of(context)!.viewDetails),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
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

  Widget _buildRecentScans(
      BuildContext context, WidgetRef ref, ScanState scanState) {
    final history = scanState.scanHistory;

    if (history.isEmpty) {
      return const SizedBox(height: DesignTokens.spacingMd);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        DesignTokens.spacingSm,
        DesignTokens.spacingMd,
        DesignTokens.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.recentScans,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: history.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: DesignTokens.spacingXs),
              itemBuilder: (context, index) {
                final item = history[index];
                return GestureDetector(
                  onTap: () {
                    // Set this as the current result and navigate
                    // For now just show a tooltip
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                              DesignTokens.radiusSm),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: item.capturedImageBytes != null
                            ? Image.memory(
                                item.capturedImageBytes!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Icon(
                                  Icons.local_florist,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 56,
                        child: Text(
                          item.plantName,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
