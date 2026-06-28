import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../tokens/fui_status.dart';

/// Configuration for [FUIBanner] — an inline alert message.
@immutable
class FUIBannerConfiguration {
  const FUIBannerConfiguration({
    required this.message,
    this.title,
    this.status = FUIStatus.info,
    this.icon,
    this.dismissible = false,
  });

  final String message;
  final String? title;
  final FUIStatus status;

  /// Leading icon. When null, a sensible default is chosen for the [status].
  final IconData? icon;

  /// When true, a trailing ✕ is shown and tapping it fires `onDismiss`.
  final bool dismissible;
}

/// An inline alert tinted by a [FUIStatus] family, with an optional title,
/// leading icon, and dismiss action.
class FUIBanner extends StatelessWidget {
  const FUIBanner({
    required this.configuration,
    this.onDismiss,
    super.key,
  });

  final FUIBannerConfiguration configuration;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;
    final colors = FUIStatusColors.of(fui, c.status);
    final accent = colors.solid;

    return Container(
      padding: EdgeInsets.all(fui.spacing.md),
      decoration: BoxDecoration(
        color: colors.subtle,
        borderRadius: BorderRadius.circular(fui.radii.md),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(c.icon ?? _defaultIcon(c.status), size: 20, color: accent),
          SizedBox(width: fui.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (c.title != null) ...[
                  Text(
                    c.title!,
                    style: fui.typography.label
                        .copyWith(color: fui.resolve(fui.colors.onSurface)),
                  ),
                  SizedBox(height: fui.spacing.xs),
                ],
                Text(
                  c.message,
                  style: fui.typography.bodySm
                      .copyWith(color: fui.resolve(fui.colors.textSecondary)),
                ),
              ],
            ),
          ),
          if (c.dismissible) ...[
            SizedBox(width: fui.spacing.sm),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(FUIIcons.close,
                  size: 18, color: fui.resolve(fui.colors.textSubtle)),
            ),
          ],
        ],
      ),
    );
  }

  IconData _defaultIcon(FUIStatus status) {
    switch (status) {
      case FUIStatus.success:
        return FUIIcons.success;
      case FUIStatus.warning:
        return FUIIcons.warning;
      case FUIStatus.danger:
        return FUIIcons.error;
      case FUIStatus.info:
      case FUIStatus.neutral:
        return FUIIcons.info;
    }
  }
}
