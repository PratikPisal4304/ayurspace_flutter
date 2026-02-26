import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/plants_provider.dart';
import '../../data/models/plant.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/cors_image_helper.dart';

part 'plant_detail_tabs.dart';

class PlantDetailScreen extends ConsumerStatefulWidget {
  final String plantId;
  const PlantDetailScreen({super.key, required this.plantId});

  @override
  ConsumerState<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends ConsumerState<PlantDetailScreen>
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
    final plant = ref.watch(plantByIdProvider(widget.plantId));
    if (plant == null) {
      return const Scaffold(body: Center(child: Text('Plant not found')));
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildHeroSection(context, plant),
          _buildQuickStats(context, plant),
          _buildTabBar(context),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(plant: plant),
            _UsesTab(plant: plant),
            _GrowingTab(plant: plant),
            _AyurvedaTab(plant: plant),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context, plant),
    );
  }

  Widget _buildHeroSection(BuildContext context, Plant plant) {
    final l10n = AppLocalizations.of(context)!;
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          plant.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        expandedTitleScale: 1.5,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero Image
            CachedNetworkImage(
              imageUrl: CorsImageHelper.getImageUrl(plant.image),
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppColors.surfaceVariant),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.local_florist,
                    size: 64, color: AppColors.textTertiary),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),
            // Plant info overlay (Bottom Left)
            Positioned(
              left: DesignTokens.spacingMd,
              right: DesignTokens.spacingMd,
              bottom: DesignTokens.spacingXl +
                  20, // Move up to avoid collision with title
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${plant.hindi} • ${plant.scientificName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  if (plant.sanskritName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.nameSanskrit}: ${plant.sanskritName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                  const SizedBox(height: DesignTokens.spacingSm),
                  // Rating chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            color: AppColors.turmeric, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${plant.rating}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          tooltip: plant.isBookmarked ? l10n.actionSaved : l10n.actionSave,
          icon: Icon(
            plant.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
          ),
          onPressed: () =>
              ref.read(plantsProvider.notifier).toggleBookmark(widget.plantId),
        ),
        IconButton(
          tooltip: l10n.actionShare,
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, Plant plant) {
    // Note: QuickStats labels come from model (difficulty) which might be English only
    // Ideally these values (Easy, Medium) should be mapped to l10n too.
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Row(
          children: [
            _QuickStatItem(
              icon: Icons.speed,
              label: plant.difficulty,
              color: AppColors.getDifficultyColor(plant.difficulty),
            ),
            _QuickStatItem(
              icon: Icons.category,
              label: plant.category,
              color: AppColors.primary,
            ),
            _QuickStatItem(
              icon: Icons.wb_sunny,
              label: plant.season.first,
              color: AppColors.saffron,
            ),
            if (plant.partUsed != null)
              _QuickStatItem(
                icon: Icons.eco,
                label: plant.partUsed!,
                color: AppColors.neemGreen,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyTabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: [
            Tab(text: l10n.tabOverview),
            Tab(text: l10n.tabUses),
            Tab(text: l10n.tabGrowing),
            Tab(text: l10n.tabAyurveda),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, Plant plant) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: DesignTokens.shadowBlurMd,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ref
                    .read(plantsProvider.notifier)
                    .toggleBookmark(widget.plantId),
                icon: Icon(
                  plant.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_add_outlined,
                ),
                label: Text(
                    plant.isBookmarked ? l10n.actionSaved : l10n.actionSave),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.healing),
                label: Text(l10n.actionFindRemedies),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Stat Item Widget
class _QuickStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickStatItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Sticky Tab Bar Delegate
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
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
