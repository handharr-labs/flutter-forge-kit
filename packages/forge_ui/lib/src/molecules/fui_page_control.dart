import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A row of page-indicator dots. The active dot stretches into a pill in the
/// primary color; the rest stay small and muted.
class FUIPageControl extends StatelessWidget {
  const FUIPageControl({
    required this.count,
    required this.currentIndex,
    super.key,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final active = fui.resolve(fui.colors.primary);
    final inactive = fui.resolve(fui.colors.borderStrong);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: fui.spacing.xs / 2),
            width: i == currentIndex ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == currentIndex ? active : inactive,
              borderRadius: BorderRadius.circular(fui.radii.full),
            ),
          ),
      ],
    );
  }
}
