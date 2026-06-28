import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A token-styled tooltip. Wraps Flutter's [Tooltip] with the kit's surface,
/// radius, and typography so hints read consistently across the app.
class FUITooltip extends StatelessWidget {
  const FUITooltip({
    required this.message,
    required this.child,
    super.key,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Tooltip(
      message: message,
      padding: EdgeInsets.symmetric(
        horizontal: fui.spacing.sm,
        vertical: fui.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.onSurface),
        borderRadius: BorderRadius.circular(fui.radii.sm),
      ),
      textStyle: fui.typography.caption
          .copyWith(color: fui.resolve(fui.colors.surface)),
      child: child,
    );
  }
}
