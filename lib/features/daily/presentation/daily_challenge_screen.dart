import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';

class DailyChallengeScreen extends StatelessWidget {
  final VoidCallback onPlayDaily;

  const DailyChallengeScreen({super.key, required this.onPlayDaily});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ⛺ Cozy Campsite Background
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
                  // Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.dailyChallengeTitle,
                            style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontSize: 20),
                          ),
                          Text(
                            AppStrings.dailyChallenge,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD5),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '14 Days',
                              style: AppTypography.labelSmall.copyWith(color: const Color(0xFF9A3412), fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Today's Feature Challenge Card
                  CritterCard(
                    backgroundColor: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.radiusLg,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                'TODAY\'S SPECIAL',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.accentGold, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const Text('⏱️ 14h 22m', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        Text(
                          'The River Grove',
                          style: AppTypography.headlineLarge,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          AppStrings.dailyChallengeSub,
                          style: AppTypography.bodyMedium,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        Row(
                          children: [
                            _buildBadge(Icons.grid_4x4_rounded, '6x6 Grid'),
                            const SizedBox(width: 8),
                            _buildBadge(Icons.star_rounded, AppStrings.rewardAcorns),
                            const SizedBox(width: 8),
                            _buildBadge(Icons.emoji_events_rounded, AppStrings.leaderboard),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        CritterButton(
                          text: AppStrings.playDailyChallenge,
                          isFullWidth: true,
                          icon: Icons.play_arrow_rounded,
                          onPressed: onPlayDaily,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Monthly Streak Mini Calendar
                  Text(AppStrings.dailyStreak, style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.sm),

                  CritterCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text('M', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('T', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('W', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('T', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('F', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('S', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                            Text('S', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.outline)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(28, (index) {
                            final day = index + 1;
                            final isDone = day < 25;
                            final isToday = day == 25;

                            return Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppColors.primary
                                    : isDone
                                        ? AppColors.primaryContainer
                                        : AppColors.surfaceContainerHigh,
                                shape: BoxShape.circle,
                                border: isToday ? Border.all(color: AppColors.primaryLight, width: 2) : null,
                              ),
                              child: Center(
                                child: isDone
                                    ? const Icon(Icons.check_rounded, size: 16, color: AppColors.primaryDark)
                                    : Text(
                                        '$day',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                                          color: isToday ? Colors.white : AppColors.onSurfaceVariant,
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
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

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.labelSmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
