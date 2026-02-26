import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../../widgets/plant_card.dart';
import '../../providers/plants_provider.dart';

import '../../widgets/common/responsive_center.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final plantsState = ref.watch(plantsProvider);
    final featuredPlants = plantsState.plants.take(4).toList();
    final greetingType = ref.watch(greetingTypeProvider);
    final l10n = AppLocalizations.of(context)!;

    String greeting;
    switch (greetingType) {
      case GreetingType.morning:
        greeting = l10n.greetingMorning;
        break;
      case GreetingType.afternoon:
        greeting = l10n.greetingAfternoon;
        break;
      case GreetingType.evening:
        greeting = l10n.greetingEvening;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: SingleChildScrollView(
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
                          greeting,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () => context.push('/profile'),
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                // Wellness Score Card
                _WellnessCard(user: user, l10n: l10n),
                const SizedBox(height: DesignTokens.spacingLg),

                // Quick Actions
                Text(
                  l10n.quickActions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                _QuickActionsRow(l10n: l10n),
                const SizedBox(height: DesignTokens.spacingLg),

                // Featured Plants
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.featuredPlants,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context.go('/discover'),
                      child: Text(l10n.viewAll),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 300, // Cache 300 pixels of items off-screen
                    itemCount: featuredPlants.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: DesignTokens.spacingSm),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 180,
                        child: RepaintBoundary(
                          child: PlantCard(
                            plant: featuredPlants[index],
                            onTap: () => context
                                .push('/plant/${featuredPlants[index].id}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                // Daily Tip
                _DailyTipCard(l10n: l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WellnessCard extends StatelessWidget {
  final UserProfile? user;
  final AppLocalizations l10n;

  const _WellnessCard({this.user, required this.l10n});

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
            color: AppColors.primary.withValues(alpha: 0.3),
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
                  l10n.wellnessScoreTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user?.stats.wellnessScore ?? 72}',
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  l10n.wellnessKeepUp,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
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
  final AppLocalizations l10n;
  const _QuickActionsRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionItem(
          icon: Icons.camera_alt,
          label: l10n.plantScan,
          color: AppColors.primary,
          onTap: () => context.go('/camera'),
        ),
        _QuickActionItem(
          icon: Icons.chat_bubble_outline,
          label: l10n.consultAi,
          color: AppColors.saffron,
          onTap: () => context.go('/chat'),
        ),
        _QuickActionItem(
          icon: Icons.self_improvement,
          label: l10n.navWellness,
          color: AppColors.lotusPink,
          onTap: () => context.go('/wellness'),
        ),
        _QuickActionItem(
          icon: Icons.quiz_outlined,
          label: l10n.doshaQuiz,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        child: Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXs),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _DailyTipCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('More daily tips coming soon!'), // Localize
              duration: Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.turmeric.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(
              color: AppColors.turmeric.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.turmeric.withValues(alpha: 0.2),
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
                      l10n.dailyTip,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.turmeric,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXxs),
                    Text(
                      l10n.dailyTipContent,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
