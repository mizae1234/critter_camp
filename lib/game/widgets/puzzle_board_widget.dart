import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../engine/puzzle_controller.dart';
import '../models/puzzle_cell_state.dart';
import 'puzzle_cell_widget.dart';

class PuzzleBoardWidget extends StatelessWidget {
  final PuzzleController controller;

  const PuzzleBoardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final int n = controller.size;
    final conflicts = controller.conflictingCells;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.outline.withValues(alpha: 0.4),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: n,
                ),
                itemCount: n * n,
                itemBuilder: (context, index) {
                  final int r = index ~/ n;
                  final int c = index % n;
                  final pos = CellPosition(r, c);
                  final habitat = controller.stage.getHabitatAt(r, c);

                  return PuzzleCellWidget(
                    row: r,
                    col: c,
                    content: controller.grid[r][c],
                    habitat: habitat,
                    hasConflict: conflicts.contains(pos),
                    isPatternMode: controller.isPatternMode,
                    onTap: () => controller.handleCellTap(r, c),
                    onLongPress: () => controller.handleCellLongPress(r, c),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
