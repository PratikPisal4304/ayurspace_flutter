import 'package:flutter/material.dart';

/// Sacred Ayurvedic Color Palette
/// Inspired by traditional Ayurvedic elements and nature
class AppColors {
  AppColors._();

  // Primary Colors - Growth, Healing, Nature
  static const Color primary = Color(0xFF16a34a);
  static const Color tulsiGreen = Color(0xFF16a34a);
  static const Color neemGreen = Color(0xFF15803d);
  static const Color primaryLight = Color(0xFF22c55e);
  static const Color primaryDark = Color(0xFF166534);

  // Secondary Colors - Energy, Vitality
  static const Color saffron = Color(0xFFf97316);
  static const Color turmeric = Color(0xFFeab308);
  static const Color lotusPink = Color(0xFFec4899);

  // Dosha Colors
  static const Color vata = Color(0xFF60a5fa); // Air - Light Blue
  static const Color pitta = Color(0xFFf87171); // Fire - Warm Red
  static const Color kapha = Color(0xFF4ade80); // Earth - Green

  // Neutral Tones
  static const Color earthBrown = Color(0xFF78716c);
  static const Color stoneGray = Color(0xFF737373);
  static const Color cream = Color(0xFFFAFAF9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============ LIGHT THEME COLORS ============
  // Background Colors
  static const Color background = Color(0xFFFAFAF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F4);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textTertiary = Color(0xFF78716C);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE7E5E4);
  static const Color divider = Color(0xFFE7E5E4);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // ============ DARK THEME COLORS ============
  // Dark Background Colors
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceVariantDark = Color(0xFF262626);

  // Dark Text Colors
  static const Color textPrimaryDark = Color(0xFFF5F5F4);
  static const Color textSecondaryDark = Color(0xFFA8A29E);
  static const Color textTertiaryDark = Color(0xFF78716C);

  // Dark Border & Divider
  static const Color borderDark = Color(0xFF3D3D3D);
  static const Color dividerDark = Color(0xFF3D3D3D);

  // Dark Shadow
  static const Color shadowDark = Color(0x40000000);

  // Status Colors (same for both themes)
  static const Color success = Color(0xFF22c55e);
  static const Color warning = Color(0xFFf59e0b);
  static const Color error = Color(0xFFef4444);
  static const Color info = Color(0xFF3b82f6);

  // Difficulty Colors
  static const Color easy = Color(0xFF22c55e);
  static const Color medium = Color(0xFFf59e0b);
  static const Color hard = Color(0xFFef4444);

  /// Get color for dosha type
  static Color getDoshaColor(String dosha) {
    switch (dosha.toLowerCase()) {
      case 'vata':
        return vata;
      case 'pitta':
        return pitta;
      case 'kapha':
        return kapha;
      default:
        return primary;
    }
  }

  /// Get color for difficulty level
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return easy;
      case 'medium':
        return medium;
      case 'hard':
        return hard;
      default:
        return stoneGray;
    }
  }
}

