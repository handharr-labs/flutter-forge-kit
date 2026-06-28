import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// One selectable action in a [showFUIContextMenu] popup.
@immutable
class FUIContextMenuAction<T> {
  const FUIContextMenuAction({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
  });

  /// Returned from [showFUIContextMenu] when this action is chosen.
  final T value;
  final String label;
  final IconData? icon;

  /// Renders the row in the danger color (for delete/remove-style actions).
  final bool isDestructive;
}

/// Opens a token-styled context menu anchored to the widget that owns [context]
/// (or to [globalPosition] when given), returning the chosen action's value.
///
/// Re-provides the ambient [FUITheme] inside each item so tokens resolve across
/// the popup's route boundary, mirroring the kit's other overlays.
///
/// ```dart
/// final picked = await showFUIContextMenu<String>(
///   context,
///   actions: const [
///     FUIContextMenuAction(value: 'share', label: 'Share', icon: FUIIcons.share),
///     FUIContextMenuAction(
///         value: 'delete', label: 'Delete', icon: FUIIcons.delete,
///         isDestructive: true),
///   ],
/// );
/// ```
Future<T?> showFUIContextMenu<T>(
  BuildContext context, {
  required List<FUIContextMenuAction<T>> actions,
  Offset? globalPosition,
}) {
  final data = FUITheme.of(context);
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final RelativeRect position;
  if (globalPosition != null) {
    position = RelativeRect.fromLTRB(
      globalPosition.dx,
      globalPosition.dy,
      overlay.size.width - globalPosition.dx,
      overlay.size.height - globalPosition.dy,
    );
  } else {
    final box = context.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = box.localToGlobal(
      box.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );
    position = RelativeRect.fromLTRB(
      topLeft.dx,
      bottomRight.dy,
      overlay.size.width - bottomRight.dx,
      overlay.size.height - bottomRight.dy,
    );
  }

  return showMenu<T>(
    context: context,
    position: position,
    color: data.resolve(data.colors.surface),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(data.radii.md),
    ),
    items: [
      for (final action in actions)
        PopupMenuItem<T>(
          value: action.value,
          child: FUITheme(
            tokens: data.tokens,
            brightness: data.brightness,
            child: _ContextMenuRow(action: action),
          ),
        ),
    ],
  );
}

class _ContextMenuRow extends StatelessWidget {
  const _ContextMenuRow({required this.action});

  final FUIContextMenuAction action;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final color = fui.resolve(
        action.isDestructive ? fui.colors.danger : fui.colors.onSurface);

    return Row(
      children: [
        if (action.icon != null) ...[
          Icon(action.icon, size: 20, color: color),
          SizedBox(width: fui.spacing.md),
        ],
        Text(action.label, style: fui.typography.body.copyWith(color: color)),
      ],
    );
  }
}
