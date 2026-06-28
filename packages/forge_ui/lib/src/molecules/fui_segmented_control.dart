import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A controlled pill-style segmented control. The selected segment lifts onto a
/// surface fill inside a tinted track. The parent owns [selectedIndex].
class FUISegmentedControl extends StatelessWidget {
  const FUISegmentedControl({
    required this.items,
    required this.selectedIndex,
    this.onChanged,
    super.key,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Container(
      padding: EdgeInsets.all(fui.spacing.xs),
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surfaceVariant),
        borderRadius: BorderRadius.circular(fui.radii.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            _Segment(
              label: items[i],
              selected: i == selectedIndex,
              onTap: onChanged == null ? null : () => onChanged!(i),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final color = selected
        ? fui.resolve(fui.colors.onSurface)
        : fui.resolve(fui.colors.textSecondary);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: fui.spacing.lg,
          vertical: fui.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? fui.resolve(fui.colors.surface)
              : const Color(0x00000000),
          borderRadius: BorderRadius.circular(fui.radii.sm),
        ),
        child: Text(
          label,
          style: fui.typography.label.copyWith(color: color),
        ),
      ),
    );
  }
}
