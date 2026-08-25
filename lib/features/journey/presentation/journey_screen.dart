import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/models/user_progress.dart';
import '../../../game/stage/stages/stage_catalog.dart';

class JourneyScreen extends StatelessWidget {
  final UserProgress userProgress;
  final ValueChanged<int> onSelectLevel;

  const JourneyScreen({
    super.key,
    required this.userProgress,
    required this.onSelectLevel,
  });

  @override
  Widget build(BuildContext context) {
    final stages = StageCatalog.allStages;
    final int completedCount = stages.where((s) => userProgress.isLevelCompleted(s.stageNumber)).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Biome Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forest Trail',
                          style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Biome 1 • $completedCount/${stages.length} Stages Cleared',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${userProgress.totalStars} Stars',
                          style: AppTypography.labelSmall.copyWith(
                            color: const Color(0xFF92400E),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.outlineVariant),

            // Winding Trail List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                reverse: true, // Stage 1 at bottom, ascending to Stage 5
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  final stage = stages[index];
                  final int stageNum = stage.stageNumber;
                  final bool isCompleted = userProgress.isLevelCompleted(stageNum);
                  final bool isCurrent = stageNum == userProgress.currentLevel;
                  final bool isLocked = !userProgress.isLevelUnlocked(stageNum);

                  // Calculate alternating offset for winding trail effect
                  final double xOffset = (stageNum % 2 == 0) ? 40.0 : -40.0;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    child: Transform.translate(
                      offset: Offset(xOffset, 0),
                      child: Center(
                        child: _buildStageNode(
                          stageNumber: stageNum,
                          stageName: stage.name,
                          isCompleted: isCompleted,
                          isCurrent: isCurrent,
                          isLocked: isLocked,
                          onTap: isLocked ? null : () => onSelectLevel(stageNum),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageNode({
    required int stageNumber,
    required String stageName,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
    required VoidCallback? onTap,
  }) {
    Color bg;
    Widget child;

    if (isCurrent) {
      bg = AppColors.primary;
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$stageNumber', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const Text('PLAY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primaryContainer)),
        ],
      );
    } else if (isCompleted) {
      bg = AppColors.primaryLight;
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$stageNumber', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 10, color: AppColors.accentAmber),
              Icon(Icons.star_rounded, size: 10, color: AppColors.accentAmber),
              Icon(Icons.star_rounded, size: 10, color: AppColors.accentAmber),
            ],
          ),
        ],
      );
    } else {
      bg = AppColors.surfaceContainerHigh;
      child = const Icon(Icons.lock_rounded, size: 20, color: AppColors.outline);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isCurrent ? 72 : 58,
            height: isCurrent ? 72 : 58,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? AppColors.primaryLight : AppColors.outlineVariant,
                width: isCurrent ? 3 : 1.5,
              ),
              boxShadow: [
                if (isCurrent)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(child: child),
          ),
          const SizedBox(height: 4),
          Text(
            stageName,
            style: AppTypography.labelSmall.copyWith(
              color: isLocked ? AppColors.outline : AppColors.onSurface,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
