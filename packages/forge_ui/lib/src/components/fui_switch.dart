import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// A token-styled on/off toggle. A custom track + thumb (not Material's
/// `Switch`) so it reads tokens directly and stays consistent in both themes.
class FUISwitch extends StatelessWidget {
  const FUISwitch({
    required this.value,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  static const double _width = 44;
  static const double _height = 24;
  static const double _thumb = 18;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onChanged != null;
    final trackOn = fui.resolve(fui.colors.primary);
    final trackOff = fui.resolve(fui.colors.borderStrong);

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          width: _width,
          height: _height,
          padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? trackOn : trackOff,
            borderRadius: BorderRadius.circular(fui.radii.full),
          ),
          child: Container(
            width: _thumb,
            height: _thumb,
            decoration: BoxDecoration(
              color: fui.resolve(fui.colors.onPrimary),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
