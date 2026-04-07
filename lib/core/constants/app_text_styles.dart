import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles following Academic Pulse design system
/// Display & Headlines: Manrope (architectural, bold)
/// Body & Labels: Inter (maximum legibility)
class AppTextStyles {
  AppTextStyles._();

  // ========== DISPLAY STYLES (Manrope) ==========

  /// Display Large - 3.5rem / 56px
  /// Usage: Hero sections, major page headers
  static TextStyle displayLarge = GoogleFonts.manrope(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );

  /// Display Medium - 2.75rem / 44px
  /// Usage: Big numbers, student tallies, editorial metrics
  static TextStyle displayMedium = GoogleFonts.manrope(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.25,
    color: AppColors.onSurface,
  );

  /// Display Small - 2.25rem / 36px
  static TextStyle displaySmall = GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  // ========== HEADLINE STYLES (Manrope) ==========

  /// Headline Large - 2rem / 32px
  /// Usage: Metric values in dashboard cards
  static TextStyle headlineLarge = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  /// Headline Medium - 1.75rem / 28px
  /// Usage: Section headers, card titles
  static TextStyle headlineMedium = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  /// Headline Small - 1.5rem / 24px
  /// Usage: Subsection headers
  static TextStyle headlineSmall = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  // ========== TITLE STYLES (Inter) ==========

  /// Title Large - 1.375rem / 22px
  /// Usage: AppBar titles, dialog headers
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  /// Title Medium - 1rem / 16px
  /// Usage: List item titles, form section headers
  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
  );

  /// Title Small - 0.875rem / 14px
  /// Usage: Dense list titles, compact headers
  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  // ========== BODY STYLES (Inter) ==========

  /// Body Large - 1rem / 16px
  /// Usage: Main content text, descriptions
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  /// Body Medium - 0.875rem / 14px
  /// Usage: List item descriptions, secondary content
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.onSurfaceVariant,
  );

  /// Body Small - 0.75rem / 12px
  /// Usage: Captions, helper text
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  // ========== LABEL STYLES (Inter) ==========

  /// Label Large - 0.875rem / 14px
  /// Usage: Button text, emphasized labels
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  /// Label Medium - 0.75rem / 12px
  /// Usage: Form labels, metric descriptions
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  /// Label Small - 0.6875rem / 11px
  /// Usage: Status badges, tags, timestamps
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
  );

  /// Label Small Caps - 0.6875rem / 11px
  /// Usage: Editorial caps for status labels (LOCKED/OPEN/DONE)
  /// The "Editorial Cap" - professional, tag-like feel
  static TextStyle labelSmallCaps = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.8,
    color: AppColors.onSurfaceVariant,
  ).copyWith(fontFeatures: [const FontFeature.enable('smcp')]);

  // ========== HELPER METHODS ==========

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply variant color (for secondary text)
  static TextStyle asVariant(TextStyle style) {
    return style.copyWith(color: AppColors.onSurfaceVariant);
  }

  /// Apply tertiary color (for least emphasized text)
  static TextStyle asTertiary(TextStyle style) {
    return style.copyWith(color: AppColors.onSurfaceTertiary);
  }

  /// Apply primary color
  static TextStyle asPrimary(TextStyle style) {
    return style.copyWith(color: AppColors.primary);
  }

  /// Apply error color
  static TextStyle asError(TextStyle style) {
    return style.copyWith(color: AppColors.error);
  }

  /// Apply success color
  static TextStyle asSuccess(TextStyle style) {
    return style.copyWith(color: AppColors.success);
  }

  /// Make text bold
  static TextStyle asBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Make text semibold
  static TextStyle asSemiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Make text medium weight
  static TextStyle asMedium(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w500);
  }
}
