import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// Icon size scale. The kit ships no icon assets of its own — pass any
/// [IconData] (Material icons, a custom font) and [FUIIcon] handles token-driven
/// color and a consistent size.
enum FUIIconSize {
  sm(16),
  md(20),
  lg(24);

  const FUIIconSize(this.px);

  final double px;
}

/// A token-colored icon. Defaults to the `onSurface` content color; pass a
/// [FUIColor] token to tint it (e.g. `fui.colors.primary`) so it stays correct
/// in both light and dark.
class FUIIcon extends StatelessWidget {
  const FUIIcon(
    this.icon, {
    this.size = FUIIconSize.md,
    this.color,
    super.key,
  });

  final IconData icon;
  final FUIIconSize size;
  final FUIColor? color;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Icon(
      icon,
      size: size.px,
      color: fui.resolve(color ?? fui.colors.onSurface),
    );
  }
}
