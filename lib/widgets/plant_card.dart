import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/colors.dart';
import '../config/design_tokens.dart';
import '../data/models/plant.dart';

/// Plant card widget for displaying plant info
class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;
  final bool showBookmark;

  const PlantCard({
    super.key,
    required this.plant,
    this.onTap,
    this.showBookmark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      elevation: 2,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with RepaintBoundary for performance
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DesignTokens.radiusMd),
              ),
              child: RepaintBoundary(
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: plant.image,
                    fit: BoxFit.cover,
                    memCacheWidth: 400, // Limit memory cache size
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plant.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.turmeric,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            plant.rating.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingXxs),
                  // Hindi name
                  Text(
                    plant.hindi,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  // Dosha badges
                  Wrap(
                    spacing: DesignTokens.spacingXxs,
                    children: plant.doshas
                        .take(2)
                        .map((dosha) => _DoshaBadge(dosha: dosha))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoshaBadge extends StatelessWidget {
  final String dosha;

  const _DoshaBadge({required this.dosha});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDoshaColor(dosha);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXs,
        vertical: DesignTokens.spacingXxxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        dosha,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
