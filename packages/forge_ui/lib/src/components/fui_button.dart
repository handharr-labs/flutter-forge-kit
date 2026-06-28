import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

enum FUIButtonVariant { primary, danger }

/// Configuration for [FUIButton]. Passing one object (rather than a long
/// parameter list) keeps the call site stable as options are added.
@immutable
class FUIButtonConfiguration {
  const FUIButtonConfiguration({
    required this.label,
    this.variant = FUIButtonVariant.primary,
    this.isEnabled = true,
  });

  final String label;
  final FUIButtonVariant variant;
  final bool isEnabled;
}

/// A token-driven button. Colors, radius, and spacing come from the nearest
/// [FUITheme]; nothing is hard-coded at the call site.
class FUIButton extends StatelessWidget {
  const FUIButton({
    required this.configuration,
    this.onPressed,
    super.key,
  });

  final FUIButtonConfiguration configuration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final t = FUITheme.of(context);
    final bg = switch (configuration.variant) {
      FUIButtonVariant.primary => t.colors.primary,
      FUIButtonVariant.danger => t.colors.danger,
    };
    final enabled = configuration.isEnabled && onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing.lg,
            vertical: t.spacing.md,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(t.radii.md),
          ),
          child: Text(
            configuration.label,
            style: t.typography.button.copyWith(color: t.colors.onPrimary),
          ),
        ),
      ),
    );
  }
}
