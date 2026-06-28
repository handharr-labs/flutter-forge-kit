import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_button.dart';

/// An empty / zero-state: a title, an optional message, and an optional primary
/// action above a piece of art.
///
/// By default the art is a tinted Material [icon] — the kit bundles no
/// illustration assets, staying standalone. Consumers that have their own
/// artwork pass an [illustration] widget (e.g. an `FUIImage`, `Image.asset`, or
/// SVG), which replaces the icon; supplying assets is the downstream app's job.
class FUIBlankSlate extends StatelessWidget {
  const FUIBlankSlate({
    required this.icon,
    required this.title,
    this.message,
    this.illustration,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;

  /// Optional consumer-supplied artwork shown in place of the default [icon].
  final Widget? illustration;

  /// When both [actionLabel] and [onAction] are set, a primary button shows.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(fui.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            illustration ??
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fui.resolve(fui.colors.surfaceVariant),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: fui.resolve(fui.colors.textSecondary),
                  ),
                ),
            SizedBox(height: fui.spacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: fui.typography.titleMd
                  .copyWith(color: fui.resolve(fui.colors.onSurface)),
            ),
            if (message != null) ...[
              SizedBox(height: fui.spacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: fui.typography.bodySm
                    .copyWith(color: fui.resolve(fui.colors.textSecondary)),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: fui.spacing.xl),
              FUIButton(
                configuration: FUIButtonConfiguration(label: actionLabel!),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
