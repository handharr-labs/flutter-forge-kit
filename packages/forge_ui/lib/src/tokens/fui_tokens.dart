import 'package:flutter/widgets.dart';

import 'fui_color.dart';
import 'fui_colors.dart';
import 'fui_radii.dart';
import 'fui_spacing.dart';
import 'fui_typography.dart';

export 'fui_color.dart';
export 'fui_colors.dart';
export 'fui_icons.dart';
export 'fui_radii.dart';
export 'fui_spacing.dart';
export 'fui_typography.dart';

/// The complete token set for one tier. Components read tokens from the nearest
/// [FUITheme]; brand layers override by supplying a different [FUITokens].
@immutable
class FUITokens {
  const FUITokens({
    required this.colors,
    required this.spacing,
    required this.radii,
    required this.typography,
  });

  final FUIColors colors;
  final FUISpacing spacing;
  final FUIRadii radii;
  final FUITypography typography;

  /// The default base-tier tokens.
  static const FUITokens base = FUITokens(
    colors: FUIColors.base,
    spacing: FUISpacing(),
    radii: FUIRadii(),
    typography: FUITypography(),
  );
}

/// A resolved view of the tokens for the active [Brightness], returned by
/// [FUITheme.of]. Exposes the raw scales plus [resolve] to turn a brightness-
/// aware [FUIColor] into a concrete `Color`.
///
/// ```dart
/// final fui = FUITheme.of(context);
/// final bg = fui.resolve(fui.colors.primary);
/// final pad = fui.spacing.lg;
/// ```
@immutable
class FUIThemeData {
  const FUIThemeData({required this.tokens, required this.brightness});

  final FUITokens tokens;
  final Brightness brightness;

  FUIColors get colors => tokens.colors;
  FUISpacing get spacing => tokens.spacing;
  FUIRadii get radii => tokens.radii;
  FUITypography get typography => tokens.typography;

  bool get isDark => brightness == Brightness.dark;

  /// Resolve a brightness-aware color token against the active brightness.
  Color resolve(FUIColor color) => color.resolve(brightness);
}

/// Inherited tokens. Wrap a subtree in [FUITheme]; read with
/// `FUITheme.of(context)`.
///
/// [brightness] is optional — when null, the theme follows the platform
/// brightness from the ambient [MediaQuery], so a catalog or app can flip
/// light/dark by passing an explicit value.
class FUITheme extends InheritedWidget {
  const FUITheme({
    required this.tokens,
    required super.child,
    this.brightness,
    super.key,
  });

  final FUITokens tokens;
  final Brightness? brightness;

  /// The resolved theme for the active brightness.
  static FUIThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<FUITheme>();
    final tokens = theme?.tokens ?? FUITokens.base;
    final brightness = theme?.brightness ??
        MediaQuery.maybePlatformBrightnessOf(context) ??
        Brightness.light;
    return FUIThemeData(tokens: tokens, brightness: brightness);
  }

  @override
  bool updateShouldNotify(FUITheme oldWidget) =>
      oldWidget.tokens != tokens || oldWidget.brightness != brightness;
}
