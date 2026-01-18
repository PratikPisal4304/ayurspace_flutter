import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final settings = user?.settings ?? const UserSettings();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        children: [
          // Notifications Section
          const _SectionHeader(title: 'Notifications'),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive daily tips and reminders',
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  ref.read(userProvider.notifier).updateSettings(
                        settings.copyWith(notificationsEnabled: value),
                      );
                },
              ),
              const Divider(height: 1),
              _SwitchTile(
                icon: Icons.wb_sunny_outlined,
                title: 'Daily Wellness Tips',
                subtitle: 'Get Ayurvedic tips each morning',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // Appearance Section
          const _SectionHeader(title: 'Appearance'),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: settings.darkMode,
                onChanged: (value) {
                  ref.read(userProvider.notifier).updateSettings(
                        settings.copyWith(darkMode: value),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dark mode coming in next update!'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.language_outlined,
                title: 'Language',
                trailing: settings.language == 'en' ? 'English' : 'हिंदी',
                onTap: () => _showLanguageSelector(context, ref, settings),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // Data & Privacy Section
          const _SectionHeader(title: 'Data & Privacy'),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.cloud_outlined,
                title: 'Auto Backup',
                subtitle: 'Backup your data to cloud',
                value: settings.autoBackup,
                onChanged: (value) {
                  ref.read(userProvider.notifier).updateSettings(
                        settings.copyWith(autoBackup: value),
                      );
                },
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.delete_outline,
                title: 'Clear Cache',
                onTap: () => _showClearCacheDialog(context),
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // About Section
          const _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: '1.0.0',
                onTap: () {},
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.star_outline,
                title: 'Rate App',
                onTap: () {},
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.share_outlined,
                title: 'Share App',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXl),

          // Logout Button
          OutlinedButton(
            onPressed: () => _showSignOutDialog(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: settings.language == 'en'
                ? const Icon(Icons.check, color: AppColors.primary)
                : const SizedBox(width: 24),
            title: const Text('English'),
            onTap: () {
              ref.read(userProvider.notifier).updateSettings(
                    settings.copyWith(language: 'en'),
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: settings.language == 'hi'
                ? const Icon(Icons.check, color: AppColors.primary)
                : const SizedBox(width: 24),
            title: const Text('हिंदी (Hindi)'),
            onTap: () {
              ref.read(userProvider.notifier).updateSettings(
                    settings.copyWith(language: 'hi'),
                  );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hindi language coming soon!')),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content:
            const Text('This will clear all cached images and data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared!')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await ref.read(authProvider.notifier).signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: DesignTokens.spacingXs,
        bottom: DesignTokens.spacingXs,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

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

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing!, style: Theme.of(context).textTheme.bodySmall)
          : const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
