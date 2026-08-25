import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../localization/app_strings.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: AppStrings.home,
                tab: CritterNavTab.home,
              ),
              _buildNavItem(
                icon: Icons.map_rounded,
                label: AppStrings.journey,
                tab: CritterNavTab.journey,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_rounded,
                label: AppStrings.daily,
                tab: CritterNavTab.daily,
              ),
              _buildNavItem(
                icon: Icons.pets_rounded,
                label: AppStrings.collection,
                tab: CritterNavTab.collection,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: AppStrings.profile,
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

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(tab),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
