import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// One destination in a [FUIBottomNavBar].
@immutable
class FUIBottomNavItem {
  const FUIBottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  final IconData icon;

  /// Optional filled glyph shown when the item is selected.
  final IconData? activeIcon;
  final String label;
}

/// A token-driven bottom navigation bar. The parent owns [currentIndex] and
/// updates it in [onTap]; the bar stays stateless.
class FUIBottomNavBar extends StatelessWidget {
  const FUIBottomNavBar({
    required this.items,
    required this.currentIndex,
    this.onTap,
    super.key,
  });

  final List<FUIBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    return Material(
      color: fui.resolve(fui.colors.surface),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: fui.resolve(fui.colors.border)),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: onTap == null ? null : () => onTap!(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.selected, this.onTap});

  final FUIBottomNavItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final color = selected
        ? fui.resolve(fui.colors.primary)
        : fui.resolve(fui.colors.textSubtle);
    final glyph = selected ? (item.activeIcon ?? item.icon) : item.icon;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(glyph, size: 24, color: color),
          SizedBox(height: fui.spacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: fui.typography.overline.copyWith(
              color: color,
              letterSpacing: 0,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
