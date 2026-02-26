import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/design_tokens.dart';
import '../../l10n/app_localizations.dart';

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

  /// Get localized nav items based on context
  List<_NavItem> _getNavItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _NavItem(
          path: '/home',
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: l10n.navHome),
      _NavItem(
          path: '/discover',
          icon: Icons.local_florist_outlined,
          activeIcon: Icons.local_florist,
          label: l10n.navDiscover),
      _NavItem(
          path: '/camera',
          icon: Icons.camera_alt_outlined,
          activeIcon: Icons.camera_alt,
          label: l10n.navScan),
      _NavItem(
          path: '/remedies',
          icon: Icons.medical_services_outlined,
          activeIcon: Icons.medical_services,
          label: l10n.navRemedies),
      _NavItem(
          path: '/profile',
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: l10n.navProfile),
    ];
  }

  int _getCurrentIndex(BuildContext context, List<_NavItem> navItems) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < navItems.length; i++) {
      if (location.startsWith(navItems[i].path)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _getNavItems(context);
    final currentIndex = _getCurrentIndex(context, navItems);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: DesignTokens.shadowBlurMd,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false, // Force to bottom edge as requested
        child: Padding(
          padding: const EdgeInsets.only(
            left: DesignTokens.spacingXs,
            right: DesignTokens.spacingXs,
            top: DesignTokens.spacingXs,
            bottom: 12.0, // Little up from the bottom
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
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
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final tertiaryColor = colorScheme.onSurfaceVariant;

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
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? primaryColor : tertiaryColor,
              size: DesignTokens.iconSizeMd,
            ),
            const SizedBox(height: DesignTokens.spacingXxs),
            Text(
              item.label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXs,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primaryColor : tertiaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
