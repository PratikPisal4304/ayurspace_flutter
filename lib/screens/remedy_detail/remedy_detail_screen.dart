import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/remedy.dart';
import '../../data/models/dosha.dart'; // Needed for DoshaType
import '../../providers/remedies_provider.dart';
import '../../providers/user_provider.dart';

class RemedyDetailScreen extends ConsumerWidget {
  final String remedyId;
  const RemedyDetailScreen({super.key, required this.remedyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find remedy by ID via Provider
    final remedy = ref.watch(remedyByIdProvider(remedyId));
    final userProfile = ref.watch(userProfileProvider);

    if (remedy == null) {
      return const Scaffold(
        body: Center(child: Text('Remedy not found')),
      );
    }

    final isFavorite = userProfile?.favoriteRemedyIds.contains(remedyId) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                remedy.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_cafe,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                   ref.read(userProvider.notifier).toggleFavoriteRemedy(remedy.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hindi title and badges
                  if (remedy.titleHindi.isNotEmpty)
                    Text(
                      remedy.titleHindi,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  const SizedBox(height: DesignTokens.spacingSm),

                  // Badges row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Badge(
                        text: remedy.category,
                        color: AppColors.primary,
                        icon: Icons.category,
                      ),
                      _Badge(
                        text: remedy.duration,
                        color: AppColors.saffron,
                        icon: Icons.schedule,
                      ),
                      _Badge(
                        text: remedy.difficulty,
                        color: AppColors.getDifficultyColor(remedy.difficulty),
                        icon: Icons.bar_chart,
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingLg),

                  // Description
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    remedy.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingLg),

                  // Dosha types
                  if (remedy.doshaTypes.isNotEmpty) ...[
                    Text(
                      'Suitable for',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    Wrap(
                      spacing: 8,
                      children: remedy.doshaTypes
                          .map((d) => Chip(
                                label: Text(d.displayName),
                                backgroundColor: AppColors.getDoshaColor(d.name)
                                    .withValues(alpha: 0.2),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                  ],

                  // Ingredients
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  ...remedy.ingredients.map((ingredient) => _IngredientTile(
                        ingredient: ingredient,
                      )),
                  const SizedBox(height: DesignTokens.spacingLg),

                  // Preparation steps
                  Text(
                    'How to Prepare',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  ...remedy.steps.asMap().entries.map(
                      (e) => _StepTile(stepNumber: e.key + 1, step: e.value)),
                  const SizedBox(height: DesignTokens.spacingLg),

                  // Dosage
                  if (remedy.dosage != null && remedy.dosage!.isNotEmpty)
                    _InfoCard(
                      title: 'Dosage',
                      content: remedy.dosage!,
                      icon: Icons.medical_services,
                      color: AppColors.primary,
                    ),
                  if (remedy.dosage != null)
                    const SizedBox(height: DesignTokens.spacingSm),

                  // Precautions
                  if (remedy.precautions != null &&
                      remedy.precautions!.isNotEmpty)
                    _InfoCard(
                      title: 'Precautions',
                      content: remedy.precautions!,
                      icon: Icons.warning_amber,
                      color: AppColors.warning,
                    ),
                  const SizedBox(height: DesignTokens.spacingXl),
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
  final IconData icon;

  const _Badge({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const _IngredientTile({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ingredient.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (ingredient.optional)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Optional',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                  ],
                ),
                if (ingredient.nameHindi.isNotEmpty)
                  Text(
                    ingredient.nameHindi,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
              ],
            ),
          ),
          Text(
            ingredient.quantity,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int stepNumber;
  final String step;

  const _StepTile({required this.stepNumber, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              step,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: color),
                ),
                const SizedBox(height: 4),
                Text(content, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
