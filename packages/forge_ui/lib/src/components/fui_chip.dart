import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A selectable / filter chip. Selected state flips it to the primary fill;
/// tapping fires [onTap].
class FUIChip extends StatelessWidget {
  const FUIChip({
    required this.label,
    this.selected = false,
    this.icon,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final radius = BorderRadius.circular(fui.radii.full);
    final fg = selected
        ? fui.resolve(fui.colors.onPrimary)
        : fui.resolve(fui.colors.onSurface);
    final bg = selected
        ? fui.resolve(fui.colors.primary)
        : fui.resolve(fui.colors.surface);

    return Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: fui.spacing.md,
            vertical: fui.spacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? fui.resolve(fui.colors.primary)
                  : fui.resolve(fui.colors.border),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                SizedBox(width: fui.spacing.xs),
              ],
              Text(
                label,
                style: fui.typography.bodySm
                    .copyWith(color: fg, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
