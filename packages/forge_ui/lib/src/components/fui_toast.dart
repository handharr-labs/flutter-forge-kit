import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import 'fui_status.dart';

/// Shows a transient toast near the bottom of the screen. Inserts an overlay
/// entry (re-providing the ambient [FUITheme]) that fades in, waits [duration],
/// then fades out and removes itself.
///
/// ```dart
/// showFUIToast(context, message: 'Saved', status: FUIStatus.success);
/// ```
void showFUIToast(
  BuildContext context, {
  required String message,
  FUIStatus status = FUIStatus.neutral,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  final data = FUITheme.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => FUITheme(
      tokens: data.tokens,
      brightness: data.brightness,
      child: _FUIToastView(
        message: message,
        status: status,
        icon: icon,
        duration: duration,
        onDismissed: () => entry.remove(),
      ),
    ),
  );
  overlay.insert(entry);
}

class _FUIToastView extends StatefulWidget {
  const _FUIToastView({
    required this.message,
    required this.status,
    required this.icon,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final FUIStatus status;
  final IconData? icon;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_FUIToastView> createState() => _FUIToastViewState();
}

class _FUIToastViewState extends State<_FUIToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await _controller.forward();
    await Future<void>.delayed(widget.duration);
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final colors = FUIStatusColors.of(fui, widget.status);
    final mq = MediaQuery.of(context);

    return Positioned(
      left: fui.spacing.lg,
      right: fui.spacing.lg,
      bottom: mq.padding.bottom + fui.spacing.xl,
      child: FadeTransition(
        opacity: _controller,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: fui.spacing.lg,
              vertical: fui.spacing.md,
            ),
            decoration: BoxDecoration(
              color: fui.resolve(fui.colors.onSurface),
              borderRadius: BorderRadius.circular(fui.radii.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null ||
                    widget.status != FUIStatus.neutral) ...[
                  Icon(
                    widget.icon ?? Icons.info_outline,
                    size: 20,
                    color: colors.solid,
                  ),
                  SizedBox(width: fui.spacing.sm),
                ],
                Flexible(
                  child: Text(
                    widget.message,
                    style: fui.typography.bodySm
                        .copyWith(color: fui.resolve(fui.colors.surface)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
