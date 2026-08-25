import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../engine/puzzle_controller.dart';

class PuzzleToolbarWidget extends StatelessWidget {
  final PuzzleController controller;
  final VoidCallback? onCustomHint;

  const PuzzleToolbarWidget({
    super.key,
    required this.controller,
    this.onCustomHint,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tool Mode Toggles
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildToolButton(
                      icon: Icons.close_rounded,
                      label: 'X Mark',
                      isSelected: controller.selectedTool == ToolMode.markX,
                      onTap: () => controller.selectTool(ToolMode.markX),
                    ),
                    const SizedBox(width: 4),
                    _buildToolButton(
                      icon: Icons.pets_rounded,
                      label: 'Critter',
                      isSelected: controller.selectedTool == ToolMode.placeCritter,
                      onTap: () => controller.selectTool(ToolMode.placeCritter),
                    ),
                  ],
                ),
              ),

              // Action Buttons: Undo & Hint
              Row(
                children: [
                  // Pattern Mode Accessibility Toggle
                  IconButton(
                    onPressed: controller.togglePatternMode,
                    icon: Icon(
                      controller.isPatternMode ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: controller.isPatternMode ? AppColors.primary : AppColors.outline,
                    ),
                    tooltip: 'Toggle Colorblind Patterns',
                  ),

                  // Undo Button
                  IconButton(
                    onPressed: controller.canUndo ? controller.undo : null,
                    icon: Icon(
                      Icons.undo_rounded,
                      color: controller.canUndo ? AppColors.onSurface : AppColors.outlineVariant,
                    ),
                    tooltip: 'Undo Move',
                  ),

                  // Hint Button with badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.hintsRemaining > 0
                            ? () {
                                if (onCustomHint != null) {
                                  onCustomHint!();
                                } else {
                                  controller.useHint();
                                }
                              }
                            : null,
                        icon: const Icon(Icons.lightbulb_rounded, size: 18, color: AppColors.accentGold),
                        label: const Text('Hint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.onSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            side: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${controller.hintsRemaining}',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
