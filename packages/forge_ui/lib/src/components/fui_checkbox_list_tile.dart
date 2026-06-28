import 'package:flutter/widgets.dart';

import 'fui_checkbox.dart';
import 'fui_list_tile.dart';

/// A list row pairing a title/subtitle with a trailing [FUICheckbox]. Tapping
/// anywhere on the row toggles the value.
class FUICheckboxListTile extends StatelessWidget {
  const FUICheckboxListTile({
    required this.title,
    required this.value,
    this.subtitle,
    this.leading,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final String title;
  final bool value;
  final String? subtitle;
  final Widget? leading;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && onChanged != null;
    return FUIListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: enabled ? () => onChanged!(!value) : null,
      trailing: FUICheckbox(
        state: value ? FUICheckboxState.checked : FUICheckboxState.unchecked,
        isEnabled: isEnabled,
        onChanged: enabled ? (v) => onChanged!(v) : null,
      ),
    );
  }
}
