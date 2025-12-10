import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/remedy.dart';
import '../../data/sources/remedies_data.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  List<Remedy> get _filteredRemedies {
    List<Remedy> filtered;

    // Filter by category
    if (_selectedCategory == 'All') {
      filtered = remediesData;
    } else {
      filtered =
          remediesData.where((r) => r.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((r) {
        return r.title.toLowerCase().contains(query) ||
            r.description.toLowerCase().contains(query) ||
            r.healthGoals.any((goal) => goal.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getIconForhealthGoal(String category) {
    switch (category.toLowerCase()) {
      case 'immunity':
        return Icons.verified_user_outlined;
      case 'digestion':
        return Icons.water_drop_outlined;
      case 'stress':
        return Icons.nightlight_outlined;
      case 'skin':
        return Icons.face_outlined;
      case 'respiratory':
        return Icons.air;
      case 'sleep':
        return Icons.bed_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get unique categories from data plus 'All'
    final categories = ['All', ...getRemedyCategories()];

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
                    'Remedies',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingXxs),
                  Text(
                    'Traditional Ayurvedic solutions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),

                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search remedies...',
                      prefixIcon: Icon(Icons.search),
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
                  final cat = categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
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
                        cat,
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

            // Remedies list
            Expanded(
              child: _filteredRemedies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 64,
                            color:
                                AppColors.textTertiary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          Text(
                            'No remedies found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(DesignTokens.spacingMd),
                      itemCount: _filteredRemedies.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: DesignTokens.spacingSm),
                      itemBuilder: (context, index) {
                        final remedy = _filteredRemedies[index];
                        return InkWell(
                          onTap: () => context.push('/remedy/${remedy.id}'),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusMd),
                          child: _RemedyCard(
                            remedy: remedy,
                            icon: _getIconForhealthGoal(remedy.category),
                          ),
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

class _RemedyCard extends StatelessWidget {
  final Remedy remedy;
  final IconData icon;

  const _RemedyCard({required this.remedy, required this.icon});

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      remedy.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    _DifficultyBadge(difficulty: remedy.difficulty),
                  ],
                ),
                Text(
                  remedy.titleHindi,
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
