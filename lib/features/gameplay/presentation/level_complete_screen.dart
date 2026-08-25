import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../data/models/critter_model.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int levelNumber;
  final int stars;
  final int acornsEarned;
  final String solveTime;
  final CritterModel unlockedCritter;
  final VoidCallback onNextPuzzle;
  final VoidCallback onBackHome;

  const LevelCompleteScreen({
    super.key,
    required this.levelNumber,
    this.stars = 3,
    this.acornsEarned = 15,
    required this.solveTime,
    required this.unlockedCritter,
    required this.onNextPuzzle,
    required this.onBackHome,
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

              // Celebration Icon & Badge
              Container(
                width: 100,
                height: 100,
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
                    Icons.emoji_events_rounded,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'Perfect!',
                style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Level $levelNumber Complete',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.md),

              // 3 Stars Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final bool isLit = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: isLit ? const Color(0xFFF59E0B) : AppColors.outlineVariant,
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('Time', solveTime),
                  const SizedBox(width: 24),
                  _buildStatItem('Reward', '+$acornsEarned 🌰'),
                  const SizedBox(width: 24),
                  _buildStatItem('Streak', '+1 Day 🔥'),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Unlocked Critter Showcase Card
              CritterCard(
                backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.35),
                borderColor: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: AppSpacing.radiusLg,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    CritterAvatar(
                      emoji: unlockedCritter.emoji,
                      size: 60,
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
                              'NEW CRITTER UNLOCKED!',
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

              // CTA Buttons
              CritterButton(
                text: 'Next Puzzle',
                isFullWidth: true,
                icon: Icons.arrow_forward_rounded,
                onPressed: onNextPuzzle,
              ),

              const SizedBox(height: AppSpacing.sm),

              CritterButton(
                text: 'Back Home',
                variant: CritterButtonVariant.ghost,
                isFullWidth: true,
                onPressed: onBackHome,
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
