import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';

class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD5), // Warm Orange Tint
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: const Color(0xFFFDBA74), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFEA580C),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays Days',
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFF9A3412),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class AcornBadge extends StatelessWidget {
  final int acorns;

  const AcornBadge({super.key, required this.acorns});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7), // Warm Yellow Tint
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFD97706),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$acorns',
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFF92400E),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
