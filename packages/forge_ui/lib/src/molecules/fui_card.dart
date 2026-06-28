import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A surface container with token-driven padding, radius, and border. Optional
/// [onTap] makes the whole card tappable with ink feedback.
class FUICard extends StatelessWidget {
  const FUICard({
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  /// When true, casts a soft shadow instead of drawing a border.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final radius = BorderRadius.circular(fui.radii.lg);
    final pad = padding ?? EdgeInsets.all(fui.spacing.lg);

    final content = Container(
      padding: pad,
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: radius,
        border:
            elevated ? null : Border.all(color: fui.resolve(fui.colors.border)),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color:
                      fui.resolve(fui.colors.overlay).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(onTap: onTap, borderRadius: radius, child: content),
    );
  }
}
