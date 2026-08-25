import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../data/models/critter_model.dart';
import '../../../game/validator/stage_validation_result.dart';
import '../../../services/ads/ad_policy_service.dart';
import '../../../services/ads/ads_service.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../core/localization/app_strings.dart';

class LevelCompleteScreen extends StatefulWidget {
  final int stageNumber;
  final String stageName;
  final StageValidationResult validationResult;
  final int acornsEarned;
  final String solveTime;
  final CritterModel unlockedCritter;
  final AdPolicyService? adPolicyService;
  final AdsService? adsService;
  final AnalyticsService? analyticsService;
  final void Function(int extraAcorns)? onBonusAcornsClaimed;
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
    this.adPolicyService,
    this.adsService,
    this.analyticsService,
    this.onBonusAcornsClaimed,
    required this.onNextStage,
    required this.onReplay,
    required this.onBackHome,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> {
  bool _bonusClaimed = false;
  bool _isClaiming = false;

  Future<void> _handleNextStage() async {
    final policy = widget.adPolicyService;
    policy?.recordStageCompleted();

    // Evaluate Interstitial Ad eligibility at natural break
    if (policy != null && policy.canShowInterstitial(stageNumber: widget.stageNumber)) {
      widget.analyticsService?.trackInterstitialEligible(stageNumber: widget.stageNumber);
      policy.recordInterstitialShown();
      widget.analyticsService?.trackInterstitialShown(stageNumber: widget.stageNumber);
      if (widget.adsService != null) {
        await widget.adsService!.showInterstitial();
      }
    }

    widget.onNextStage();
  }

  Future<void> _handleClaimBonus() async {
    if (_bonusClaimed || _isClaiming) return;

    setState(() => _isClaiming = true);
    widget.analyticsService?.trackRewardedOffered(placement: 'post_stage');
    widget.analyticsService?.trackRewardedStarted(placement: 'post_stage');

    if (widget.adsService != null) {
      await widget.adsService!.showRewarded(
        onRewarded: () {
          widget.adPolicyService?.recordRewardedCompleted();
          widget.analyticsService?.trackRewardedCompleted(placement: 'post_stage');
          final granted = widget.analyticsService?.trackRewardGranted(
            grantId: 'post_stage_${widget.stageNumber}',
            rewardType: 'acorns_double',
            amount: widget.acornsEarned,
          ) ?? true;

          if (granted) {
            widget.onBonusAcornsClaimed?.call(widget.acornsEarned);
          }

          setState(() {
            _bonusClaimed = true;
            _isClaiming = false;
          });
        },
      );
    } else {
      widget.onBonusAcornsClaimed?.call(widget.acornsEarned);
      setState(() {
        _bonusClaimed = true;
        _isClaiming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int stars = widget.validationResult.starsEarned.clamp(1, 3);
    final bool canOfferBonus = widget.adPolicyService?.canOfferPostStageBonus() ?? true;

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
                width: 84,
                height: 84,
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
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Great Solution!',
                style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Stage ${widget.stageNumber}: ${widget.stageName} Solved',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Stars Row (1 to 3 Stars earned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final bool isLit = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.star_rounded,
                      size: 38,
                      color: isLit ? const Color(0xFFF59E0B) : AppColors.outlineVariant,
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Performance Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('Time', widget.solveTime),
                  const SizedBox(width: 20),
                  _buildStatItem('Reward', '+${widget.acornsEarned * (_bonusClaimed ? 2 : 1)} 🌰'),
                  const SizedBox(width: 20),
                  _buildStatItem('Stars', '$stars / 3 ⭐'),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Unlocked Critter Showcase Card
              CritterCard(
                backgroundColor: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.radiusLg,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    CritterAvatar(
                      emoji: widget.unlockedCritter.emoji,
                      size: 48,
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
                            '${widget.unlockedCritter.name} the ${widget.unlockedCritter.species}',
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            widget.unlockedCritter.title,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Optional Rewarded Ad Bonus Card
              if (canOfferBonus) ...[
                const SizedBox(height: AppSpacing.sm),
                CritterCard(
                  backgroundColor: _bonusClaimed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        _bonusClaimed ? Icons.check_circle_rounded : Icons.card_giftcard_rounded,
                        color: _bonusClaimed ? const Color(0xFF15803D) : const Color(0xFFB45309),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bonusClaimed ? 'Double Acorns Claimed!' : 'Double Your Acorns!',
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _bonusClaimed ? const Color(0xFF15803D) : const Color(0xFF92400E),
                              ),
                            ),
                            Text(
                              _bonusClaimed ? '+${widget.acornsEarned} Acorns added' : 'Watch a video for +${widget.acornsEarned} acorns',
                              style: AppTypography.labelSmall.copyWith(
                                color: _bonusClaimed ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_bonusClaimed)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 16),
                          label: const Text('2x 🌰', style: TextStyle(fontSize: 12)),
                          onPressed: _handleClaimBonus,
                        ),
                    ],
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // Action CTAs
              CritterButton(
                text: AppStrings.nextStage,
                isFullWidth: true,
                icon: Icons.arrow_forward_rounded,
                onPressed: _handleNextStage,
              ),

              const SizedBox(height: AppSpacing.xs),

              Row(
                children: [
                  Expanded(
                    child: CritterButton(
                      text: AppStrings.replayStage,
                      variant: CritterButtonVariant.outline,
                      icon: Icons.replay_rounded,
                      onPressed: widget.onReplay,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CritterButton(
                      text: AppStrings.backToCamp,
                      variant: CritterButtonVariant.ghost,
                      icon: Icons.map_rounded,
                      onPressed: widget.onBackHome,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
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
