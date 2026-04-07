/// Dimensions & Spacing following Academic Pulse design system
/// Uses 4px base unit system for consistent rhythm
class AppDimensions {
  AppDimensions._();

  // ========== SPACING SCALE (4px base unit) ==========

  /// 4px - Minimal spacing, tight grouping
  static const double spacing1 = 4.0;

  /// 8px - Compact spacing, related elements
  static const double spacing2 = 8.0;

  /// 12px - Small spacing, form fields
  static const double spacing3 = 12.0;

  /// 16px - Base spacing unit, standard gap
  static const double spacing4 = 16.0;

  /// 20px - Medium spacing, section separation
  static const double spacing5 = 20.0;

  /// 24px - Large spacing, major sections
  static const double spacing6 = 24.0;

  /// 32px - Extra large spacing, page sections
  static const double spacing8 = 32.0;

  /// 40px - Huge spacing, hero sections
  static const double spacing10 = 40.0;

  /// 48px - Maximum spacing, major page divisions
  static const double spacing12 = 48.0;

  /// 64px - Extra maximum spacing, hero sections
  static const double spacing16 = 64.0;

  // ========== BORDER RADIUS ==========

  /// 2px - Minimal radius, status badges (systematic formal look)
  static const double radiusXs = 2.0;

  /// 4px - Small radius, compact elements
  static const double radiusSm = 4.0;

  /// 8px - Base radius, cards, buttons
  static const double radiusMd = 8.0;

  /// 12px - Medium radius, larger cards
  static const double radiusLg = 12.0;

  /// 16px - Large radius, modals, sheets
  static const double radiusXl = 16.0;

  /// 24px - Extra large radius, hero cards
  static const double radius2xl = 24.0;

  /// 999px - Full rounded, pills, accent bars
  static const double radiusFull = 999.0;

  // ========== ELEVATION (Shadow Blur Radius) ==========

  /// No elevation - flat surface
  static const double elevation0 = 0.0;

  /// 8px blur - Subtle lift for hover states
  static const double elevation1 = 8.0;

  /// 16px blur - Cards with slight elevation
  static const double elevation2 = 16.0;

  /// 24px blur - Floating cards (Academic Pulse standard)
  /// Y offset: 8px, Color: rgba(0, 64, 161, 0.06) - blue tinted
  static const double elevation3 = 24.0;

  /// 32px blur - Dialogs, bottom sheets
  static const double elevation4 = 32.0;

  /// 48px blur - Maximum elevation, modals
  static const double elevation5 = 48.0;

  // ========== ICON SIZES ==========

  /// 16px - Small icons, inline with text
  static const double iconXs = 16.0;

  /// 20px - Base icon size, list items
  static const double iconSm = 20.0;

  /// 24px - Standard icon size, buttons, app bar
  static const double iconMd = 24.0;

  /// 32px - Large icons, feature cards
  static const double iconLg = 32.0;

  /// 48px - Extra large icons, hero sections
  static const double iconXl = 48.0;

  /// 64px - Huge icons, empty states
  static const double icon2xl = 64.0;

  // ========== COMPONENT DIMENSIONS ==========

  /// Button height (Medium)
  static const double buttonHeightMd = 48.0;

  /// Button height (Large)
  static const double buttonHeightLg = 56.0;

  /// Button height (Small)
  static const double buttonHeightSm = 40.0;

  /// Input field height
  static const double inputHeight = 48.0;

  /// AppBar height
  static const double appBarHeight = 56.0;

  /// Bottom navigation height
  static const double bottomNavHeight = 64.0;

  /// FAB size (Regular)
  static const double fabSize = 56.0;

  /// FAB size (Small)
  static const double fabSizeSmall = 48.0;

  /// FAB size (Large)
  static const double fabSizeLarge = 64.0;

  /// Avatar size (Small)
  static const double avatarSm = 32.0;

  /// Avatar size (Medium)
  static const double avatarMd = 40.0;

  /// Avatar size (Large)
  static const double avatarLg = 56.0;

  /// Avatar size (Extra Large)
  static const double avatarXl = 80.0;

  /// The Accent Bar width (vertical pill on card left edge)
  static const double accentBarWidth = 4.0;

  /// Ghost border width (15% opacity outline)
  static const double ghostBorderWidth = 1.0;

  // ========== BACKDROP BLUR ==========

  /// Light blur for glassmorphism effects
  static const double blurLight = 12.0;

  /// Medium blur for bottom sheets
  static const double blurMedium = 16.0;

  /// Heavy blur for modals and overlays
  static const double blurHeavy = 20.0;

  // ========== ANIMATION DURATIONS (milliseconds) ==========

  /// Fast animation (150ms) - micro-interactions
  static const int animationFast = 150;

  /// Normal animation (250ms) - standard transitions
  static const int animationNormal = 250;

  /// Slow animation (350ms) - page transitions
  static const int animationSlow = 350;

  /// Very slow animation (500ms) - hero animations
  static const int animationVerySlow = 500;

  // ========== MAX WIDTHS (Responsive Design) ==========

  /// Mobile breakpoint
  static const double breakpointMobile = 600.0;

  /// Tablet breakpoint
  static const double breakpointTablet = 900.0;

  /// Desktop breakpoint
  static const double breakpointDesktop = 1200.0;

  /// Max content width for large screens
  static const double maxContentWidth = 1440.0;

  /// Max form width (login, centered forms)
  static const double maxFormWidth = 400.0;

  /// Max card width (content cards)
  static const double maxCardWidth = 600.0;

  // ========== PAGE PADDING ==========

  /// Mobile horizontal padding
  static const double pagePaddingMobile = 16.0;

  /// Tablet horizontal padding
  static const double pagePaddingTablet = 24.0;

  /// Desktop horizontal padding
  static const double pagePaddingDesktop = 32.0;

  /// Safe area bottom padding (for bottom sheets)
  static const double safeAreaBottomPadding = 16.0;
}
