import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A semantic status used by status-bearing components (badge, tag, banner).
/// Maps onto the status families in [FUIColors].
enum FUIStatus { neutral, info, success, warning, danger }

/// A resolved trio of colors for a [FUIStatus] at the active brightness:
/// a strong [solid], a contrasting [onSolid], and a low-emphasis [subtle].
@immutable
class FUIStatusColors {
  const FUIStatusColors({
    required this.solid,
    required this.onSolid,
    required this.subtle,
  });

  final Color solid;
  final Color onSolid;
  final Color subtle;

  factory FUIStatusColors.of(FUIThemeData fui, FUIStatus status) {
    final colors = fui.colors;
    switch (status) {
      case FUIStatus.neutral:
        return FUIStatusColors(
          solid: fui.resolve(colors.textSecondary),
          onSolid: fui.resolve(colors.onPrimary),
          subtle: fui.resolve(colors.surfaceVariant),
        );
      case FUIStatus.info:
        return FUIStatusColors(
          solid: fui.resolve(colors.info),
          onSolid: fui.resolve(colors.onInfo),
          subtle: fui.resolve(colors.infoSubtle),
        );
      case FUIStatus.success:
        return FUIStatusColors(
          solid: fui.resolve(colors.success),
          onSolid: fui.resolve(colors.onSuccess),
          subtle: fui.resolve(colors.successSubtle),
        );
      case FUIStatus.warning:
        return FUIStatusColors(
          solid: fui.resolve(colors.warning),
          onSolid: fui.resolve(colors.onWarning),
          subtle: fui.resolve(colors.warningSubtle),
        );
      case FUIStatus.danger:
        return FUIStatusColors(
          solid: fui.resolve(colors.danger),
          onSolid: fui.resolve(colors.onDanger),
          subtle: fui.resolve(colors.dangerSubtle),
        );
    }
  }
}
