import 'package:flutter/widgets.dart';

import 'fui_color.dart';

/// The semantic color palette. Each entry is a brightness-aware [FUIColor];
/// widgets never reach for raw `Color` literals — they read a named role here
/// and resolve it against the active [Brightness].
///
/// Brand layers (future Bronze/Silver/Gold) override by supplying a different
/// [FUIColors] to [FUITokens]; component code stays untouched.
@immutable
class FUIColors {
  const FUIColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryHover,
    required this.primarySubtle,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.overlay,
    required this.onSurface,
    required this.textSecondary,
    required this.textSubtle,
    required this.disabled,
    required this.onDisabled,
    required this.border,
    required this.borderStrong,
    required this.focusRing,
    required this.success,
    required this.onSuccess,
    required this.successSubtle,
    required this.warning,
    required this.onWarning,
    required this.warningSubtle,
    required this.danger,
    required this.onDanger,
    required this.dangerSubtle,
    required this.info,
    required this.onInfo,
    required this.infoSubtle,
  });

  // Brand.
  final FUIColor primary;
  final FUIColor onPrimary;
  final FUIColor primaryHover;
  final FUIColor primarySubtle;

  // Surfaces.
  final FUIColor background;
  final FUIColor surface;
  final FUIColor surfaceVariant;
  final FUIColor overlay;

  // Content.
  final FUIColor onSurface;
  final FUIColor textSecondary;
  final FUIColor textSubtle;
  final FUIColor disabled;
  final FUIColor onDisabled;

  // Lines.
  final FUIColor border;
  final FUIColor borderStrong;
  final FUIColor focusRing;

  // Status — success.
  final FUIColor success;
  final FUIColor onSuccess;
  final FUIColor successSubtle;

  // Status — warning.
  final FUIColor warning;
  final FUIColor onWarning;
  final FUIColor warningSubtle;

  // Status — danger.
  final FUIColor danger;
  final FUIColor onDanger;
  final FUIColor dangerSubtle;

  // Status — info.
  final FUIColor info;
  final FUIColor onInfo;
  final FUIColor infoSubtle;

  /// The default base-tier palette. Forge blue (`0xFF2D6CDF`) anchors the
  /// brand. Values are our own — not mirrored from any other system.
  static const FUIColors base = FUIColors(
    // Brand.
    primary: FUIColor(light: Color(0xFF2D6CDF), dark: Color(0xFF5B8DEF)),
    onPrimary: FUIColor.solid(Color(0xFFFFFFFF)),
    primaryHover: FUIColor(light: Color(0xFF2459BC), dark: Color(0xFF7AA4F2)),
    primarySubtle: FUIColor(light: Color(0xFFEAF1FD), dark: Color(0xFF1B2B45)),

    // Surfaces.
    background: FUIColor(light: Color(0xFFF6F7F9), dark: Color(0xFF0E1116)),
    surface: FUIColor(light: Color(0xFFFFFFFF), dark: Color(0xFF171B21)),
    surfaceVariant: FUIColor(light: Color(0xFFF1F3F5), dark: Color(0xFF21262E)),
    overlay: FUIColor(light: Color(0x99000000), dark: Color(0xB3000000)),

    // Content.
    onSurface: FUIColor(light: Color(0xFF1A1D21), dark: Color(0xFFE9ECEF)),
    textSecondary: FUIColor(light: Color(0xFF565E68), dark: Color(0xFFADB5BD)),
    textSubtle: FUIColor(light: Color(0xFF868E96), dark: Color(0xFF6C757D)),
    disabled: FUIColor(light: Color(0xFFE4E7EB), dark: Color(0xFF2B313A)),
    onDisabled: FUIColor(light: Color(0xFFAAB1B9), dark: Color(0xFF5A626C)),

    // Lines.
    border: FUIColor(light: Color(0xFFE0E3E7), dark: Color(0xFF2B313A)),
    borderStrong: FUIColor(light: Color(0xFFC4C9D0), dark: Color(0xFF3C434E)),
    focusRing: FUIColor(light: Color(0x4D2D6CDF), dark: Color(0x665B8DEF)),

    // Status — success.
    success: FUIColor(light: Color(0xFF1F9254), dark: Color(0xFF34C77B)),
    onSuccess: FUIColor.solid(Color(0xFFFFFFFF)),
    successSubtle: FUIColor(light: Color(0xFFE7F6ED), dark: Color(0xFF13301F)),

    // Status — warning.
    warning: FUIColor(light: Color(0xFFB8860B), dark: Color(0xFFE0A82E)),
    onWarning: FUIColor.solid(Color(0xFF1A1D21)),
    warningSubtle: FUIColor(light: Color(0xFFFBF3E0), dark: Color(0xFF332A12)),

    // Status — danger.
    danger: FUIColor(light: Color(0xFFD64545), dark: Color(0xFFF06A6A)),
    onDanger: FUIColor.solid(Color(0xFFFFFFFF)),
    dangerSubtle: FUIColor(light: Color(0xFFFCEAEA), dark: Color(0xFF3A1B1B)),

    // Status — info.
    info: FUIColor(light: Color(0xFF2D6CDF), dark: Color(0xFF5B8DEF)),
    onInfo: FUIColor.solid(Color(0xFFFFFFFF)),
    infoSubtle: FUIColor(light: Color(0xFFEAF1FD), dark: Color(0xFF1B2B45)),
  );
}
