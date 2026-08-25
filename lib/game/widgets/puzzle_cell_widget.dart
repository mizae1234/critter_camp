import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../models/puzzle_cell_state.dart';
import '../models/habitat_region.dart';

class PuzzleCellWidget extends StatelessWidget {
  final int row;
  final int col;
  final CellContent content;
  final HabitatRegion habitat;
  final bool hasConflict;
  final bool isPatternMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PuzzleCellWidget({
    super.key,
    required this.row,
    required this.col,
    required this.content,
    required this.habitat,
    required this.hasConflict,
    required this.isPatternMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Color cellBg = habitat.baseColor;
    if (hasConflict) {
      cellBg = const Color(0xFFFFCDD2); // Red conflict tint
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: cellBg,
          border: Border.all(
            color: hasConflict 
                ? AppColors.error 
                : habitat.borderColor.withValues(alpha: 0.3),
            width: hasConflict ? 2.0 : 0.8,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Colorblind Letter Tag (Pattern Mode)
            if (isPatternMode)
              Positioned(
                top: 2,
                left: 3,
                child: Text(
                  habitat.labelLetter,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: habitat.borderColor.withValues(alpha: 0.7),
                  ),
                ),
              ),

            // Cell Content
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (content) {
      case CellContent.critter:
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          builder: (context, val, child) {
            return Transform.scale(
              scale: val,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets_rounded, // Critter icon matching Stitch
                  color: AppColors.primaryDark,
                  size: 22,
                ),
              ),
            );
          },
        );

      case CellContent.xMark:
        return const Icon(
          Icons.close_rounded,
          color: Color(0xFF6B7280),
          size: 20,
        );

      case CellContent.empty:
        return const SizedBox.shrink();
    }
  }
}
