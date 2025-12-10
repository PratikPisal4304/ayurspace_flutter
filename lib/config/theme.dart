import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'design_tokens.dart';

/// App Theme Configuration
/// Defines the complete visual theme for AyurSpace
class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      bottomNavigationBarTheme: _bottomNavTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _chipTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  // Color Scheme
  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.saffron,
      surface: AppColors.surface,
      error: AppColors.error,
      brightness: Brightness.light,
    ).copyWith(
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      tertiary: AppColors.lotusPink,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onError: AppColors.textOnPrimary,
      outline: AppColors.border,
      surfaceTint: Colors.white,
      shadow: AppColors.textPrimary.withValues(alpha: 0.05),
    );
  }

  // Text Theme
  static TextTheme get _textTheme {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeHero,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeDisplay,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXxxl,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXxl,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      ),
    );
  }

  // AppBar Theme
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: DesignTokens.iconSizeMd,
      ),
    );
  }

  // Card Theme
  static CardThemeData get _cardTheme {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLg,
          vertical: DesignTokens.spacingSm,
        ),
        minimumSize: const Size(0, DesignTokens.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: DesignTokens.fontSizeBase,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Outlined Button Theme
  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLg,
          vertical: DesignTokens.spacingSm,
        ),
        minimumSize: const Size(0, DesignTokens.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: DesignTokens.fontSizeBase,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Text Button Theme
  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingXs,
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: DesignTokens.fontSizeBase,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      hintStyle: GoogleFonts.outfit(
        color: AppColors.textTertiary,
        fontSize: DesignTokens.fontSizeBase,
      ),
    );
  }

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get _bottomNavTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // FAB Theme
  static FloatingActionButtonThemeData get _fabTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    );
  }

  // Chip Theme
  static ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        color: AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXxs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
    );
  }
}
