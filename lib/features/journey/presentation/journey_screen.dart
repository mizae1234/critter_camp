import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/app_strings.dart';
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
      body: Stack(
        children: [
          // 🌲 Scenic Meadow & Forest Trail Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_gameplay.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),

          // Gradient overlay for contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.88),
                    Colors.white.withValues(alpha: 0.65),
                    Colors.white.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Biome Banner Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.primaryContainer, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🌲', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      AppStrings.biomes,
                                      style: AppTypography.titleLarge.copyWith(
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$completedCount/${stages.length} Stages Cleared',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(color: const Color(0xFFFCD34D)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                ),

                // Winding Trail Map Area with 30 Stages & 6 Chapters
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    reverse: true, // Stage 1 at bottom, ascending to Stage 30
                    itemCount: stages.length,
                    itemBuilder: (context, index) {
                      final stage = stages[index];
                      final int stageNum = stage.stageNumber;
                      final bool isCompleted = userProgress.isLevelCompleted(stageNum);
                      final bool isCurrent = stageNum == userProgress.currentLevel;
                      final bool isLocked = !userProgress.isLevelUnlocked(stageNum);
                      final bool isChapterStart = (stageNum - 1) % 5 == 0;

                      // Alternating zigzag winding path offset
                      final double xOffset = (stageNum % 2 == 0) ? 45.0 : -45.0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isChapterStart)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.8), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(stage.speakerEmoji, style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Chapter ${stage.chapterNumber}: ${stage.chapterName}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
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
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
          Text('$stageNumber', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('PLAY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      );
    } else if (isCompleted) {
      bg = const Color(0xFF2E7D32);
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$stageNumber', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 11, color: Color(0xFFFBBF24)),
              Icon(Icons.star_rounded, size: 11, color: Color(0xFFFBBF24)),
              Icon(Icons.star_rounded, size: 11, color: Color(0xFFFBBF24)),
            ],
          ),
        ],
      );
    } else {
      bg = const Color(0xFFE5E7EB);
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_rounded, size: 18, color: Color(0xFF9CA3AF)),
          Text('$stageNumber', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCurrent)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🦊', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Text('Current Level', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                ],
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isCurrent ? 74 : 60,
            height: isCurrent ? 74 : 60,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? Colors.white : (isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFD1D5DB)),
                width: isCurrent ? 3.5 : 2,
              ),
              boxShadow: [
                if (isCurrent)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                else if (isCompleted)
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(child: child),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              stageName,
              style: AppTypography.labelSmall.copyWith(
                color: isLocked ? const Color(0xFF6B7280) : AppColors.primaryDark,
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
