import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/fui_tokens.dart';

/// A fixed-length PIN / one-time-code entry.
///
/// Renders [length] boxed cells over a single hidden input, so paste, backspace,
/// and "auto-advance" all come from the platform field for free. [onChanged]
/// fires on every edit; [onCompleted] fires once all cells are filled.
class FUIOtpField extends StatefulWidget {
  const FUIOtpField({
    this.length = 6,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.digitsOnly = true,
    this.autofocus = false,
    this.isEnabled = true,
    this.hasError = false,
    super.key,
  });

  final int length;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool digitsOnly;
  final bool autofocus;
  final bool isEnabled;

  /// When true every cell renders in its danger state.
  final bool hasError;

  @override
  State<FUIOtpField> createState() => _FUIOtpFieldState();
}

class _FUIOtpFieldState extends State<FUIOtpField> {
  TextEditingController? _ownController;
  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _ownController?.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final text = _controller.text;
    final focused = _focusNode.hasFocus;

    return Stack(
      children: [
        IgnorePointer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.length; i++) ...[
                if (i > 0) SizedBox(width: fui.spacing.sm),
                _Cell(
                  char: i < text.length ? text[i] : '',
                  isActive: focused && i == text.length,
                  hasError: widget.hasError,
                ),
              ],
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0, // the real input sits invisibly over the cells
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.isEnabled,
              autofocus: widget.autofocus,
              onChanged: _onChanged,
              onTap: () => setState(() {}),
              keyboardType:
                  widget.digitsOnly ? TextInputType.number : TextInputType.text,
              maxLength: widget.length,
              showCursor: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.length),
                if (widget.digitsOnly) FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.char,
    required this.isActive,
    required this.hasError,
  });

  final String char;
  final bool isActive;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final FUIColor borderColor = hasError
        ? fui.colors.danger
        : isActive
            ? fui.colors.primary
            : fui.colors.border;

    return Container(
      width: 44,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.circular(fui.radii.md),
        border: Border.all(
          color: fui.resolve(borderColor),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Text(
        char,
        style: fui.typography.titleMd
            .copyWith(color: fui.resolve(fui.colors.onSurface)),
      ),
    );
  }
}
