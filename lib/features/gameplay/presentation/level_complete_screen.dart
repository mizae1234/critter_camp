import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../data/models/critter_model.dart';
import '../../../game/validator/stage_validation_result.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int stageNumber;
  final String stageName;
  final StageValidationResult validationResult;
  final int acornsEarned;
  final String solveTime;
  final CritterModel unlockedCritter;
  final VoidCallback onNextStage;
  final VoidCallback onReplay;
  final VoidCallback onBackHome;

  const LevelCompleteScreen({
    super.key,
    required this.stageNumber,
    required this.stageName,
    required this.validationResult,
    this.acornsEarned = 15,
    required this.solveTime,
    required this.unlockedCritter,
    required this.onNextStage,
    required this.onReplay,
    required this.onBackHome,
  });

  @override
  Widget build(BuildContext context) {
    final int stars = validationResult.starsEarned.clamp(1, 3);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Celebration Icon & Badge
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Great Solution!',
                style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Stage $stageNumber: $stageName Solved',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.md),

              // Stars Row (1 to 3 Stars earned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final bool isLit = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.star_rounded,
                      size: 40,
                      color: isLit ? const Color(0xFFF59E0B) : AppColors.outlineVariant,
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.md),

              // Performance Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('Time', solveTime),
                  const SizedBox(width: 20),
                  _buildStatItem('Reward', '+$acornsEarned 🌰'),
                  const SizedBox(width: 20),
                  _buildStatItem('Stars', '$stars / 3 ⭐'),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Bonus Objectives Completed
              if (validationResult.bonusObjectivesCompleted.isNotEmpty)
                CritterCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: AppColors.accentGold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          validationResult.bonusObjectivesCompleted.map((b) => b.title).join(' • '),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.md),

              // Unlocked Critter Showcase Card
              CritterCard(
                backgroundColor: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.radiusLg,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    CritterAvatar(
                      emoji: unlockedCritter.emoji,
                      size: 54,
                      isUnlocked: true,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              'COZY CAMPER',
                              style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${unlockedCritter.name} the ${unlockedCritter.species}',
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            unlockedCritter.title,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Action CTAs
              CritterButton(
                text: 'Next Stage',
                isFullWidth: true,
                icon: Icons.arrow_forward_rounded,
                onPressed: onNextStage,
              ),

              const SizedBox(height: AppSpacing.sm),

              Row(
                children: [
                  Expanded(
                    child: CritterButton(
                      text: 'Replay',
                      variant: CritterButtonVariant.outline,
                      icon: Icons.replay_rounded,
                      onPressed: onReplay,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CritterButton(
                      text: 'Map',
                      variant: CritterButtonVariant.ghost,
                      icon: Icons.map_rounded,
                      onPressed: onBackHome,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
      ],
    );
  }
}
