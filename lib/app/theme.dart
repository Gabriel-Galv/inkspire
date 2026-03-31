import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
class InkColors {
  InkColors._();

  // Primary — violet profundo
  static const primary       = Color(0xFF4A3EAD);
  static const primaryLight  = Color(0xFF6C5FD4);
  static const primaryDark   = Color(0xFF2E2580);
  static const primarySurface = Color(0xFFEDE9FF);

  // Accent — coral cálido
  static const accent        = Color(0xFFE85D3C);
  static const accentLight   = Color(0xFFF5956E);
  static const accentSurface = Color(0xFFFFF0EB);

  // Neutrals
  static const surface       = Color(0xFFF8F7FC);
  static const surfaceCard   = Color(0xFFFFFFFF);
  static const border        = Color(0xFFE8E6F0);
  static const borderStrong  = Color(0xFFD0CDE8);

  // Text
  static const textPrimary   = Color(0xFF0F0E17);
  static const textSecondary = Color(0xFF5B5774);
  static const textHint      = Color(0xFF9B98B0);

  // Semantic
  static const success = Color(0xFF1A936F);
  static const warning = Color(0xFFEF9F27);
  static const error   = Color(0xFFE24B4A);
  static const info    = Color(0xFF378ADD);

  // Reading status
  static const statusWantToRead = Color(0xFF4A3EAD);
  static const statusReading    = Color(0xFF1A936F);
  static const statusFinished   = Color(0xFFEF9F27);
}

// ─── Text Styles ──────────────────────────────────────────────────────────────
class InkTextStyles {
  InkTextStyles._();

  static const _family = 'Nunito';

  static const displayLarge = TextStyle(
    fontFamily: _family, fontSize: 32,
    fontWeight: FontWeight.w800,
    color: InkColors.textPrimary,
    letterSpacing: -0.5, height: 1.2,
  );

  static const displayMedium = TextStyle(
    fontFamily: _family, fontSize: 26,
    fontWeight: FontWeight.w700,
    color: InkColors.textPrimary,
    letterSpacing: -0.3, height: 1.25,
  );

  static const headlineLarge = TextStyle(
    fontFamily: _family, fontSize: 22,
    fontWeight: FontWeight.w700,
    color: InkColors.textPrimary, height: 1.3,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _family, fontSize: 18,
    fontWeight: FontWeight.w600,
    color: InkColors.textPrimary, height: 1.35,
  );

  static const titleLarge = TextStyle(
    fontFamily: _family, fontSize: 16,
    fontWeight: FontWeight.w600,
    color: InkColors.textPrimary, height: 1.4,
  );

  static const titleMedium = TextStyle(
    fontFamily: _family, fontSize: 14,
    fontWeight: FontWeight.w600,
    color: InkColors.textPrimary, height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _family, fontSize: 16,
    fontWeight: FontWeight.w400,
    color: InkColors.textPrimary, height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _family, fontSize: 14,
    fontWeight: FontWeight.w400,
    color: InkColors.textSecondary, height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: _family, fontSize: 12,
    fontWeight: FontWeight.w400,
    color: InkColors.textHint, height: 1.5,
  );

  static const labelLarge = TextStyle(
    fontFamily: _family, fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const labelSmall = TextStyle(
    fontFamily: _family, fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

// ─── Theme ────────────────────────────────────────────────────────────────────
class InkTheme {
  InkTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      colorScheme: ColorScheme.fromSeed(
        seedColor: InkColors.primary,
        brightness: Brightness.light,
        primary: InkColors.primary,
        onPrimary: Colors.white,
        secondary: InkColors.accent,
        onSecondary: Colors.white,
        surface: InkColors.surface,
        onSurface: InkColors.textPrimary,
        error: InkColors.error,
      ),

      scaffoldBackgroundColor: InkColors.surface,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: InkColors.surface,
        foregroundColor: InkColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: InkTextStyles.headlineMedium,
        iconTheme: IconThemeData(color: InkColors.textPrimary),
      ),

      // ── Card ────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: InkColors.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: InkColors.border, width: 0.5),
        ),
      ),

      // ── Input ───────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: InkColors.surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: InkColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: InkColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: InkColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: InkColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: InkColors.error, width: 1.5),
        ),
        hintStyle: InkTextStyles.bodyMedium,
        labelStyle: InkTextStyles.bodyMedium,
        errorStyle: InkTextStyles.bodySmall.copyWith(color: InkColors.error),
      ),

      // ── Elevated Button ──────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: InkColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: InkColors.border,
          disabledForegroundColor: InkColors.textHint,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: InkTextStyles.labelLarge,
          elevation: 0,
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: InkColors.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: InkColors.primary),
          textStyle: InkTextStyles.labelLarge,
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: InkColors.primary,
          textStyle: InkTextStyles.labelLarge,
          minimumSize: const Size(0, 40),
        ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: InkColors.surfaceCard,
        selectedColor: InkColors.primarySurface,
        labelStyle: InkTextStyles.bodyMedium,
        side: const BorderSide(color: InkColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Tab Bar ───────────────────────────────────────────────────────────────
      tabBarTheme: const TabBarThemeData(
        labelColor: InkColors.primary,
        unselectedLabelColor: InkColors.textHint,
        indicatorColor: InkColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: InkTextStyles.titleMedium,
        unselectedLabelStyle: InkTextStyles.bodyMedium,
        dividerColor: InkColors.border,
      ),

      // ── Snackbar ─────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2D2B3D),
        contentTextStyle: InkTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Divider ──────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: InkColors.border,
        thickness: 0.5,
        space: 0,
      ),

      // ── List Tile ────────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: InkColors.primary,
        titleTextStyle: InkTextStyles.titleMedium,
        subtitleTextStyle: InkTextStyles.bodySmall,
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // ── Dialog ───────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: InkColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: InkTextStyles.headlineMedium,
        contentTextStyle: InkTextStyles.bodyMedium,
      ),
    );
  }
}