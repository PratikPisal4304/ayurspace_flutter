import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/plants_provider.dart';
import '../../widgets/plant_card.dart';
import 'package:go_router/go_router.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsState = ref.watch(plantsProvider);
    // Filter for bookmarked plants (using first 3 as mock bookmarks)
    final bookmarkedPlants = plantsState.plants.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bookmarked Plants'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: bookmarkedPlants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    'No bookmarks yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    'Bookmark plants to save them here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: DesignTokens.spacingSm,
                mainAxisSpacing: DesignTokens.spacingSm,
              ),
              itemCount: bookmarkedPlants.length,
              itemBuilder: (context, index) {
                final plant = bookmarkedPlants[index];
                return PlantCard(
                  plant: plant,
                  onTap: () => context.push('/plant/${plant.id}'),
                );
              },
            ),
    );
  }
}
