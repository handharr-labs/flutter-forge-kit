import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

enum FUIDividerAxis { horizontal, vertical }

/// A hairline separator. Horizontal by default; an optional [label] splits a
/// horizontal divider into "line — label — line".
class FUIDivider extends StatelessWidget {
  const FUIDivider({
    this.axis = FUIDividerAxis.horizontal,
    this.label,
    super.key,
  });

  final FUIDividerAxis axis;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final color = fui.resolve(fui.colors.border);

    if (axis == FUIDividerAxis.vertical) {
      return Container(width: 1, color: color);
    }

    final line = Expanded(child: Container(height: 1, color: color));
    if (label == null) {
      return Container(height: 1, color: color);
    }
    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: fui.spacing.md),
          child: Text(
            label!,
            style: fui.typography.caption
                .copyWith(color: fui.resolve(fui.colors.textSubtle)),
          ),
        ),
        line,
      ],
    );
  }
}
