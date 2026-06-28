import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

enum FUITextVariant {
  titleLg,
  titleMd,
  body,
  bodySm,
  caption,
  overline,
  label,
}

/// Semantic text colors, mapped to [FUIColors] roles so call sites stay
/// brightness-agnostic.
enum FUITextColor { primary, secondary, subtle, onPrimary, danger, success }

/// A typography-driven text widget. Picks a [FUITextVariant] from the type
/// scale and a [FUITextColor] role from the palette — no raw `TextStyle` or
/// `Color` at the call site.
class FUIText extends StatelessWidget {
  const FUIText(
    this.data, {
    this.variant = FUITextVariant.body,
    this.color = FUITextColor.primary,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String data;
  final FUITextVariant variant;
  final FUITextColor color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final style = _style(fui.typography, variant).copyWith(
      color: _color(fui, color),
    );
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }

  TextStyle _style(FUITypography t, FUITextVariant v) {
    switch (v) {
      case FUITextVariant.titleLg:
        return t.titleLg;
      case FUITextVariant.titleMd:
        return t.titleMd;
      case FUITextVariant.body:
        return t.body;
      case FUITextVariant.bodySm:
        return t.bodySm;
      case FUITextVariant.caption:
        return t.caption;
      case FUITextVariant.overline:
        return t.overline;
      case FUITextVariant.label:
        return t.label;
    }
  }

  Color _color(FUIThemeData fui, FUITextColor c) {
    switch (c) {
      case FUITextColor.primary:
        return fui.resolve(fui.colors.onSurface);
      case FUITextColor.secondary:
        return fui.resolve(fui.colors.textSecondary);
      case FUITextColor.subtle:
        return fui.resolve(fui.colors.textSubtle);
      case FUITextColor.onPrimary:
        return fui.resolve(fui.colors.onPrimary);
      case FUITextColor.danger:
        return fui.resolve(fui.colors.danger);
      case FUITextColor.success:
        return fui.resolve(fui.colors.success);
    }
  }
}
