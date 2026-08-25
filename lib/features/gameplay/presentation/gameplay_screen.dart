import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/heart_indicator.dart';
import '../../../game/engine/puzzle_controller.dart';
import '../../../game/stage/stage_definition.dart';
import '../../../game/validator/stage_validation_result.dart';
import '../../../game/widgets/puzzle_board_widget.dart';
import '../../../game/widgets/puzzle_toolbar_widget.dart';
import '../../../services/hints/progressive_hint_service.dart';
import '../../../services/ads/ads_service.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/audio/audio_service.dart';
import '../../../core/localization/app_strings.dart';
import '../dialogs/oops_dialog.dart';

class GameplayScreen extends StatefulWidget {
  final StageDefinition stage;
  final ProgressiveHintService? hintService;
  final AdsService? adsService;
  final AnalyticsService? analyticsService;
  final AudioService? audioService;
  final VoidCallback onBack;
  final void Function(StageValidationResult result) onStageCompleted;

  const GameplayScreen({
    super.key,
    required this.stage,
    this.hintService,
    this.adsService,
    this.analyticsService,
    this.audioService,
    required this.onBack,
    required this.onStageCompleted,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late PuzzleController _controller;
  int _hintsUsedOnThisStage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PuzzleController(stage: widget.stage, audioService: widget.audioService);

    widget.analyticsService?.trackStageStarted(
      stageNumber: widget.stage.stageNumber,
      stageName: widget.stage.name,
    );

    _controller.onStageCompleted = (result) {
      widget.analyticsService?.trackStageCompleted(
        stageNumber: widget.stage.stageNumber,
        stars: result.starsEarned,
        moves: _controller.movesCount,
        elapsedSeconds: _controller.elapsedSeconds,
        hintsUsed: _hintsUsedOnThisStage,
      );
      widget.onStageCompleted(result);
    };

    _controller.onWrongMove = () {
      _showOopsDialog();
    };

    _controller.onGameOver = () {
      _showGameOverDialog();
    };
  }

  void _handleHintRequest() {
    if (widget.hintService == null) {
      _controller.useHint();
      return;
    }

    final clue = widget.hintService!.generateClue(
      stage: widget.stage,
      state: _controller.state,
      hintsUsedOnStage: _hintsUsedOnThisStage,
    );

    widget.analyticsService?.trackHintRequested(
      stageNumber: widget.stage.stageNumber,
      hintTier: _hintsUsedOnThisStage + 1,
      isFree: clue.isFree,
    );

    if (clue.isFree) {
      _applyHintClue(clue);
    } else {
      _showRewardedHintOfferDialog(clue);
    }
  }

  void _showRewardedHintOfferDialog(HintClue clue) {
    widget.analyticsService?.trackRewardedOffered(placement: 'hint');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: const Row(
            children: [
              Icon(Icons.video_collection_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Unlock Progressive Clue'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.isThai
                    ? 'คุณใช้คำใบ้ฟรีของด่านนี้แล้ว ดูวิดีโอสั้นเพื่อปลดล็อกคำใบ้ขั้นถัดไป'
                    : 'You used your free stage clue! Watch a short video to unlock the next progressive clue.',
                style: AppTypography.bodyMedium.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: AppColors.accentGold, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${AppStrings.hint}: ${clue.title}',
                        style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancel),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
              label: Text(AppStrings.isThai ? 'ดูวิดีโอรับคำใบ้' : 'Watch Video'),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.analyticsService?.trackRewardedStarted(placement: 'hint');

                if (widget.adsService != null) {
                  await widget.adsService!.showRewarded(
                    onRewarded: () {
                      widget.analyticsService?.trackRewardedCompleted(placement: 'hint');
                      widget.analyticsService?.trackRewardGranted(
                        grantId: 'hint_${widget.stage.stageNumber}_$_hintsUsedOnThisStage',
                        rewardType: 'progressive_hint',
                        amount: 1,
                      );
                      _applyHintClue(clue);
                    },
                  );
                } else {
                  _applyHintClue(clue);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _applyHintClue(HintClue clue) {
    setState(() {
      _hintsUsedOnThisStage++;
    });

    widget.analyticsService?.trackHintUsed(
      stageNumber: widget.stage.stageNumber,
      hintTier: clue.tier.name,
    );

    // If guidance clue with suggestion, apply piece placement
    if (clue.suggestedRow != null && clue.suggestedCol != null) {
      _controller.placeCritterAt(clue.suggestedRow!, clue.suggestedCol!);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.accentGold),
              const SizedBox(width: 8),
              Flexible(child: Text(clue.title, style: AppTypography.titleLarge)),
            ],
          ),
          content: Text(clue.message, style: AppTypography.bodyMedium),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got It!'),
            ),
          ],
        );
      },
    );
  }

  void _showOopsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return OopsDialog(
          errorMessage: _controller.lastError ?? 'Critters cannot touch each other!',
          remainingLives: _controller.lives,
          onUndo: () {
            Navigator.of(context).pop();
            _controller.undo();
          },
          onDismiss: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: const Row(
            children: [
              Icon(Icons.heart_broken_rounded, color: AppColors.error),
              SizedBox(width: 8),
              Text('Out of Hearts!'),
            ],
          ),
          content: const Text(
            'You made 3 mistakes in this grove. Would you like to try this stage again from the start?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.analyticsService?.trackStageAbandoned(stageNumber: widget.stage.stageNumber, reason: 'game_over');
                widget.onBack();
              },
              child: const Text('Quit Stage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.analyticsService?.trackStageRestarted(stageNumber: widget.stage.stageNumber);
                _controller.resetStage();
                setState(() => _hintsUsedOnThisStage = 0);
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cozy Meadow Background
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
            child: Column(
              children: [
                // Top App Bar
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () {
                          widget.analyticsService?.trackStageAbandoned(stageNumber: widget.stage.stageNumber, reason: 'back_pressed');
                          widget.onBack();
                        },
                        tooltip: 'Back',
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Stage ${widget.stage.stageNumber}: ${widget.stage.name}',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${widget.stage.biomeName} • ${widget.stage.size}x${widget.stage.size}',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          if (!_controller.isZenMode) ...[
                            HeartIndicator(currentHearts: _controller.lives),
                            const SizedBox(width: 10),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTimer(_controller.elapsedSeconds),
                                  style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.help_outline_rounded, size: 20, color: AppColors.onSurfaceVariant),
                            tooltip: AppStrings.howToPlay,
                            onPressed: _showRulesModal,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // Goals & Rules Reminder Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.stage.description,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Board Area
            Expanded(
              child: Center(
                child: PuzzleBoardWidget(controller: _controller),
              ),
            ),

            // Controls Toolbar with Progressive Hint Integration
            PuzzleToolbarWidget(
              controller: _controller,
              onCustomHint: _handleHintRequest,
            ),
          ],
        ),
      ),
    ],
  ),
);
  }

  void _showRulesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('📖', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(AppStrings.howToPlayTitle, style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark, fontSize: 16)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRuleItem('1️⃣', AppStrings.rule1Title, AppStrings.rule1Desc),
                const SizedBox(height: 8),
                _buildRuleItem('2️⃣', AppStrings.rule2Title, AppStrings.rule2Desc),
                const SizedBox(height: 8),
                _buildRuleItem('3️⃣', AppStrings.rule3Title, AppStrings.rule3Desc),
                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRuleItem(String emoji, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(desc, style: AppTypography.bodyMedium.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
