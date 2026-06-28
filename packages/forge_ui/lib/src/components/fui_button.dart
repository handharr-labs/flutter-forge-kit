import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

enum FUIButtonVariant { primary, secondary, tertiary, ghost, danger }

enum FUIButtonSize { small, medium }

enum FUIButtonIconPosition { leading, trailing }

/// Configuration for [FUIButton]. Passing one object (rather than a long
/// parameter list) keeps the call site stable as options are added.
@immutable
class FUIButtonConfiguration {
  const FUIButtonConfiguration({
    required this.label,
    this.variant = FUIButtonVariant.primary,
    this.size = FUIButtonSize.medium,
    this.icon,
    this.iconPosition = FUIButtonIconPosition.leading,
    this.isEnabled = true,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final String label;
  final FUIButtonVariant variant;
  final FUIButtonSize size;

  /// Optional icon shown beside the label.
  final IconData? icon;
  final FUIButtonIconPosition iconPosition;

  final bool isEnabled;

  /// Shows a spinner in place of the label and blocks taps.
  final bool isLoading;

  /// Stretches the button to fill its horizontal constraints.
  final bool fullWidth;
}

/// A token-driven button. Colors, radius, spacing, and typography come from the
/// nearest [FUITheme]; nothing is hard-coded at the call site. Uses Material
/// [InkWell] for ripple, hover, and pressed feedback.
class FUIButton extends StatelessWidget {
  const FUIButton({
    required this.configuration,
    this.onPressed,
    super.key,
  });

  final FUIButtonConfiguration configuration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;
    final enabled = c.isEnabled && !c.isLoading && onPressed != null;
    final palette = _palette(fui, c.variant);

    final height = c.size == FUIButtonSize.small ? 32.0 : 48.0;
    final horizontalPad =
        c.size == FUIButtonSize.small ? fui.spacing.md : fui.spacing.lg;
    final radius = c.size == FUIButtonSize.small ? fui.radii.md : fui.radii.lg;
    final textStyle = (c.size == FUIButtonSize.small
        ? fui.typography.label
        : fui.typography.button);

    final fg =
        enabled ? palette.foreground : fui.resolve(fui.colors.onDisabled);
    final bg = enabled ? palette.background : _disabledBackground(fui, palette);
    final border = palette.border == null
        ? null
        : Border.all(
            color: enabled
                ? fui.resolve(palette.border!)
                : fui.resolve(fui.colors.border),
          );

    final child = c.isLoading
        ? SizedBox(
            height: c.size == FUIButtonSize.small ? 16 : 20,
            width: c.size == FUIButtonSize.small ? 16 : 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : _Label(
            label: c.label,
            icon: c.icon,
            iconPosition: c.iconPosition,
            color: fg,
            textStyle: textStyle,
            gap: fui.spacing.sm,
            iconSize: c.size == FUIButtonSize.small ? 16 : 20,
          );

    return Opacity(
      opacity: enabled || c.isLoading ? 1 : 0.6,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            height: height,
            width: c.fullWidth ? double.infinity : null,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: horizontalPad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Color _disabledBackground(FUIThemeData fui, _ButtonPalette p) =>
      p.background == Colors.transparent
          ? Colors.transparent
          : fui.resolve(fui.colors.disabled);

  _ButtonPalette _palette(FUIThemeData fui, FUIButtonVariant variant) {
    switch (variant) {
      case FUIButtonVariant.primary:
        return _ButtonPalette(
          background: fui.resolve(fui.colors.primary),
          foreground: fui.resolve(fui.colors.onPrimary),
        );
      case FUIButtonVariant.danger:
        return _ButtonPalette(
          background: fui.resolve(fui.colors.danger),
          foreground: fui.resolve(fui.colors.onDanger),
        );
      case FUIButtonVariant.secondary:
        return _ButtonPalette(
          background: fui.resolve(fui.colors.surface),
          foreground: fui.resolve(fui.colors.primary),
          border: fui.colors.primary,
        );
      case FUIButtonVariant.tertiary:
        return _ButtonPalette(
          background: fui.resolve(fui.colors.surface),
          foreground: fui.resolve(fui.colors.onSurface),
          border: fui.colors.border,
        );
      case FUIButtonVariant.ghost:
        return _ButtonPalette(
          background: Colors.transparent,
          foreground: fui.resolve(fui.colors.primary),
        );
    }
  }
}

class _ButtonPalette {
  const _ButtonPalette({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final FUIColor? border;
}

class _Label extends StatelessWidget {
  const _Label({
    required this.label,
    required this.icon,
    required this.iconPosition,
    required this.color,
    required this.textStyle,
    required this.gap,
    required this.iconSize,
  });

  final String label;
  final IconData? icon;
  final FUIButtonIconPosition iconPosition;
  final Color color;
  final TextStyle textStyle;
  final double gap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final text = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle.copyWith(color: color),
      ),
    );
    if (icon == null) {
      return Row(mainAxisSize: MainAxisSize.min, children: [text]);
    }
    final glyph = Icon(icon, size: iconSize, color: color);
    final children = iconPosition == FUIButtonIconPosition.leading
        ? [glyph, SizedBox(width: gap), text]
        : [text, SizedBox(width: gap), glyph];
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
