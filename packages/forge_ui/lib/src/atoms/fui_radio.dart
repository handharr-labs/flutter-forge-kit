import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A token-styled radio button in a logical group. Selected when
/// [value] == [groupValue]; tapping fires [onChanged] with [value].
class FUIRadio<T> extends StatelessWidget {
  const FUIRadio({
    required this.value,
    required this.groupValue,
    this.label,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final T value;
  final T? groupValue;
  final String? label;
  final ValueChanged<T>? onChanged;
  final bool isEnabled;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onChanged != null;
    final active = fui.resolve(fui.colors.primary);

    final dot = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fui.resolve(fui.colors.surface),
        border: Border.all(
          color: _selected && enabled
              ? active
              : fui.resolve(fui.colors.borderStrong),
          width: 1.5,
        ),
      ),
      child: _selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: enabled ? active : fui.resolve(fui.colors.onDisabled),
                ),
              ),
            )
          : null,
    );

    final content = label == null
        ? dot
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              dot,
              SizedBox(width: fui.spacing.sm),
              Flexible(
                child: Text(
                  label!,
                  style: fui.typography.body
                      .copyWith(color: fui.resolve(fui.colors.onSurface)),
                ),
              ),
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled && !_selected ? () => onChanged!(value) : null,
        child: content,
      ),
    );
  }
}
