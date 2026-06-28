import 'package:flutter/widgets.dart';

/// Design tokens for the single base tier. Components read from the nearest
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

  /// The default base-tier palette and scale.
  static const FUITokens base = FUITokens(
    colors: FUIColors(
      primary: Color(0xFF2D6CDF),
      onPrimary: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1A1A1A),
      danger: Color(0xFFD64545),
    ),
    spacing: FUISpacing(),
    radii: FUIRadii(),
    typography: FUITypography(),
  );
}

@immutable
class FUIColors {
  const FUIColors({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.danger,
  });

  final Color primary;
  final Color onPrimary;
  final Color surface;
  final Color onSurface;
  final Color danger;
}

@immutable
class FUISpacing {
  const FUISpacing();
  final double xs = 4;
  final double sm = 8;
  final double md = 16;
  final double lg = 24;
  final double xl = 32;
}

@immutable
class FUIRadii {
  const FUIRadii();
  final double sm = 6;
  final double md = 12;
  final double lg = 20;
}

@immutable
class FUITypography {
  const FUITypography();
  final TextStyle button =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}

/// Inherited tokens. Wrap an app subtree in [FUITheme] and read with
/// `FUITheme.of(context)`.
class FUITheme extends InheritedWidget {
  const FUITheme({
    required this.tokens,
    required super.child,
    super.key,
  });

  final FUITokens tokens;

  static FUITokens of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<FUITheme>();
    return theme?.tokens ?? FUITokens.base;
  }

  @override
  bool updateShouldNotify(FUITheme oldWidget) => oldWidget.tokens != tokens;
}
