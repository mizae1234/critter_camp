import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class CritterAvatar extends StatelessWidget {
  final String? name;
  final String? emoji;
  final IconData? icon;
  final double size;
  final Color? backgroundColor;
  final bool isUnlocked;

  const CritterAvatar({
    super.key,
    this.name,
    this.emoji,
    this.icon,
    this.size = 48,
    this.backgroundColor,
    this.isUnlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isUnlocked 
            ? (backgroundColor ?? AppColors.habitatSageLight)
            : AppColors.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: Border.all(
          color: isUnlocked 
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      child: Center(
        child: !isUnlocked
            ? Icon(Icons.lock_rounded, size: size * 0.45, color: AppColors.outline)
            : emoji != null
                ? Text(
                    emoji!,
                    style: TextStyle(fontSize: size * 0.5),
                  )
                : Icon(
                    icon ?? Icons.cruelty_free_rounded,
                    size: size * 0.5,
                    color: AppColors.primaryDark,
                  ),
      ),
    );
  }
}
