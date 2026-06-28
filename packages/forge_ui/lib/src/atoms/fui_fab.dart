import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

enum FUIFabVariant { primary, surface }

/// A floating action button. Circular by default; pass a [label] to render the
/// extended (pill) form, or set [mini] for the compact circular size.
class FUIFab extends StatelessWidget {
  const FUIFab({
    required this.icon,
    this.onPressed,
    this.label,
    this.variant = FUIFabVariant.primary,
    this.mini = false,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// When non-null, renders the extended (icon + label) pill. Ignores [mini].
  final String? label;
  final FUIFabVariant variant;
  final bool mini;
  final String? tooltip;

  bool get _extended => label != null;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = onPressed != null;
    final (bg, fg) = _palette(fui, enabled);

    final double diameter = mini ? 40 : 56;
    final shape = _extended
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fui.radii.full))
        : const CircleBorder();

    Widget child;
    if (_extended) {
      child = Padding(
        padding: EdgeInsets.symmetric(horizontal: fui.spacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: fg),
            SizedBox(width: fui.spacing.sm),
            Text(label!, style: fui.typography.button.copyWith(color: fg)),
          ],
        ),
      );
    } else {
      child = Icon(icon, size: mini ? 20 : 24, color: fg);
    }

    Widget fab = Material(
      color: bg,
      elevation: enabled ? 3 : 0,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: _extended ? 0 : diameter,
            minHeight: _extended ? 48 : diameter,
          ),
          child: Center(widthFactor: 1, child: child),
        ),
      ),
    );

    if (tooltip != null) fab = Tooltip(message: tooltip!, child: fab);
    return fab;
  }

  (Color bg, Color fg) _palette(FUIThemeData fui, bool enabled) {
    if (!enabled) {
      return (
        fui.resolve(fui.colors.disabled),
        fui.resolve(fui.colors.onDisabled)
      );
    }
    switch (variant) {
      case FUIFabVariant.primary:
        return (
          fui.resolve(fui.colors.primary),
          fui.resolve(fui.colors.onPrimary)
        );
      case FUIFabVariant.surface:
        return (
          fui.resolve(fui.colors.surface),
          fui.resolve(fui.colors.primary)
        );
    }
  }
}
