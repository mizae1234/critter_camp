import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../data/models/critter_model.dart';

class CritterDetailModal extends StatelessWidget {
  final CritterModel critter;
  final VoidCallback onClose;

  const CritterDetailModal({
    super.key,
    required this.critter,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Character Avatar
            CritterAvatar(
              emoji: critter.emoji,
              size: 80,
              isUnlocked: critter.isUnlocked,
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              critter.name,
              style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
            ),

            Text(
              '${critter.species} • ${critter.title}',
              style: AppTypography.labelMedium.copyWith(color: AppColors.outline),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Bio Box
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.outlineVariant, width: 0.8),
              ),
              child: Text(
                critter.bio,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Favorite Food & Perk
            Row(
              children: [
                Expanded(
                  child: _buildInfoBox(
                    icon: Icons.restaurant_rounded,
                    label: 'Favorite Snack',
                    value: critter.favoriteFood,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                Expanded(
                  child: _buildInfoBox(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Special Perk',
                    value: critter.perkDescription,
                    isHighlight: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            CritterButton(
              text: 'Close',
              variant: CritterButtonVariant.ghost,
              isFullWidth: true,
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.primaryContainer.withValues(alpha: 0.4) : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: isHighlight ? AppColors.primaryDark : AppColors.outline),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isHighlight ? AppColors.primaryDark : AppColors.outline,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
