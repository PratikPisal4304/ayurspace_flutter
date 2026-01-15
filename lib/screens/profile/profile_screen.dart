import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final stats = ref.watch(userStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            children: [
              // Page Header with Settings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.navProfile,
                      style: Theme.of(context).textTheme.headlineMedium),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingMd),

              // Profile Card
              _ProfileCard(user: user, stats: stats, l10n: l10n),
              const SizedBox(height: DesignTokens.spacingLg),

              // Achievements Section
              _AchievementsSection(stats: stats, l10n: l10n),
              const SizedBox(height: DesignTokens.spacingLg),

              // Dosha Card
              _buildDoshaCard(context, user?.doshaResult, l10n),
              const SizedBox(height: DesignTokens.spacingMd),

              // Menu Items
              _MenuCard(
                children: [
                  _MenuItem(
                      icon: Icons.bookmark_outline,
                      label: l10n.profileBookmarks,
                      onTap: () => context.push('/bookmarks')),
                  _MenuItem(
                      icon: Icons.favorite_outline,
                      label: l10n.profileFavorites,
                      onTap: () => context.push('/favorites')),
                  _MenuItem(
                      icon: Icons.quiz_outlined,
                      label: l10n.profileDoshaQuiz,
                      onTap: () => context.push('/dosha-quiz')),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              _MenuCard(
                children: [
                  _MenuItem(
                      icon: Icons.help_outline,
                      label: l10n.profileHelp,
                      onTap: () => _showHelpDialog(context)),
                  _MenuItem(
                      icon: Icons.info_outline,
                      label: l10n.profileAbout,
                      onTap: () => _showAboutDialog(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 Email: support@ayurspace.app'),
            SizedBox(height: 8),
            Text('🌐 Website: www.ayurspace.app'),
            SizedBox(height: 16),
            Text(
              'FAQs',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• How do I use the plant scanner?'),
            Text('• What is my dosha?'),
            Text('• Are remedies safe to use?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.spa, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('AyurSpace'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 12),
            Text(
              'Your complete Ayurveda companion. Discover traditional herbs, '
              'personalized remedies, and wellness practices based on ancient wisdom.',
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 AyurSpace. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(BuildContext context, dynamic doshaResult, AppLocalizations l10n) {
    String doshaName = '';
    if (doshaResult != null) {
        final locale = Localizations.localeOf(context).languageCode;
        // Accessing nested dominant property. Usually doshaResult is DoshaResult type
        // Assuming dynamic resolution works or use type casting
        doshaName = locale == 'hi' 
            ? doshaResult.dominant.hindi 
            : doshaResult.dominant.displayName;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/dosha-quiz'),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.neemGreen]),
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          child: Column(
            children: [
              const Icon(Icons.spa, color: Colors.white, size: 40),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                  doshaResult != null
                      ? l10n.doshaResultTitle(doshaName)
                      : l10n.doshaDiscover,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: DesignTokens.spacingXxs),
              Text(
                  doshaResult != null
                      ? l10n.doshaViewDetails
                      : l10n.doshaTakeQuiz,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final dynamic user;
  final dynamic stats;
  final AppLocalizations l10n;

  const _ProfileCard({this.user, this.stats, required this.l10n});

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
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'User',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(user?.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: DesignTokens.spacingXs),
                    // Streak Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: AppColors.saffron, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            l10n.streakDays(7), // Mock value
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.saffron),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                onPressed: () => context.push('/edit-profile'),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          const Divider(),
          const SizedBox(height: DesignTokens.spacingSm),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                  label: l10n.statsPlants,
                  value: '${stats?.plantsScanned ?? 0}'),
              Container(height: 40, width: 1, color: AppColors.border),
              _StatItem(
                  label: l10n.statsRemedies,
                  value: '${stats?.remediesTried ?? 0}'),
              Container(height: 40, width: 1, color: AppColors.border),
              _StatItem(
                  label: l10n.statsWellness,
                  value: '${stats?.wellnessScore ?? 72}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center),
      ],
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final dynamic stats;
  final AppLocalizations l10n;

  const _AchievementsSection({this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.achievementsTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: DesignTokens.spacingSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _AchievementBadge(
                icon: Icons.eco,
                title: 'Plant Explorer',
                subtitle: 'Scan 10 plants',
                progress: (stats?.plantsScanned ?? 0) / 10,
                unlocked: (stats?.plantsScanned ?? 0) >= 10,
                color: AppColors.neemGreen,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              _AchievementBadge(
                icon: Icons.medical_services,
                title: 'Remedy Master',
                subtitle: 'Try 5 remedies',
                progress: (stats?.remediesTried ?? 0) / 5,
                unlocked: (stats?.remediesTried ?? 0) >= 5,
                color: AppColors.saffron,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              _AchievementBadge(
                icon: Icons.self_improvement,
                title: 'Wellness Guru',
                subtitle: 'Score 80+',
                progress: (stats?.wellnessScore ?? 0) / 80,
                unlocked: (stats?.wellnessScore ?? 0) >= 80,
                color: AppColors.lotusPink,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              _AchievementBadge(
                icon: Icons.local_fire_department,
                title: 'Week Streak',
                subtitle: '7 days active',
                progress: 7 / 7,
                unlocked: true,
                color: AppColors.vata,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final bool unlocked;
  final Color color;

  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.unlocked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color:
            unlocked ? color.withValues(alpha: 0.1) : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: unlocked ? color.withValues(alpha: 0.3) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(
                      unlocked ? color : AppColors.textTertiary),
                  strokeWidth: 3,
                ),
              ),
              Icon(
                icon,
                color: unlocked ? color : AppColors.textTertiary,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: unlocked ? color : AppColors.textTertiary,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: DesignTokens.shadowBlurSm,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}


