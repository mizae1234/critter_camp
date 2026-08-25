import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';

class TutorialScreen extends StatelessWidget {
  final VoidCallback onDismiss;

  const TutorialScreen({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.howToPlay),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: onDismiss,
        ),
      ),
      body: Stack(
        children: [
          // 🌲 Scenic Forest Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/bg_gameplay.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.howToPlayTitle,
                    style: AppTypography.headlineLarge.copyWith(color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.appTagline,
                    style: AppTypography.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  _buildRuleCard(
                    number: '1',
                    title: AppStrings.rule1Title,
                    desc: AppStrings.rule1Desc,
                    icon: Icons.grid_4x4_rounded,
                    iconColor: AppColors.primary,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildRuleCard(
                    number: '2',
                    title: AppStrings.rule2Title,
                    desc: AppStrings.rule2Desc,
                    icon: Icons.palette_rounded,
                    iconColor: AppColors.habitatSage,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildRuleCard(
                    number: '3',
                    title: AppStrings.rule3Title,
                    desc: AppStrings.rule3Desc,
                    icon: Icons.accessibility_new_rounded,
                    iconColor: const Color(0xFFE11D48),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  CritterButton(
                    text: AppStrings.gotIt,
                    isFullWidth: true,
                    icon: Icons.check_rounded,
                    onPressed: onDismiss,
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required String number,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
  }) {
    return CritterCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
