import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import 'fui_icon.dart';

enum FUIIconButtonVariant { plain, tonal, filled }

/// A tappable icon with a guaranteed 40×40 hit target, ink feedback, and three
/// emphasis levels. Sizing of the glyph follows [FUIIconSize].
class FUIIconButton extends StatelessWidget {
  const FUIIconButton({
    required this.icon,
    this.onPressed,
    this.variant = FUIIconButtonVariant.plain,
    this.size = FUIIconSize.md,
    this.color,
    this.tooltip,
    this.isEnabled = true,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final FUIIconButtonVariant variant;
  final FUIIconSize size;

  /// Overrides the glyph color token. Ignored for [FUIIconButtonVariant.filled],
  /// which always uses `onPrimary` on its primary fill.
  final FUIColor? color;
  final String? tooltip;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onPressed != null;
    final radius = BorderRadius.circular(fui.radii.full);

    final (bg, fg) = _palette(fui, enabled);

    Widget button = Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: radius,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: size.px, color: fg),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }
    return button;
  }

  (Color bg, Color fg) _palette(FUIThemeData fui, bool enabled) {
    final disabledFg = fui.resolve(fui.colors.onDisabled);
    switch (variant) {
      case FUIIconButtonVariant.plain:
        return (
          Colors.transparent,
          enabled ? fui.resolve(color ?? fui.colors.onSurface) : disabledFg,
        );
      case FUIIconButtonVariant.tonal:
        return (
          enabled
              ? fui.resolve(fui.colors.surfaceVariant)
              : fui.resolve(fui.colors.disabled),
          enabled ? fui.resolve(color ?? fui.colors.onSurface) : disabledFg,
        );
      case FUIIconButtonVariant.filled:
        return (
          enabled
              ? fui.resolve(fui.colors.primary)
              : fui.resolve(fui.colors.disabled),
          enabled ? fui.resolve(fui.colors.onPrimary) : disabledFg,
        );
    }
  }
}
