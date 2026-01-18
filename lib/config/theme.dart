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
      textTheme: _lightTextTheme,
      appBarTheme: _lightAppBarTheme,
      cardTheme: _lightCardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      bottomNavigationBarTheme: _lightBottomNavTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _lightChipTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _darkTextTheme,
      appBarTheme: _darkAppBarTheme,
      cardTheme: _darkCardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      bottomNavigationBarTheme: _darkBottomNavTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _darkChipTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
    );
  }

  // ============ LIGHT THEME COMPONENTS ============

  // Light Color Scheme
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

  // Light Text Theme
  static TextTheme get _lightTextTheme {
    return _buildTextTheme(
      primaryColor: AppColors.textPrimary,
      secondaryColor: AppColors.textSecondary,
      tertiaryColor: AppColors.textTertiary,
    );
  }

  // Light AppBar Theme
  static AppBarTheme get _lightAppBarTheme {
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

  // Light Card Theme
  static CardThemeData get _lightCardTheme {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    );
  }

  // Light Input Decoration Theme
  static InputDecorationTheme get _lightInputDecorationTheme {
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

  // Light Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get _lightBottomNavTheme {
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

  // Light Chip Theme
  static ChipThemeData get _lightChipTheme {
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

  // ============ DARK THEME COMPONENTS ============

  // Dark Color Scheme
  static ColorScheme get _darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primaryLight,
      secondary: AppColors.saffron,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      brightness: Brightness.dark,
    ).copyWith(
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textOnPrimary,
      tertiary: AppColors.lotusPink,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      onError: AppColors.textOnPrimary,
      outline: AppColors.borderDark,
      surfaceTint: AppColors.surfaceDark,
      shadow: AppColors.shadowDark,
    );
  }

  // Dark Text Theme
  static TextTheme get _darkTextTheme {
    return _buildTextTheme(
      primaryColor: AppColors.textPrimaryDark,
      secondaryColor: AppColors.textSecondaryDark,
      tertiaryColor: AppColors.textTertiaryDark,
    );
  }

  // Dark AppBar Theme
  static AppBarTheme get _darkAppBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: DesignTokens.iconSizeMd,
      ),
    );
  }

  // Dark Card Theme
  static CardThemeData get _darkCardTheme {
    return CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 2,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    );
  }

  // Dark Outlined Button Theme
  static OutlinedButtonThemeData get _darkOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
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

  // Dark Input Decoration Theme
  static InputDecorationTheme get _darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariantDark,
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
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      hintStyle: GoogleFonts.outfit(
        color: AppColors.textTertiaryDark,
        fontSize: DesignTokens.fontSizeBase,
      ),
    );
  }

  // Dark Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get _darkBottomNavTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textTertiaryDark,
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

  // Dark Chip Theme
  static ChipThemeData get _darkChipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceVariantDark,
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        color: AppColors.textPrimaryDark,
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

  // ============ SHARED COMPONENTS ============

  // Elevated Button Theme (shared)
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

  // Outlined Button Theme (shared - light)
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

  // Text Button Theme (shared)
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

  // FAB Theme (shared)
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

  // ============ HELPER METHODS ============

  /// Build text theme with specified colors
  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
    required Color tertiaryColor,
  }) {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeHero,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeDisplay,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXxxl,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXxl,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w400,
        color: tertiaryColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiaryColor,
      ),
    );
  }
}

