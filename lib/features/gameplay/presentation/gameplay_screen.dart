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
import '../dialogs/oops_dialog.dart';

class GameplayScreen extends StatefulWidget {
  final StageDefinition stage;
  final VoidCallback onBack;
  final void Function(StageValidationResult result) onStageCompleted;

  const GameplayScreen({
    super.key,
    required this.stage,
    required this.onBack,
    required this.onStageCompleted,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late PuzzleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PuzzleController(stage: widget.stage);

    _controller.onStageCompleted = (result) {
      widget.onStageCompleted(result);
    };

    _controller.onWrongMove = () {
      _showOopsDialog();
    };

    _controller.onGameOver = () {
      _showGameOverDialog();
    };
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
                widget.onBack();
              },
              child: const Text('Quit Stage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.resetStage();
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
      body: SafeArea(
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
                        onPressed: widget.onBack,
                        tooltip: 'Back',
                      ),
                      Column(
                        children: [
                          Text(
                            'Stage ${widget.stage.stageNumber}: ${widget.stage.name}',
                            style: AppTypography.titleLarge,
                          ),
                          Text(
                            '${widget.stage.biomeName} • ${widget.stage.size}x${widget.stage.size}',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                          ),
                        ],
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

            // Controls Toolbar
            PuzzleToolbarWidget(controller: _controller),
          ],
        ),
      ),
    );
  }
}
