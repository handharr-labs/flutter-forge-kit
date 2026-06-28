import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A rounded "search bar" input: a leading search glyph, a filled pill surface,
/// and an inline clear button that appears once there's text.
///
/// Distinct chrome from [FUITextField] (pill vs. labelled form field), so it's
/// its own primitive rather than a restyle. The live value flows through
/// [controller]/[onChanged]; [onSubmitted] fires on keyboard submit.
class FUISearchField extends StatefulWidget {
  const FUISearchField({
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.isEnabled = true,
    this.focusNode,
    super.key,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called after the field is cleared via the inline ✕ button.
  final VoidCallback? onClear;
  final bool autofocus;
  final bool isEnabled;
  final FocusNode? focusNode;

  @override
  State<FUISearchField> createState() => _FUISearchFieldState();
}

class _FUISearchFieldState extends State<FUISearchField> {
  TextEditingController? _ownController;
  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _ownController?.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {}); // toggle the clear button

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final hasText = _controller.text.isNotEmpty;
    final radius = BorderRadius.circular(fui.radii.full);

    OutlineInputBorder border([FUIColor? color, double width = 1]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: color == null
              ? BorderSide.none
              : BorderSide(color: fui.resolve(color), width: width),
        );

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.isEnabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      style: fui.typography.body
          .copyWith(color: fui.resolve(fui.colors.onSurface)),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: widget.isEnabled
            ? fui.resolve(fui.colors.surfaceVariant)
            : fui.resolve(fui.colors.disabled),
        hintText: widget.hint,
        hintStyle: fui.typography.body
            .copyWith(color: fui.resolve(fui.colors.textSubtle)),
        prefixIcon: Icon(FUIIcons.search,
            size: 20, color: fui.resolve(fui.colors.textSecondary)),
        suffixIcon: hasText
            ? IconButton(
                icon: Icon(FUIIcons.close,
                    size: 18, color: fui.resolve(fui.colors.textSecondary)),
                splashRadius: 18,
                tooltip: 'Clear',
                onPressed: widget.isEnabled ? _clear : null,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: fui.spacing.sm),
        enabledBorder: border(),
        focusedBorder: border(fui.colors.primary, 1.5),
        disabledBorder: border(),
      ),
    );
  }
}
