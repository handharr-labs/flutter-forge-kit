import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// Configuration for [FUIBottomSheet].
@immutable
class FUIBottomSheetConfiguration {
  const FUIBottomSheetConfiguration({
    required this.child,
    this.title,
    this.showHandle = true,
    this.showClose = false,
  });

  /// The sheet body. Compose existing widgets (e.g. a column of [FUIListTile]s).
  final Widget child;

  /// Optional header title.
  final String? title;

  /// Whether to draw the grab handle at the top.
  final bool showHandle;

  /// Whether to show a trailing ✕ in the header (requires a [title]).
  final bool showClose;
}

/// Presents [configuration] as a modal bottom sheet, re-providing the ambient
/// [FUITheme] across the modal route boundary so tokens resolve correctly
/// inside the sheet.
///
/// ```dart
/// await showFUIBottomSheet(
///   context,
///   configuration: FUIBottomSheetConfiguration(
///     title: 'Choose an option',
///     child: Column(children: [...]),
///   ),
/// );
/// ```
Future<T?> showFUIBottomSheet<T>(
  BuildContext context, {
  required FUIBottomSheetConfiguration configuration,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  final data = FUITheme.of(context);
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: data.resolve(data.colors.overlay),
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (_) => FUITheme(
      tokens: data.tokens,
      brightness: data.brightness,
      child: FUIBottomSheet(configuration: configuration),
    ),
  );
}

/// The sheet surface itself: rounded top, optional grab handle, optional header,
/// and the body. Usually presented via [showFUIBottomSheet], but exposed so it
/// can be embedded directly when needed.
class FUIBottomSheet extends StatelessWidget {
  const FUIBottomSheet({required this.configuration, super.key});

  final FUIBottomSheetConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;

    return Container(
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(fui.radii.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (c.showHandle)
              Container(
                margin: EdgeInsets.only(top: fui.spacing.sm),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: fui.resolve(fui.colors.borderStrong),
                  borderRadius: BorderRadius.circular(fui.radii.full),
                ),
              ),
            if (c.title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  fui.spacing.lg,
                  fui.spacing.md,
                  fui.spacing.sm,
                  fui.spacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.title!,
                        style: fui.typography.titleMd
                            .copyWith(color: fui.resolve(fui.colors.onSurface)),
                      ),
                    ),
                    if (c.showClose)
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Icon(Icons.close,
                            size: 20,
                            color: fui.resolve(fui.colors.textSubtle)),
                      ),
                  ],
                ),
              ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  fui.spacing.lg,
                  c.title == null ? fui.spacing.lg : 0,
                  fui.spacing.lg,
                  fui.spacing.lg,
                ),
                child: c.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
