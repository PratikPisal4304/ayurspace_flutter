import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  int _selectedAvatarIndex = 0;

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.updateName(_nameController.text.trim());
      await userNotifier.updateEmail(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save'),
          ),
        ],
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
                    'Choose Avatar',
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
              'Name',
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
              'Email',
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
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
