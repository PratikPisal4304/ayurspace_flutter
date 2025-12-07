import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';
import '../../widgets/plant_card.dart';
import '../../providers/plants_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final plantsState = ref.watch(plantsProvider);
    final featuredPlants = plantsState.plants.take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXxs),
                      Text(
                        user?.name ?? 'Wellness Seeker',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Wellness Score Card
              _WellnessCard(user: user),
              const SizedBox(height: DesignTokens.spacingLg),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              const _QuickActionsRow(),
              const SizedBox(height: DesignTokens.spacingLg),

              // Featured Plants
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Plants',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.go('/discover'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredPlants.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: DesignTokens.spacingSm),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 180,
                      child: PlantCard(
                        plant: featuredPlants[index],
                        onTap: () =>
                            context.push('/plant/${featuredPlants[index].id}'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Daily Tip
              _DailyTipCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WellnessCard extends StatelessWidget {
  final dynamic user;

  const _WellnessCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.neemGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: DesignTokens.shadowBlurLg,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Wellness Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user?.stats?.wellnessScore ?? 72}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: DesignTokens.spacingXs,
                          left: DesignTokens.spacingXxs),
                      child: Text(
                        '/100',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  'Keep up the great work! 🌿',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionItem(
          icon: Icons.camera_alt,
          label: 'Scan Plant',
          color: AppColors.primary,
          onTap: () => context.go('/camera'),
        ),
        _QuickActionItem(
          icon: Icons.chat_bubble_outline,
          label: 'Ask AyurBot',
          color: AppColors.saffron,
          onTap: () => context.go('/chat'),
        ),
        _QuickActionItem(
          icon: Icons.self_improvement,
          label: 'Wellness',
          color: AppColors.lotusPink,
          onTap: () => context.go('/wellness'),
        ),
        _QuickActionItem(
          icon: Icons.quiz_outlined,
          label: 'Dosha Quiz',
          color: AppColors.vata,
          onTap: () => context.push('/dosha-quiz'),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.turmeric.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: AppColors.turmeric.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.turmeric.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.turmeric,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Tip',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.turmeric,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: DesignTokens.spacingXxs),
                Text(
                  'Start your day with warm water and a teaspoon of honey to boost digestion and energy.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
