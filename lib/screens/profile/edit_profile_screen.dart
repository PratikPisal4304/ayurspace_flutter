import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  int _selectedAvatarIndex = 0;
  bool _isLoading = false;

  final List<IconData> _avatarIcons = [
    Icons.person,
    Icons.spa,
    Icons.local_florist,
    Icons.eco,
    Icons.self_improvement,
    Icons.favorite,
  ];

  final List<Color> _avatarColors = [
    AppColors.primary,
    AppColors.saffron,
    AppColors.neemGreen,
    AppColors.lotusPink,
    AppColors.vata,
    AppColors.pitta,
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _selectedAvatarIndex = user?.avatarIndex ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.editProfileNameShort),
            backgroundColor: AppColors.error),
      );
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.editProfileInvalidEmail),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.updateName(name);
      await userNotifier.updateEmail(email);
      await userNotifier.updateAvatarIndex(_selectedAvatarIndex);

      if (mounted) {
        final l10nMsg = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10nMsg.editProfileUpdated),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Selection
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _avatarColors[_selectedAvatarIndex]
                        .withValues(alpha: 0.2),
                    child: Icon(
                      _avatarIcons[_selectedAvatarIndex],
                      size: 50,
                      color: _avatarColors[_selectedAvatarIndex],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Text(
                    l10n.editProfileSelectAvatar,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),

            // Avatar Options
            Center(
              child: Wrap(
                spacing: DesignTokens.spacingSm,
                children: List.generate(_avatarIcons.length, (index) {
                  final isSelected = _selectedAvatarIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatarIndex = index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _avatarColors[index].withValues(alpha: 0.2)
                            : AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: _avatarColors[index], width: 2)
                            : null,
                      ),
                      child: Icon(
                        _avatarIcons[index],
                        color: _avatarColors[index],
                        size: 24,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXl),

            // Name Field
            Text(
              l10n.editProfileName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Email Field
            Text(
              l10n.editProfileEmail,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXl),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(l10n.editProfileSaveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
