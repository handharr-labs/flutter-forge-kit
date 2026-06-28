import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../organisms/fui_bottom_sheet.dart';
import 'fui_radio_list_tile.dart';

/// A single option in a [FUISelect].
@immutable
class FUISelectOption<T> {
  const FUISelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A dropdown-style selector. Renders as a token-styled field; tapping opens a
/// bottom-sheet list of options (built from [FUIRadioListTile]) and reports the
/// chosen value through [onChanged].
class FUISelect<T> extends StatelessWidget {
  const FUISelect({
    required this.options,
    required this.value,
    this.label,
    this.hint = 'Select',
    this.sheetTitle,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final List<FUISelectOption<T>> options;
  final T? value;
  final String? label;
  final String hint;

  /// Title shown on the option-picker sheet. Falls back to [label] then [hint].
  final String? sheetTitle;

  final ValueChanged<T>? onChanged;
  final bool isEnabled;

  String? get _selectedLabel {
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showFUIBottomSheet<T>(
      context,
      configuration: FUIBottomSheetConfiguration(
        title: sheetTitle ?? label ?? hint,
        showClose: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final o in options)
              FUIRadioListTile<T>(
                title: o.label,
                value: o.value,
                groupValue: value,
                onChanged: (v) => Navigator.of(context).pop(v),
              ),
          ],
        ),
      ),
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onChanged != null;
    final selected = _selectedLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: fui.typography.label
                .copyWith(color: fui.resolve(fui.colors.onSurface)),
          ),
          SizedBox(height: fui.spacing.xs),
        ],
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? () => _open(context) : null,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: fui.spacing.md,
                vertical: fui.spacing.md,
              ),
              decoration: BoxDecoration(
                color: fui.resolve(fui.colors.surface),
                borderRadius: BorderRadius.circular(fui.radii.md),
                border: Border.all(color: fui.resolve(fui.colors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selected ?? hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: fui.typography.body.copyWith(
                        color: selected == null
                            ? fui.resolve(fui.colors.textSubtle)
                            : fui.resolve(fui.colors.onSurface),
                      ),
                    ),
                  ),
                  Icon(FUIIcons.chevronDown,
                      size: 20, color: fui.resolve(fui.colors.textSecondary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
