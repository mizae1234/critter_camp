import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';

enum CritterButtonVariant { primary, secondary, outline, ghost }

class CritterButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CritterButtonVariant variant;
  final bool isFullWidth;
  final double? height;

  const CritterButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = CritterButtonVariant.primary,
    this.isFullWidth = false,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case CritterButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.onPrimary;
        break;
      case CritterButtonVariant.secondary:
        bg = AppColors.secondaryContainer;
        fg = AppColors.primaryDark;
        break;
      case CritterButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.primary;
        border = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case CritterButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.onSurfaceVariant;
        break;
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTypography.labelLarge.copyWith(color: fg),
        ),
      ],
    );

    Widget button = SizedBox(
      height: height,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          side: border,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: content,
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
