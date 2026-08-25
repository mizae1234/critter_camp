import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';

class FirstLaunchScreen extends StatelessWidget {
  final VoidCallback onStartPlaying;
  final VoidCallback onHowToPlay;

  const FirstLaunchScreen({
    super.key,
    required this.onStartPlaying,
    required this.onHowToPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Hero Illustration & Badge
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.forest_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'Critter Camp',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Tagline
              Text(
                'A cozy habitat puzzle game where every animal finds its peaceful grove.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Feature Highlights Row
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeatureItem(Icons.grid_4x4_rounded, 'Pure Logic'),
                    _buildFeatureItem(Icons.pets_rounded, '20+ Critters'),
                    _buildFeatureItem(Icons.bedtime_rounded, 'Zen Mode'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Actions
              CritterButton(
                text: 'Start Playing',
                isFullWidth: true,
                icon: Icons.play_arrow_rounded,
                onPressed: onStartPlaying,
              ),

              const SizedBox(height: AppSpacing.md),

              CritterButton(
                text: 'How to Play',
                variant: CritterButtonVariant.outline,
                isFullWidth: true,
                icon: Icons.menu_book_rounded,
                onPressed: onHowToPlay,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'No timer pressure • Offline friendly',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.outline,
                ),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
