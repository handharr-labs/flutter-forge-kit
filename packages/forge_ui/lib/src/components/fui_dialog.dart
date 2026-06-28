import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import 'fui_button.dart';

/// Configuration for [FUIDialog].
@immutable
class FUIDialogConfiguration {
  const FUIDialogConfiguration({
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel,
    this.destructive = false,
  });

  final String title;
  final String message;

  /// Primary action label. Confirming pops the dialog with `true`.
  final String confirmLabel;

  /// Optional secondary action. When null, only the confirm button shows.
  /// Cancelling pops with `false`.
  final String? cancelLabel;

  /// Renders the confirm button in the danger variant.
  final bool destructive;
}

/// Presents [configuration] as a modal alert dialog, re-providing the ambient
/// [FUITheme] across the modal route boundary. Resolves to `true` (confirm),
/// `false` (cancel), or `null` (barrier dismiss).
Future<bool?> showFUIDialog(
  BuildContext context, {
  required FUIDialogConfiguration configuration,
  bool barrierDismissible = true,
}) {
  final data = FUITheme.of(context);
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: data.resolve(data.colors.overlay),
    builder: (_) => FUITheme(
      tokens: data.tokens,
      brightness: data.brightness,
      child: FUIDialog(configuration: configuration),
    ),
  );
}

/// The dialog surface. Usually presented via [showFUIDialog].
class FUIDialog extends StatelessWidget {
  const FUIDialog({required this.configuration, super.key});

  final FUIDialogConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(fui.spacing.xl),
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: EdgeInsets.all(fui.spacing.lg),
              decoration: BoxDecoration(
                color: fui.resolve(fui.colors.surface),
                borderRadius: BorderRadius.circular(fui.radii.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    c.title,
                    style: fui.typography.titleMd
                        .copyWith(color: fui.resolve(fui.colors.onSurface)),
                  ),
                  SizedBox(height: fui.spacing.sm),
                  Text(
                    c.message,
                    style: fui.typography.bodySm
                        .copyWith(color: fui.resolve(fui.colors.textSecondary)),
                  ),
                  SizedBox(height: fui.spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (c.cancelLabel != null) ...[
                        FUIButton(
                          configuration: FUIButtonConfiguration(
                            label: c.cancelLabel!,
                            variant: FUIButtonVariant.tertiary,
                            size: FUIButtonSize.small,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        SizedBox(width: fui.spacing.sm),
                      ],
                      FUIButton(
                        configuration: FUIButtonConfiguration(
                          label: c.confirmLabel,
                          variant: c.destructive
                              ? FUIButtonVariant.danger
                              : FUIButtonVariant.primary,
                          size: FUIButtonSize.small,
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
