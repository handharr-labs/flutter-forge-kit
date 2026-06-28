import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import 'fui_status.dart';

/// A pill label tinted by a [FUIStatus] family, with an optional leading icon
/// and a removable variant.
class FUITag extends StatelessWidget {
  const FUITag({
    required this.label,
    this.status = FUIStatus.neutral,
    this.icon,
    this.onRemove,
    super.key,
  });

  final String label;
  final FUIStatus status;
  final IconData? icon;

  /// When non-null, a trailing ✕ is shown and taps fire this callback.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final colors = FUIStatusColors.of(fui, status);
    final fg = colors.solid;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fui.spacing.sm,
        vertical: fui.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.subtle,
        borderRadius: BorderRadius.circular(fui.radii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            SizedBox(width: fui.spacing.xs),
          ],
          Text(
            label,
            style: fui.typography.caption
                .copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
          if (onRemove != null) ...[
            SizedBox(width: fui.spacing.xs),
            GestureDetector(
              onTap: onRemove,
              child: Icon(FUIIcons.close, size: 14, color: fg),
            ),
          ],
        ],
      ),
    );
  }
}
