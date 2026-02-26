import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final settings = user?.settings ?? const UserSettings();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        children: [
          // Notifications Section
          _SectionHeader(title: l10n.settingsNotifications),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: l10n.settingsPushNotifications,
                subtitle: l10n.settingsPushSubtitle,
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
                title: l10n.settingsDailyTips,
                subtitle: l10n.settingsDailyTipsSubtitle,
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // Appearance Section
          _SectionHeader(title: l10n.settingsAppearance),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_outlined,
                title: l10n.settingsDarkMode,
                subtitle: l10n.settingsDarkModeSubtitle,
                value: settings.darkMode,
                onChanged: (value) {
                  ref.read(userProvider.notifier).updateSettings(
                        settings.copyWith(darkMode: value),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsDarkModeComingSoon),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.language_outlined,
                title: l10n.settingsLanguage,
                trailing: settings.language == 'en'
                    ? 'English'
                    : settings.language == 'mr'
                        ? 'मराठी'
                        : 'हिंदी',
                onTap: () =>
                    _showLanguageSelector(context, ref, settings, l10n),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // Data & Privacy Section
          _SectionHeader(title: l10n.settingsData),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.cloud_outlined,
                title: l10n.settingsAutoBackup,
                subtitle: l10n.settingsAutoBackupSubtitle,
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
                title: l10n.settingsClearCache,
                onTap: () => _showClearCacheDialog(context, l10n),
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.settingsPrivacyPolicy,
                onTap: () {},
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.person_off_outlined,
                title: l10n.settingsDeleteAccount,
                onTap: () => _showDeleteAccountDialog(context, l10n),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),

          // About Section
          _SectionHeader(title: l10n.settingsAbout),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.info_outline,
                title: l10n.settingsAppVersion,
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
                title: l10n.actionShare,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXl),

          // Logout Button
          OutlinedButton(
            onPressed: () => _showSignOutDialog(context, ref, l10n),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref,
      UserSettings settings, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Text(l10n.settingsSelectLanguage,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
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
            },
          ),
          ListTile(
            leading: settings.language == 'mr'
                ? const Icon(Icons.check, color: AppColors.primary)
                : const SizedBox(width: 24),
            title: const Text('मराठी (Marathi)'),
            onTap: () {
              ref.read(userProvider.notifier).updateSettings(
                    settings.copyWith(language: 'mr'),
                  );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearCache),
        content: Text(l10n.settingsClearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsCacheCleared)),
              );
            },
            child: Text(l10n.settingsClearCache),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsSignOut),
        content: Text(l10n.settingsSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteAccountTitle),
        content: Text(l10n.settingsDeleteAccountMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.settingsDeleteAccountRequested),
                    backgroundColor: AppColors.warning),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
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
