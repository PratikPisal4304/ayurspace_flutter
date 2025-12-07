import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/plants_provider.dart';
import '../../widgets/plant_card.dart';
import '../../data/sources/plants_data.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantsState = ref.watch(plantsProvider);
    final plantsNotifier = ref.read(plantsProvider.notifier);

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
                    'Discover Plants',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    'Explore ${plantsState.plants.length}+ Ayurvedic herbs',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),

                  // Search bar
                  TextField(
                    controller: _searchController,
                    onChanged: plantsNotifier.searchPlants,
                    decoration: InputDecoration(
                      hintText: 'Search plants, benefits...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: plantsState.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                plantsNotifier.searchPlants('');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Filters
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: plantsState.selectedDosha == null,
                      onTap: () => plantsNotifier.filterByDosha(null),
                    ),
                    const SizedBox(width: DesignTokens.spacingXs),
                    ...getAllDoshas().map((dosha) => Padding(
                          padding: const EdgeInsets.only(
                              right: DesignTokens.spacingXs),
                          child: _FilterChip(
                            label: dosha,
                            isSelected: plantsState.selectedDosha == dosha,
                            color: AppColors.getDoshaColor(dosha),
                            onTap: () => plantsNotifier.filterByDosha(dosha),
                          ),
                        )),
                    ...getDifficultyLevels().map((diff) => Padding(
                          padding: const EdgeInsets.only(
                              right: DesignTokens.spacingXs),
                          child: _FilterChip(
                            label: diff,
                            isSelected: plantsState.selectedDifficulty == diff,
                            color: AppColors.getDifficultyColor(diff),
                            onTap: () => plantsNotifier.filterByDifficulty(diff),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Results count
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${plantsState.filteredPlants.length} plants found',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (plantsState.selectedDosha != null ||
                      plantsState.selectedDifficulty != null ||
                      plantsState.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        plantsNotifier.clearFilters();
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            ),

            // Plants grid
            Expanded(
              child: plantsState.filteredPlants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textTertiary.withOpacity(0.5),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          Text(
                            'No plants found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            'Try adjusting your filters',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(DesignTokens.spacingMd),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: DesignTokens.spacingSm,
                        mainAxisSpacing: DesignTokens.spacingSm,
                      ),
                      itemCount: plantsState.filteredPlants.length,
                      itemBuilder: (context, index) {
                        final plant = plantsState.filteredPlants[index];
                        return PlantCard(
                          plant: plant,
                          onTap: () => context.push('/plant/${plant.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignTokens.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm,
          vertical: DesignTokens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : chipColor,
          ),
        ),
      ),
    );
  }
}
