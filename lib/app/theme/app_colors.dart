import 'package:flutter/material.dart';

/// Design tokens extracted directly from Critter Camp Stitch Design System.
class AppColors {
  // Brand & Accent Greens
  static const Color primary = Color(0xFF4A6B46); // Forest Moss Primary
  static const Color primaryLight = Color(0xFF6E9169);
  static const Color primaryDark = Color(0xFF2D4B2A);
  static const Color primaryContainer = Color(0xFFD4E9C4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0F1F09);

  // Secondary Accents
  static const Color secondary = Color(0xFF4D644B);
  static const Color secondaryContainer = Color(0xFFD0EAC9);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Warm Amber & Gold
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color textAccentBrown = Color(0xFF664E31);

  // Camp Cream Backgrounds & Surfaces (Light Theme)
  static const Color background = Color(0xFFFBF9F3);
  static const Color surface = Color(0xFFFBF9F3);
  static const Color surfaceDim = Color(0xFFDCDAD4);
  static const Color surfaceBright = Color(0xFFFBF9F3);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EE);
  static const Color surfaceContainer = Color(0xFFF0EEE8);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E2);
  static const Color surfaceContainerHighest = Color(0xFFE4E2DD);

  // Dark Theme Surfaces
  static const Color darkBackground = Color(0xFF121814);
  static const Color darkSurface = Color(0xFF18221B);
  static const Color darkSurfaceCard = Color(0xFF1F2B23);
  static const Color darkSurfaceCardHover = Color(0xFF28382E);

  // Text & Outline
  static const Color onSurface = Color(0xFF1B1C19);
  static const Color onSurfaceVariant = Color(0xFF444840);
  static const Color outline = Color(0xFF74786F);
  static const Color outlineVariant = Color(0xFFC4C8BD);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // 6 Habitat Region Colors (Used on Puzzle Boards)
  static const Color habitatSage = Color(0xFF748C70);
  static const Color habitatSageLight = Color(0xFFC8DEC6);
  
  static const Color habitatSand = Color(0xFFD9C5B2);
  static const Color habitatSandLight = Color(0xFFF3E7DC);

  static const Color habitatLavender = Color(0xFFB8B5CB);
  static const Color habitatLavenderLight = Color(0xFFE2E0EC);

  static const Color habitatPeach = Color(0xFFF4D9C6);
  static const Color habitatPeachLight = Color(0xFFFDF0E7);

  static const Color habitatTerracotta = Color(0xFFD69E8E);
  static const Color habitatTerracottaLight = Color(0xFFF6D7CF);

  static const Color habitatBlue = Color(0xFFA8B9C0);
  static const Color habitatBlueLight = Color(0xFFDBE5E9);

  // Colorblind / High Contrast Palette
  static const List<Color> habitatPalette = [
    habitatSageLight,
    habitatSandLight,
    habitatLavenderLight,
    habitatPeachLight,
    habitatTerracottaLight,
    habitatBlueLight,
  ];

  static const List<Color> habitatBorderPalette = [
    habitatSage,
    habitatSand,
    habitatLavender,
    habitatPeach,
    habitatTerracotta,
    habitatBlue,
  ];
}
