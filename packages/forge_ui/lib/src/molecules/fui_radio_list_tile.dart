import 'package:flutter/widgets.dart';

import 'fui_list_tile.dart';
import 'fui_radio.dart';

/// A list row pairing a title/subtitle with a trailing [FUIRadio]. Selected when
/// [value] == [groupValue]; tapping the row selects it.
class FUIRadioListTile<T> extends StatelessWidget {
  const FUIRadioListTile({
    required this.title,
    required this.value,
    required this.groupValue,
    this.subtitle,
    this.leading,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final String title;
  final T value;
  final T? groupValue;
  final String? subtitle;
  final Widget? leading;
  final ValueChanged<T>? onChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final enabled = isEnabled && onChanged != null;
    return FUIListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: enabled && !selected ? () => onChanged!(value) : null,
      trailing: FUIRadio<T>(
        value: value,
        groupValue: groupValue,
        isEnabled: isEnabled,
        onChanged: enabled ? (v) => onChanged!(v) : null,
      ),
    );
  }
}
