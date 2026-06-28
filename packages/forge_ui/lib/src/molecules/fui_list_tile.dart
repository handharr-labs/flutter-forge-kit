import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A single-row list item: optional leading widget, a title with optional
/// subtitle, and an optional trailing widget. Tappable when [onTap] is set.
class FUIListTile extends StatelessWidget {
  const FUIListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    final row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: fui.spacing.lg,
        vertical: fui.spacing.md,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: fui.spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fui.typography.body
                      .copyWith(color: fui.resolve(fui.colors.onSurface)),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: fui.spacing.xs),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: fui.typography.bodySm
                        .copyWith(color: fui.resolve(fui.colors.textSecondary)),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: fui.spacing.md),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}
