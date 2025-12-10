import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/sources/remedies_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use first 3 remedies as mock favorites
    final favoriteRemedies = remediesData.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorite Remedies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: favoriteRemedies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    'Add remedies to favorites to save them here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              itemCount: favoriteRemedies.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: DesignTokens.spacingSm),
              itemBuilder: (context, index) {
                final remedy = favoriteRemedies[index];
                return InkWell(
                  onTap: () => context.push('/remedy/${remedy.id}'),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusMd),
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
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.lotusPink.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.lotusPink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                remedy.title,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                remedy.titleHindi,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textTertiary),
                              ),
                              const SizedBox(height: DesignTokens.spacingXxs),
                              Text(
                                remedy.description,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
