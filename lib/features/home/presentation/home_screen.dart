import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/widgets/streak_badge.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../data/models/critter_model.dart';
import '../../../data/models/user_progress.dart';
import '../../../game/stage/stages/stage_catalog.dart';

class HomeScreen extends StatelessWidget {
  final UserProgress userProgress;
  final List<CritterModel> recentCritters;
  final VoidCallback onContinueLevel;
  final VoidCallback onPlayDaily;
  final ValueChanged<CritterModel> onSelectCritter;
  final VoidCallback onOpenSettings;

  const HomeScreen({
    super.key,
    required this.userProgress,
    required this.recentCritters,
    required this.onContinueLevel,
    required this.onPlayDaily,
    required this.onSelectCritter,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final currentStage = StageCatalog.getByNumber(userProgress.currentLevel);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(Icons.forest_rounded, color: AppColors.primaryDark, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Critter Camp',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  StreakBadge(streakDays: userProgress.streakDays),
                  const SizedBox(width: 4),
                  AcornBadge(acorns: userProgress.acorns),
                  IconButton(
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.settings_rounded, color: AppColors.onSurfaceVariant, size: 20),
                    onPressed: onOpenSettings,
                    tooltip: 'Settings',
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Continue Journey Hero Card
              CritterCard(
                backgroundColor: AppColors.primaryDark,
                borderRadius: AppSpacing.radiusLg,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            '${currentStage.biomeName} • ${currentStage.size}x${currentStage.size}',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryContainer),
                          ),
                        ),
                        const Icon(Icons.nature_people_rounded, color: AppColors.primaryLight),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Ready for a little\nbrain break?',
                      style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Stage ${currentStage.stageNumber}: ${currentStage.name} is waiting for you.',
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CritterButton(
                      text: 'Play Stage ${currentStage.stageNumber}',
                      variant: CritterButtonVariant.secondary,
                      isFullWidth: true,
                      icon: Icons.play_arrow_rounded,
                      onPressed: onContinueLevel,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Daily Puzzle Banner
              CritterCard(
                backgroundColor: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.radiusMd,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Center(
                        child: Icon(Icons.calendar_month_rounded, color: AppColors.accentGold, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Puzzle • 6x6', style: AppTypography.labelMedium.copyWith(color: AppColors.accentGold)),
                          const SizedBox(height: 2),
                          Text('River Bend', style: AppTypography.titleMedium),
                          Text('+25 Acorns reward', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onPlayDaily,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
                      ),
                      child: const Text('Play Daily'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Recent Critters Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Critters', style: AppTypography.titleLarge),
                  Text('${recentCritters.where((c) => c.isUnlocked).length} Unlocked', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentCritters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final critter = recentCritters[index];
                    return GestureDetector(
                      onTap: () => onSelectCritter(critter),
                      child: Container(
                        width: 95,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.outlineVariant, width: 0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CritterAvatar(
                              emoji: critter.emoji,
                              size: 44,
                              isUnlocked: critter.isUnlocked,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              critter.name,
                              style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              critter.isUnlocked ? critter.biome : 'Lvl ${critter.unlockLevel}',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 9),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
