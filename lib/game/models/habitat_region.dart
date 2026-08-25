import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum HabitatPattern {
  solid,
  dots,
  stripes,
  crosshatch,
  waves,
  diagonal,
}

class HabitatRegion {
  final int id;
  final String name;
  final String labelLetter; // A, B, C, D, E, F (Colorblind support)
  final Color baseColor;
  final Color borderColor;
  final HabitatPattern pattern;

  const HabitatRegion({
    required this.id,
    required this.name,
    required this.labelLetter,
    required this.baseColor,
    required this.borderColor,
    this.pattern = HabitatPattern.solid,
  });

  static HabitatRegion byIndex(int index) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    const names = ['Sage Meadow', 'Sand Dune', 'Lavender Hollow', 'Peach Grove', 'Terracotta Ridge', 'Blue Lake', 'Mossy Glen', 'Golden Peak'];
    
    final int colorIdx = index % AppColors.habitatPalette.length;
    final patterns = HabitatPattern.values;

    return HabitatRegion(
      id: index,
      name: index < names.length ? names[index] : 'Region ${letters[index % letters.length]}',
      labelLetter: index < letters.length ? letters[index] : '#$index',
      baseColor: AppColors.habitatPalette[colorIdx],
      borderColor: AppColors.habitatBorderPalette[colorIdx],
      pattern: patterns[index % patterns.length],
    );
  }
}
