import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/plants_provider.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;
  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantByIdProvider(plantId));
    if (plant == null) {
      return Scaffold(body: Center(child: Text('Plant not found')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: plant.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.surfaceVariant),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.local_florist, size: 64, color: AppColors.textTertiary),
                ),
              ),
            ),
            actions: [
              IconButton(icon: Icon(plant.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => ref.read(plantsProvider.notifier).toggleBookmark(plantId)),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(plant.name, style: Theme.of(context).textTheme.headlineMedium)),
                      Row(children: [
                        const Icon(Icons.star, color: AppColors.turmeric, size: 20),
                        Text(' ${plant.rating}', style: Theme.of(context).textTheme.titleMedium),
                      ]),
                    ],
                  ),
                  Text(plant.hindi, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                  Text(plant.scientificName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(height: DesignTokens.spacingSm),
                  
                  // Badges
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _Badge(text: plant.difficulty, color: AppColors.getDifficultyColor(plant.difficulty)),
                    _Badge(text: plant.category, color: AppColors.primary),
                    ...plant.doshas.map((d) => _Badge(text: d, color: AppColors.getDoshaColor(d))),
                  ]),
                  const SizedBox(height: DesignTokens.spacingLg),

                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(plant.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: DesignTokens.spacingLg),

                  Text('Health Benefits', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Wrap(spacing: 8, runSpacing: 8, children: plant.benefits.map((b) => Chip(label: Text(b))).toList()),
                  const SizedBox(height: DesignTokens.spacingLg),

                  Text('Uses', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DesignTokens.spacingXs),
                  ...plant.uses.map((u) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(u)),
                    ]),
                  )),
                  const SizedBox(height: DesignTokens.spacingLg),

                  _InfoCard(title: 'Dosage', content: plant.dosage, icon: Icons.medical_services),
                  const SizedBox(height: DesignTokens.spacingSm),
                  _InfoCard(title: 'Precautions', content: plant.precautions, icon: Icons.warning, color: AppColors.warning),
                  const SizedBox(height: DesignTokens.spacingSm),
                  _InfoCard(title: 'Growing Tips', content: plant.growingTips, icon: Icons.eco),
                  const SizedBox(height: DesignTokens.spacingSm),
                  _InfoCard(title: 'Harvest Time', content: plant.harvestTime, icon: Icons.schedule),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  const _InfoCard({required this.title, required this.content, required this.icon, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ])),
      ]),
    );
  }
}
