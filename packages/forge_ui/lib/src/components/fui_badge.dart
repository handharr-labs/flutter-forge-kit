import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';
import 'fui_status.dart';

/// A small status indicator: either a bare dot or a compact count/label pill.
class FUIBadge extends StatelessWidget {
  const FUIBadge({
    this.label,
    this.status = FUIStatus.danger,
    super.key,
  });

  /// A bare dot with no label.
  const FUIBadge.dot({this.status = FUIStatus.danger, super.key})
      : label = null;

  /// Text shown inside the pill. When null, renders as a dot.
  final String? label;
  final FUIStatus status;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final colors = FUIStatusColors.of(fui, status);

    if (label == null) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: colors.solid, shape: BoxShape.circle),
      );
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: fui.spacing.xs),
      decoration: BoxDecoration(
        color: colors.solid,
        borderRadius: BorderRadius.circular(fui.radii.full),
      ),
      child: Text(
        label!,
        style: fui.typography.overline.copyWith(
          color: colors.onSolid,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
