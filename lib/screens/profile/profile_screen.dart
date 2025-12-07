import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final stats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            children: [
              // Profile Header
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(user?.name ?? 'User', style: Theme.of(context).textTheme.headlineSmall),
              Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DesignTokens.spacingLg),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(label: 'Plants\nScanned', value: '${stats.plantsScanned}'),
                  _StatItem(label: 'Remedies\nTried', value: '${stats.remediesTried}'),
                  _StatItem(label: 'Wellness\nScore', value: '${stats.wellnessScore}'),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Dosha Card
              _buildDoshaCard(context, user?.doshaResult),
              const SizedBox(height: DesignTokens.spacingMd),

              // Menu Items
              _MenuItem(icon: Icons.bookmark, label: 'Bookmarked Plants', onTap: () {}),
              _MenuItem(icon: Icons.favorite, label: 'Favorite Remedies', onTap: () {}),
              _MenuItem(icon: Icons.quiz, label: 'Take Dosha Quiz', onTap: () => context.push('/dosha-quiz')),
              _MenuItem(icon: Icons.language, label: 'Language', trailing: 'English', onTap: () {}),
              _MenuItem(icon: Icons.notifications, label: 'Notifications', onTap: () {}),
              _MenuItem(icon: Icons.dark_mode, label: 'Dark Mode', onTap: () {}),
              _MenuItem(icon: Icons.help, label: 'Help & Support', onTap: () {}),
              _MenuItem(icon: Icons.info, label: 'About AyurSpace', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoshaCard(BuildContext context, dynamic doshaResult) {
    return GestureDetector(
      onTap: () => context.push('/dosha-quiz'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.neemGreen]),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        child: Column(
          children: [
            const Icon(Icons.spa, color: Colors.white, size: 40),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(doshaResult != null ? 'Your Dosha: ${doshaResult.dominant.displayName}' : 'Discover Your Dosha',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: DesignTokens.spacingXxs),
            Text(doshaResult != null ? 'Tap to view details' : 'Take the quiz to find out',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
          ],
        ),
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
        Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: trailing != null ? Text(trailing!, style: Theme.of(context).textTheme.bodySmall) : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
