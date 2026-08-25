import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class HeartIndicator extends StatelessWidget {
  final int maxHearts;
  final int currentHearts;
  final double size;

  const HeartIndicator({
    super.key,
    this.maxHearts = 3,
    required this.currentHearts,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxHearts, (index) {
        final bool isFull = index < currentHearts;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            isFull ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFull ? const Color(0xFFE11D48) : AppColors.outlineVariant,
            size: size,
          ),
        );
      }),
    );
  }
}
