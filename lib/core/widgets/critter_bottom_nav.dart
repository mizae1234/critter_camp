import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

enum CritterNavTab { home, journey, daily, collection, profile }

class CritterBottomNav extends StatelessWidget {
  final CritterNavTab currentTab;
  final ValueChanged<CritterNavTab> onTabSelected;

  const CritterBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                tab: CritterNavTab.home,
              ),
              _buildNavItem(
                icon: Icons.map_rounded,
                label: 'Journey',
                tab: CritterNavTab.journey,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_rounded,
                label: 'Daily',
                tab: CritterNavTab.daily,
              ),
              _buildNavItem(
                icon: Icons.pets_rounded,
                label: 'Collection',
                tab: CritterNavTab.collection,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                tab: CritterNavTab.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required CritterNavTab tab,
  }) {
    final bool isSelected = currentTab == tab;
    final Color color = isSelected ? AppColors.primary : AppColors.outline;

    return InkWell(
      onTap: () => onTabSelected(tab),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
