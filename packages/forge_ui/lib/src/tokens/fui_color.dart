import 'package:flutter/widgets.dart';

/// A brightness-aware color token.
///
/// Every semantic color in [FUIColors] carries both a `light` and a `dark`
/// value; widgets resolve the right one against the active [Brightness] via
/// `FUITheme.of(context).resolve(...)`. This keeps call sites free of any
/// `if (isDark)` branching — the token owns both ends of the spectrum.
@immutable
class FUIColor {
  const FUIColor({required this.light, required this.dark});

  /// A token whose value is identical in light and dark.
  const FUIColor.solid(Color value)
      : light = value,
        dark = value;

  final Color light;
  final Color dark;

  Color resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FUIColor && other.light == light && other.dark == dark;

  @override
  int get hashCode => Object.hash(light, dark);
}
