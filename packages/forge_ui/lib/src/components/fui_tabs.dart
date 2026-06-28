import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A controlled, underline-style tab bar. The parent owns [selectedIndex] and
/// updates it in [onChanged]; the widget stays stateless.
class FUITabs extends StatelessWidget {
  const FUITabs({
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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: fui.resolve(fui.colors.border)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            _Tab(
              label: items[i],
              selected: i == selectedIndex,
              onTap: onChanged == null ? null : () => onChanged!(i),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final color = selected
        ? fui.resolve(fui.colors.primary)
        : fui.resolve(fui.colors.textSecondary);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: fui.spacing.md,
          vertical: fui.spacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected
                  ? fui.resolve(fui.colors.primary)
                  : const Color(0x00000000),
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: fui.typography.label.copyWith(color: color),
        ),
      ),
    );
  }
}
