import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/scan_provider.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  const ScanResultScreen({super.key});

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);
    final result = scanState.scanResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Result')),
        body: const Center(child: Text('No scan result available.')),
      );
    }

    final isLocalMatch = result.source == ScanSource.local;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Hero image section
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (result.capturedImageBytes != null)
                      Image.memory(
                        result.capturedImageBytes!,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(color: AppColors.primaryDark),
                    // Gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                    // Plant info overlay
                    Positioned(
                      left: DesignTokens.spacingMd,
                      right: DesignTokens.spacingMd,
                      bottom: DesignTokens.spacingMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges row
                          Wrap(
                            spacing: DesignTokens.spacingXs,
                            runSpacing: DesignTokens.spacingXxs,
                            children: [
                              _buildChip(
                                '${(result.confidence * 100).toInt()}% match',
                                _getConfidenceColor(result.confidence),
                              ),
                              _buildChip(
                                result.isHealthy
                                    ? '🟢 Healthy'
                                    : '🟡 Issues',
                                result.isHealthy
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                              _buildChip(
                                isLocalMatch
                                    ? '📚 Ayurvedic DB'
                                    : '✨ AI Generated',
                                isLocalMatch
                                    ? AppColors.primary
                                    : AppColors.saffron,
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacingSm),
                          Text(
                            result.plantName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            result.scientificName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textTertiary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 13),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Ayurvedic'),
                    Tab(text: 'Health'),
                    Tab(text: 'Care'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context, result),
            _buildAyurvedicTab(context, result),
            _buildHealthTab(context, result),
            _buildCareTab(context, result),
          ],
        ),
      ),

      // Bottom action bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(scanProvider.notifier).reset();
                    context.pop();
                  },
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: Text(AppLocalizations.of(context)!.scanAgain),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              if (isLocalMatch && result.matchedPlant != null)
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/plant/${result.matchedPlant!.id}'),
                    icon: const Icon(Icons.local_florist, size: 18),
                    label: const Text('Full Plant Profile'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ OVERVIEW TAB ============
  Widget _buildOverviewTab(BuildContext context, PlantScanResult result) {
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Description
        if (result.description != null) ...[
          _buildSectionCard(
            context,
            icon: Icons.info_outline,
            title: 'Description',
            child: Text(
              result.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Common names
        if (result.commonNames.isNotEmpty) ...[
          _buildSectionCard(
            context,
            icon: Icons.label_outline,
            title: 'Common Names',
            child: Wrap(
              spacing: DesignTokens.spacingXs,
              runSpacing: DesignTokens.spacingXs,
              children: result.commonNames
                  .map((name) => Chip(
                        label: Text(name, style: const TextStyle(fontSize: 13)),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.08),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Edible parts
        if (result.edibleParts != null && result.edibleParts!.isNotEmpty) ...[
          _buildSectionCard(
            context,
            icon: Icons.restaurant,
            title: 'Edible Parts',
            child: Wrap(
              spacing: DesignTokens.spacingXs,
              runSpacing: DesignTokens.spacingXs,
              children: result.edibleParts!
                  .map((part) => Chip(
                        avatar: const Icon(Icons.eco, size: 16),
                        label: Text(part, style: const TextStyle(fontSize: 13)),
                        backgroundColor:
                            AppColors.success.withValues(alpha: 0.08),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Similar images
        if (result.similarImages.isNotEmpty) ...[
          _buildSectionCard(
            context,
            icon: Icons.collections,
            title: 'Similar Images',
            child: SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: result.similarImages.length.clamp(0, 5),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: DesignTokens.spacingSm),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusSm),
                    child: Image.network(
                      result.similarImages[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.broken_image_outlined,
                            color: AppColors.textTertiary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ============ AYURVEDIC TAB ============
  Widget _buildAyurvedicTab(BuildContext context, PlantScanResult result) {
    // If we have a local match, show the plant's Ayurvedic data
    if (result.matchedPlant != null) {
      final plant = result.matchedPlant!;
      return ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        children: [
          // Dosha effects
          if (plant.doshas.isNotEmpty) ...[
            _buildSectionCard(
              context,
              icon: Icons.spa,
              title: 'Dosha Effects',
              child: Wrap(
                spacing: DesignTokens.spacingSm,
                runSpacing: DesignTokens.spacingXs,
                children: plant.doshas
                    .map((dosha) => _buildDoshaChip(dosha))
                    .toList(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Rasa (Taste)
          if (plant.taste != null && plant.taste!.isNotEmpty) ...[
            _buildSectionCard(
              context,
              icon: Icons.restaurant_menu,
              title: 'Rasa (Taste)',
              child: Wrap(
                spacing: DesignTokens.spacingXs,
                children: plant.taste!
                    .map((t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 13)),
                          backgroundColor:
                              AppColors.turmeric.withValues(alpha: 0.1),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Virya & Vipaka
          if (plant.virya != null || plant.vipaka != null) ...[
            _buildSectionCard(
              context,
              icon: Icons.thermostat,
              title: 'Dravyaguna Properties',
              child: Column(
                children: [
                  if (plant.virya != null)
                    _buildPropertyRow('Virya (Potency)', plant.virya!),
                  if (plant.vipaka != null)
                    _buildPropertyRow(
                        'Vipaka (Post-digestive)', plant.vipaka!),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Uses
          if (plant.uses.isNotEmpty) ...[
            _buildSectionCard(
              context,
              icon: Icons.medical_services_outlined,
              title: 'Ayurvedic Uses',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plant.uses
                    .map((use) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: DesignTokens.spacingXs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('🌿 ', style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Text(
                                  use,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Benefits
          if (plant.benefits.isNotEmpty) ...[
            _buildSectionCard(
              context,
              icon: Icons.favorite_outline,
              title: 'Health Benefits',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plant.benefits
                    .map((b) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: DesignTokens.spacingXs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('✨ ', style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Text(b,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Dosage
          if (plant.dosage.isNotEmpty) ...[
            _buildSectionCard(
              context,
              icon: Icons.scale,
              title: 'Dosage',
              child: Text(plant.dosage,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ],
      );
    }

    // AI-generated info
    if (result.ayurvedicInfo != null) {
      return ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        children: [
          _buildSectionCard(
            context,
            icon: Icons.spa,
            title: 'Ayurvedic Information',
            child: Text(
              result.ayurvedicInfo!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // AI disclaimer
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: AppColors.warning),
                const SizedBox(width: DesignTokens.spacingXs),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.aiDisclaimer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Text(
          'No Ayurvedic information available for this plant.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ============ HEALTH TAB ============
  Widget _buildHealthTab(BuildContext context, PlantScanResult result) {
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Health status card
        _buildSectionCard(
          context,
          icon: result.isHealthy ? Icons.check_circle : Icons.warning,
          title: 'Health Status',
          iconColor: result.isHealthy ? AppColors.success : AppColors.warning,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: (result.isHealthy
                          ? AppColors.success
                          : AppColors.warning)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.isHealthy ? Icons.favorite : Icons.healing,
                  color:
                      result.isHealthy ? AppColors.success : AppColors.warning,
                  size: 32,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.isHealthy
                          ? 'Plant looks healthy!'
                          : 'Issues detected',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    if (!result.isHealthy)
                      Text(
                        '${result.healthIssues.length} issue(s) found',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Health issues list
        if (result.healthIssues.isNotEmpty)
          ...result.healthIssues.map((issue) => Padding(
                padding:
                    const EdgeInsets.only(bottom: DesignTokens.spacingSm),
                child: _buildSectionCard(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: issue.name,
                  iconColor: AppColors.error,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Probability bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: issue.probability,
                                backgroundColor:
                                    AppColors.error.withValues(alpha: 0.1),
                                color: AppColors.error,
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacingSm),
                          Text(
                            '${(issue.probability * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                          ),
                        ],
                      ),
                      if (issue.description != null) ...[
                        const SizedBox(height: DesignTokens.spacingSm),
                        Text(issue.description!,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                      if (issue.treatment != null) ...[
                        const SizedBox(height: DesignTokens.spacingSm),
                        Container(
                          padding:
                              const EdgeInsets.all(DesignTokens.spacingSm),
                          decoration: BoxDecoration(
                            color:
                                AppColors.success.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(
                                DesignTokens.radiusSm),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.healing,
                                  size: 16, color: AppColors.success),
                              const SizedBox(width: DesignTokens.spacingXs),
                              Expanded(
                                child: Text(
                                  issue.treatment!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.success),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )),

        // Precautions from local match
        if (result.matchedPlant != null &&
            result.matchedPlant!.precautions.isNotEmpty) ...[
          _buildSectionCard(
            context,
            icon: Icons.warning_amber,
            title: 'Precautions',
            iconColor: AppColors.warning,
            child: Text(
              result.matchedPlant!.precautions,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ],
    );
  }

  // ============ CARE TAB ============
  Widget _buildCareTab(BuildContext context, PlantScanResult result) {
    final hasWatering = result.watering != null && result.watering!.isNotEmpty;
    final hasPropagation =
        result.propagationMethods != null &&
        result.propagationMethods!.isNotEmpty;
    final hasGrowingTips = result.matchedPlant?.growingTips.isNotEmpty ?? false;
    final hasHarvestTime =
        result.matchedPlant?.harvestTime.isNotEmpty ?? false;

    if (!hasWatering && !hasPropagation && !hasGrowingTips && !hasHarvestTime) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop_outlined,
                  size: 48, color: AppColors.textTertiary),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                'No care information available yet.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Watering
        if (hasWatering) ...[
          _buildSectionCard(
            context,
            icon: Icons.water_drop,
            title: 'Watering',
            iconColor: AppColors.info,
            child: Text(
              result.watering.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Propagation
        if (hasPropagation) ...[
          _buildSectionCard(
            context,
            icon: Icons.spa_outlined,
            title: 'Propagation Methods',
            child: Wrap(
              spacing: DesignTokens.spacingXs,
              runSpacing: DesignTokens.spacingXs,
              children: result.propagationMethods!
                  .map((method) => Chip(
                        avatar: const Icon(Icons.eco, size: 16),
                        label: Text(method,
                            style: const TextStyle(fontSize: 13)),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.08),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Growing tips from local match
        if (hasGrowingTips) ...[
          _buildSectionCard(
            context,
            icon: Icons.tips_and_updates,
            title: 'Growing Tips',
            child: Text(
              result.matchedPlant!.growingTips,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Harvest time
        if (hasHarvestTime)
          _buildSectionCard(
            context,
            icon: Icons.calendar_today,
            title: 'Harvest Time',
            child: Text(
              result.matchedPlant!.harvestTime,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }

  // ============ HELPER WIDGETS ============

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: DesignTokens.shadowBlurSm,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
              const SizedBox(width: DesignTokens.spacingXs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          child,
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDoshaChip(String dosha) {
    final color = AppColors.getDoshaColor(dosha);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            dosha,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
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
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
