import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A token-themed value slider. Wraps Material's [Slider] with a [SliderTheme]
/// so the track, thumb, and overlay read from the kit's palette.
class FUISlider extends StatelessWidget {
  const FUISlider({
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final enabled = isEnabled && onChanged != null;
    final active = fui.resolve(fui.colors.primary);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: active,
        inactiveTrackColor: fui.resolve(fui.colors.surfaceVariant),
        thumbColor: active,
        overlayColor: active.withValues(alpha: 0.12),
        disabledActiveTrackColor: fui.resolve(fui.colors.disabled),
        disabledInactiveTrackColor: fui.resolve(fui.colors.surfaceVariant),
        disabledThumbColor: fui.resolve(fui.colors.onDisabled),
        valueIndicatorColor: fui.resolve(fui.colors.onSurface),
        valueIndicatorTextStyle: fui.typography.caption
            .copyWith(color: fui.resolve(fui.colors.surface)),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        label: divisions == null ? null : value.toStringAsFixed(0),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
