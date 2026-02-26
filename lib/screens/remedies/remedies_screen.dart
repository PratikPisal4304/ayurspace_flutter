import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/remedy.dart';
import '../../providers/remedies_provider.dart';

class RemediesScreen extends ConsumerStatefulWidget {
  const RemediesScreen({super.key});

  @override
  ConsumerState<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends ConsumerState<RemediesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remediesState = ref.watch(remediesProvider);
    final remediesNotifier = ref.read(remediesProvider.notifier);
    final categories = ref.watch(remedyCategoriesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.navRemedies,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingXxs),
                  Text(
                    l10n.remediesSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),

                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: remediesNotifier.searchRemedies,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: remediesState.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                remediesNotifier.searchRemedies('');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd),
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: DesignTokens.spacingXs),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == 'All'
                      ? remediesState.selectedCategory == null
                      : remediesState.selectedCategory == category;

                  return GestureDetector(
                    onTap: () => remediesNotifier.filterByCategory(category),
                    child: AnimatedContainer(
                      duration: DesignTokens.animationFast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingMd,
                        vertical: DesignTokens.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusFull),
                      ),
                      child: Text(
                        category, // Categories might need mapping if static list
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Results info
            if (remediesState.hasFilters)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.remediesFound(remediesState.filteredRemedies.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        remediesNotifier.clearFilters();
                      },
                      child: Text(l10n.clearFilters),
                    ),
                  ],
                ),
              ),

            // Remedies list
            Expanded(
              child: _buildRemediesList(context, remediesState, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemediesList(
      BuildContext context, RemediesState state, AppLocalizations l10n) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.errorGeneric,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            TextButton(
              onPressed: () =>
                  ref.read(remediesProvider.notifier).loadRemedies(),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    if (state.filteredRemedies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: AppColors.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.noRemediesFound,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: state.filteredRemedies.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: DesignTokens.spacingSm),
      itemBuilder: (context, index) {
        final remedy = state.filteredRemedies[index];
        return InkWell(
          onTap: () => context.push('/remedy/${remedy.id}'),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: _RemedyCard(
            remedy: remedy,
            icon: getIconForCategory(remedy.category),
          ),
        );
      },
    );
  }
}

class _RemedyCard extends StatelessWidget {
  final Remedy remedy;
  final IconData icon;

  const _RemedyCard({required this.remedy, required this.icon});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isHindi = locale == 'hi';
    final primaryTitle = isHindi ? remedy.titleHindi : remedy.title;
    final secondaryTitle = isHindi ? remedy.title : remedy.titleHindi;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: DesignTokens.shadowBlurMd,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        primaryTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _DifficultyBadge(difficulty: remedy.difficulty),
                  ],
                ),
                Text(
                  secondaryTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  remedy.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      remedy.duration,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusFull),
                      ),
                      child: Text(
                        remedy.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDifficultyColor(difficulty);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
