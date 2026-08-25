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
import '../../../core/localization/app_strings.dart';

class HomeScreen extends StatelessWidget {
  final UserProgress userProgress;
  final List<CritterModel> recentCritters;
  final VoidCallback onContinueLevel;
  final VoidCallback onPlayDaily;
  final ValueChanged<CritterModel> onSelectCritter;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLeaderboard;
  final VoidCallback onOpenTutorial;

  const HomeScreen({
    super.key,
    required this.userProgress,
    required this.recentCritters,
    required this.onContinueLevel,
    required this.onPlayDaily,
    required this.onSelectCritter,
    required this.onOpenSettings,
    required this.onOpenLeaderboard,
    required this.onOpenTutorial,
  });

  @override
  Widget build(BuildContext context) {
    final currentStage = StageCatalog.getByNumber(userProgress.currentLevel);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cozy Campsite Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/images/bg_campsite.jpg',
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
                      const SizedBox(width: 4),
                      StreakBadge(streakDays: userProgress.streakDays),
                      const SizedBox(width: 4),
                      AcornBadge(acorns: userProgress.acorns),
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.help_outline_rounded, color: AppColors.onSurfaceVariant, size: 20),
                        onPressed: onOpenTutorial,
                        tooltip: AppStrings.howToPlay,
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.settings_rounded, color: AppColors.onSurfaceVariant, size: 20),
                        onPressed: onOpenSettings,
                        tooltip: 'Settings',
                      ),
                    ],
                  ),

              const SizedBox(height: AppSpacing.xl),

              // Continue Journey Hero Card with Campfire Artwork
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.7)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.16),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scenic Hero Image Banner (Dedicated 155px height)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/bg_campsite.jpg',
                            width: double.infinity,
                            height: 155,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(height: 155, color: AppColors.primaryDark),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Row(
                                children: [
                                  Text(currentStage.speakerEmoji, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Chapter ${currentStage.chapterNumber}: ${currentStage.chapterName}',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 14,
                            child: Text(
                              '${AppStrings.stagePrefix} ${currentStage.stageNumber}: ${currentStage.name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Body content
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                ),
                                child: Text(
                                  '${currentStage.size}x${currentStage.size} Grid',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                ),
                                child: Text(
                                  '+${currentStage.baseAcornsReward} Acorns',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.accentGold, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.isThai ? currentStage.storyTextTh : currentStage.storyTextEn,
                            style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 14),
                          CritterButton(
                            text: '${AppStrings.playCurrentStage} ${currentStage.stageNumber}',
                            variant: CritterButtonVariant.primary,
                            isFullWidth: true,
                            icon: Icons.play_arrow_rounded,
                            onPressed: onContinueLevel,
                          ),
                        ],
                      ),
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
                          Text('${AppStrings.dailyChallenge} • 6x6', style: AppTypography.labelMedium.copyWith(color: AppColors.accentGold)),
                          const SizedBox(height: 2),
                          const Text('River Bend', style: TextStyle(fontWeight: FontWeight.w700)),
                          Text('+25 Acorns', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
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
                      child: Text(AppStrings.playDaily),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Leaderboard Banner Card
              CritterCard(
                backgroundColor: const Color(0xFFF3F4F6),
                borderRadius: AppSpacing.radiusMd,
                onTap: onOpenLeaderboard,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Center(
                        child: Text('🏆', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.viewLeaderboard, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(AppStrings.topCampersThisWeek, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Recent Critters Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.recentCritters, style: AppTypography.titleLarge),
                  Text('${recentCritters.where((c) => c.isUnlocked).length} ${AppStrings.unlocked}', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
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
    ],
  ),
);
  }
}
