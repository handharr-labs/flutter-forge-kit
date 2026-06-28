import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// Tri-state checkbox value.
enum FUICheckboxState { unchecked, checked, indeterminate }

/// A token-styled checkbox with an optional label. Tapping either the box or
/// the label fires [onChanged] with the next logical state (indeterminate is
/// treated as checked → unchecked).
class FUICheckbox extends StatelessWidget {
  const FUICheckbox({
    required this.state,
    this.label,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final FUICheckboxState state;
  final String? label;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  bool get _isOn => state != FUICheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onChanged != null;
    final active = fui.resolve(fui.colors.primary);
    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _isOn && enabled ? active : fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.circular(fui.radii.sm),
        border: Border.all(
          color:
              _isOn && enabled ? active : fui.resolve(fui.colors.borderStrong),
          width: 1.5,
        ),
      ),
      child: _glyph(fui),
    );

    final content = label == null
        ? box
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              box,
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
        onTap: enabled ? () => onChanged!(!_isOn) : null,
        child: content,
      ),
    );
  }

  Widget? _glyph(FUIThemeData fui) {
    final color = fui.resolve(fui.colors.onPrimary);
    switch (state) {
      case FUICheckboxState.checked:
        return Icon(FUIIcons.check, size: 16, color: color);
      case FUICheckboxState.indeterminate:
        return Icon(FUIIcons.remove, size: 16, color: color);
      case FUICheckboxState.unchecked:
        return null;
    }
  }
}
