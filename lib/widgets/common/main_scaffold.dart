import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

/// Main scaffold with bottom navigation
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  static const _navItems = [
    _NavItem(
        path: '/home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home'),
    _NavItem(
        path: '/discover',
        icon: Icons.local_florist_outlined,
        activeIcon: Icons.local_florist,
        label: 'Discover'),
    _NavItem(
        path: '/camera',
        icon: Icons.camera_alt_outlined,
        activeIcon: Icons.camera_alt,
        label: 'Scan'),
    _NavItem(
        path: '/remedies',
        icon: Icons.medical_services_outlined,
        activeIcon: Icons.medical_services,
        label: 'Remedies'),
    _NavItem(
        path: '/profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile'),
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].path)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: DesignTokens.shadowBlurMd,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXs,
            vertical: DesignTokens.spacingXs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _NavItemWidget(
                item: item,
                isSelected: isSelected,
                onTap: () => context.go(item.path),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: DesignTokens.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm,
          vertical: DesignTokens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: DesignTokens.iconSizeMd,
            ),
            const SizedBox(height: DesignTokens.spacingXxs),
            Text(
              item.label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXs,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
