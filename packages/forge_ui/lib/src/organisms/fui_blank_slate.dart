import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_button.dart';

/// An icon-only empty / zero-state: a tinted icon, a title, an optional message,
/// and an optional primary action. (Illustration assets are a future tranche;
/// this keeps the kit standalone for now.)
class FUIBlankSlate extends StatelessWidget {
  const FUIBlankSlate({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;

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
