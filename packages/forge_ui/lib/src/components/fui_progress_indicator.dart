import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A token-colored progress indicator, linear or circular. Pass [value] in
/// 0..1 for determinate progress; leave it null for an indeterminate spinner.
class FUIProgressIndicator extends StatelessWidget {
  const FUIProgressIndicator.linear({
    this.value,
    this.color,
    super.key,
  })  : _circular = false,
        size = 0;

  const FUIProgressIndicator.circular({
    this.value,
    this.color,
    this.size = 24,
    super.key,
  }) : _circular = true;

  final bool _circular;

  /// 0..1 for determinate; null for indeterminate.
  final double? value;

  /// Overrides the track's foreground color token (defaults to `primary`).
  final FUIColor? color;

  /// Diameter for the circular variant.
  final double size;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final fg = fui.resolve(color ?? fui.colors.primary);
    final track = fui.resolve(fui.colors.surfaceVariant);

    if (_circular) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
          backgroundColor: value == null ? null : track,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(fui.radii.full),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        valueColor: AlwaysStoppedAnimation<Color>(fg),
        backgroundColor: track,
      ),
    );
  }
}
