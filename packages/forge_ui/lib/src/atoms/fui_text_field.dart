import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// Configuration for [FUITextField]. Holds the static presentation; the live
/// value flows through [controller]/[onChanged] on the widget.
@immutable
class FUITextFieldConfiguration {
  const FUITextFieldConfiguration({
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String? label;
  final String? hint;
  final String? helperText;

  /// When non-null the field renders in its error state and shows this message.
  final String? errorText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isEnabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
}

/// A token-styled text input with label, helper/error text, and prefix/suffix
/// icons. States (default / focus / error / disabled) are driven entirely by
/// the palette.
class FUITextField extends StatelessWidget {
  const FUITextField({
    required this.configuration,
    this.controller,
    this.onChanged,
    this.focusNode,
    super.key,
  });

  final FUITextFieldConfiguration configuration;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;
    final hasError = c.errorText != null;

    final borderColor = hasError ? fui.colors.danger : fui.colors.border;
    final focusColor = hasError ? fui.colors.danger : fui.colors.primary;

    OutlineInputBorder border(FUIColor color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(fui.radii.md),
          borderSide: BorderSide(color: fui.resolve(color), width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (c.label != null) ...[
          Text(
            c.label!,
            style: fui.typography.label
                .copyWith(color: fui.resolve(fui.colors.onSurface)),
          ),
          SizedBox(height: fui.spacing.xs),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          enabled: c.isEnabled,
          obscureText: c.obscureText,
          keyboardType: c.keyboardType,
          maxLines: c.obscureText ? 1 : c.maxLines,
          style: fui.typography.body
              .copyWith(color: fui.resolve(fui.colors.onSurface)),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: c.isEnabled
                ? fui.resolve(fui.colors.surface)
                : fui.resolve(fui.colors.disabled),
            hintText: c.hint,
            hintStyle: fui.typography.body
                .copyWith(color: fui.resolve(fui.colors.textSubtle)),
            prefixIcon: c.prefixIcon == null
                ? null
                : Icon(c.prefixIcon,
                    size: 20, color: fui.resolve(fui.colors.textSecondary)),
            suffixIcon: c.suffixIcon == null
                ? null
                : Icon(c.suffixIcon,
                    size: 20, color: fui.resolve(fui.colors.textSecondary)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: fui.spacing.md,
              vertical: fui.spacing.md,
            ),
            enabledBorder: border(borderColor),
            focusedBorder: border(focusColor, 1.5),
            disabledBorder: border(fui.colors.border),
            errorBorder: border(fui.colors.danger),
            focusedErrorBorder: border(fui.colors.danger, 1.5),
          ),
        ),
        if (hasError || c.helperText != null) ...[
          SizedBox(height: fui.spacing.xs),
          Text(
            c.errorText ?? c.helperText!,
            style: fui.typography.caption.copyWith(
              color: hasError
                  ? fui.resolve(fui.colors.danger)
                  : fui.resolve(fui.colors.textSubtle),
            ),
          ),
        ],
      ],
    );
  }
}
