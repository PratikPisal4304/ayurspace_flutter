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
              // Page Header
              Padding(
                padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
                child: Row(
                  children: [
                    Text('Profile',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
              // Profile Avatar
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(user?.name ?? 'User',
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DesignTokens.spacingLg),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                      label: 'Plants\nScanned',
                      value: '${stats.plantsScanned}'),
                  _StatItem(
                      label: 'Remedies\nTried',
                      value: '${stats.remediesTried}'),
                  _StatItem(
                      label: 'Wellness\nScore',
                      value: '${stats.wellnessScore}'),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Dosha Card
              _buildDoshaCard(context, user?.doshaResult),
              const SizedBox(height: DesignTokens.spacingMd),

              // Menu Items
              _MenuItem(
                  icon: Icons.bookmark,
                  label: 'Bookmarked Plants',
                  onTap: () => context.push('/bookmarks')),
              _MenuItem(
                  icon: Icons.favorite,
                  label: 'Favorite Remedies',
                  onTap: () => context.push('/favorites')),
              _MenuItem(
                  icon: Icons.quiz,
                  label: 'Take Dosha Quiz',
                  onTap: () => context.push('/dosha-quiz')),
              _MenuItem(
                  icon: Icons.language,
                  label: 'Language',
                  trailing: 'English',
                  onTap: () => _showLanguageDialog(context)),
              _MenuItem(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  onTap: () => _showNotificationsDialog(context)),
              _MenuItem(
                  icon: Icons.dark_mode,
                  label: 'Dark Mode',
                  onTap: () => _showDarkModeSnackBar(context)),
              _MenuItem(
                  icon: Icons.help,
                  label: 'Help & Support',
                  onTap: () => _showHelpDialog(context)),
              _MenuItem(
                  icon: Icons.info,
                  label: 'About AyurSpace',
                  onTap: () => _showAboutDialog(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check, color: AppColors.primary),
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const SizedBox(width: 24),
              title: const Text('हिंदी (Hindi)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hindi language coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Daily Tips'),
              subtitle: const Text('Receive daily Ayurvedic tips'),
              value: true,
              onChanged: (v) {},
            ),
            SwitchListTile(
              title: const Text('Reminders'),
              subtitle: const Text('Wellness practice reminders'),
              value: false,
              onChanged: (v) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showDarkModeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dark mode coming soon!'),
        duration: Duration(seconds: 2),
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

  Widget _buildDoshaCard(BuildContext context, dynamic doshaResult) {
    return GestureDetector(
      onTap: () => context.push('/dosha-quiz'),
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
                    ? 'Your Dosha: ${doshaResult.dominant.displayName}'
                    : 'Discover Your Dosha',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white)),
            const SizedBox(height: DesignTokens.spacingXxs),
            Text(
                doshaResult != null
                    ? 'Tap to view details'
                    : 'Take the quiz to find out',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white70)),
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
        Text(value,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.primary)),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon,
      required this.label,
      this.trailing,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: trailing != null
          ? Text(trailing!, style: Theme.of(context).textTheme.bodySmall)
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
