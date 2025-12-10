import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Immunity',
    'Digestion',
    'Stress',
    'Skin',
    'Respiratory',
    'Sleep',
  ];

  final List<Map<String, dynamic>> _remedies = [
    {
      'id': '1',
      'title': 'Golden Milk',
      'titleHindi': 'हल्दी दूध',
      'category': 'Immunity',
      'duration': '10 mins',
      'difficulty': 'Easy',
      'description': 'Warm turmeric milk for immunity and better sleep',
      'icon': Icons.local_cafe,
    },
    {
      'id': '2',
      'title': 'Tulsi Kadha',
      'titleHindi': 'तुलसी काढ़ा',
      'category': 'Immunity',
      'duration': '15 mins',
      'difficulty': 'Easy',
      'description': 'Herbal decoction for cold and cough',
      'icon': Icons.local_drink,
    },
    {
      'id': '3',
      'title': 'Triphala Water',
      'titleHindi': 'त्रिफला पानी',
      'category': 'Digestion',
      'duration': '5 mins',
      'difficulty': 'Easy',
      'description': 'Morning detox drink for digestive health',
      'icon': Icons.water_drop,
    },
    {
      'id': '4',
      'title': 'Ashwagandha Milk',
      'titleHindi': 'अश्वगंधा दूध',
      'category': 'Stress',
      'duration': '10 mins',
      'difficulty': 'Easy',
      'description': 'Calming nighttime drink for stress relief',
      'icon': Icons.nightlight,
    },
    {
      'id': '5',
      'title': 'Neem Face Pack',
      'titleHindi': 'नीम फेस पैक',
      'category': 'Skin',
      'duration': '20 mins',
      'difficulty': 'Medium',
      'description': 'Natural face mask for clear skin',
      'icon': Icons.face,
    },
    {
      'id': '6',
      'title': 'Ginger Honey Tea',
      'titleHindi': 'अदरक शहद चाय',
      'category': 'Respiratory',
      'duration': '10 mins',
      'difficulty': 'Easy',
      'description': 'Soothing tea for throat and respiratory health',
      'icon': Icons.local_cafe,
    },
    {
      'id': '7',
      'title': 'Brahmi Oil Massage',
      'titleHindi': 'ब्राह्मी तेल मालिश',
      'category': 'Sleep',
      'duration': '30 mins',
      'difficulty': 'Medium',
      'description': 'Head massage for better sleep and memory',
      'icon': Icons.spa,
    },
    {
      'id': '8',
      'title': 'Amla Chutney',
      'titleHindi': 'आंवला चटनी',
      'category': 'Immunity',
      'duration': '25 mins',
      'difficulty': 'Medium',
      'description': 'Vitamin C rich condiment for immunity',
      'icon': Icons.restaurant,
    },
  ];

  List<Map<String, dynamic>> get _filteredRemedies {
    var filtered = _remedies;
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((r) => r['category'] == _selectedCategory).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((r) {
        return r['title'].toLowerCase().contains(query) ||
            r['description'].toLowerCase().contains(query);
      }).toList();
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: DesignTokens.spacingXs),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
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
                          onTap: () => context.push('/remedy/${remedy['id']}'),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusMd),
                          child: _RemedyCard(remedy: remedy),
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
  final Map<String, dynamic> remedy;

  const _RemedyCard({required this.remedy});

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
              remedy['icon'] as IconData,
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
                      remedy['title'],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    _DifficultyBadge(difficulty: remedy['difficulty']),
                  ],
                ),
                Text(
                  remedy['titleHindi'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  remedy['description'],
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
                      remedy['duration'],
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
                        remedy['category'],
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
