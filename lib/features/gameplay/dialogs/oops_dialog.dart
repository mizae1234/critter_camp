import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/heart_indicator.dart';

class OopsDialog extends StatelessWidget {
  final String errorMessage;
  final int remainingLives;
  final VoidCallback onUndo;
  final VoidCallback onDismiss;

  const OopsDialog({
    super.key,
    required this.errorMessage,
    required this.remainingLives,
    required this.onUndo,
    required this.onDismiss,
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
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Oops Character / Icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFCDD2), width: 2),
              ),
              child: const Center(
                child: Text('🙈', style: TextStyle(fontSize: 34)),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Oops! That\'s a conflict',
              style: AppTypography.headlineMedium.copyWith(color: AppColors.error),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              errorMessage,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // Lives Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hearts left: ', style: AppTypography.labelSmall),
                  HeartIndicator(currentHearts: remainingLives),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Actions
            CritterButton(
              text: 'Undo Move',
              variant: CritterButtonVariant.primary,
              isFullWidth: true,
              icon: Icons.undo_rounded,
              onPressed: onUndo,
            ),

            const SizedBox(height: AppSpacing.sm),

            CritterButton(
              text: 'Keep Going',
              variant: CritterButtonVariant.ghost,
              isFullWidth: true,
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
