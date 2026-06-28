import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// Token radius applied to the image's clipped corners.
enum FUIImageRadius { none, sm, md, lg, xl, full }

/// Configuration for [FUIImage]. Bundles the styling knobs (radius, fit,
/// aspect ratio, dimensions) into one object, leaving the [ImageProvider]
/// source on the widget itself.
class FUIImageConfiguration {
  const FUIImageConfiguration({
    this.radius = FUIImageRadius.md,
    this.fit = BoxFit.cover,
    this.aspectRatio,
    this.width,
    this.height,
  });

  final FUIImageRadius radius;
  final BoxFit fit;

  /// When set, the image is wrapped in an [AspectRatio]. Ignored if both
  /// [width] and [height] are given.
  final double? aspectRatio;
  final double? width;
  final double? height;
}

/// A token-styled image that renders any consumer-supplied [ImageProvider].
///
/// The kit ships no bundled artwork: callers pass their own asset/network/
/// memory provider. [FUIImage] owns only the *presentation* — token corner
/// radius, fit, sizing, and brightness-aware loading/error states drawn from
/// tokens (no assets, no extra dependency).
class FUIImage extends StatelessWidget {
  const FUIImage({
    required this.image,
    this.configuration = const FUIImageConfiguration(),
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
    super.key,
  });

  final ImageProvider image;
  final FUIImageConfiguration configuration;

  /// Shown while the image loads. Defaults to a tinted token surface.
  final WidgetBuilder? placeholder;

  /// Shown when the image fails to load. Defaults to a tinted token surface
  /// with a broken-image glyph.
  final WidgetBuilder? errorBuilder;

  final String? semanticLabel;

  double _radius(FUIThemeData fui) {
    switch (configuration.radius) {
      case FUIImageRadius.none:
        return 0;
      case FUIImageRadius.sm:
        return fui.radii.sm;
      case FUIImageRadius.md:
        return fui.radii.md;
      case FUIImageRadius.lg:
        return fui.radii.lg;
      case FUIImageRadius.xl:
        return fui.radii.xl;
      case FUIImageRadius.full:
        return fui.radii.full;
    }
  }

  Widget _fallback(FUIThemeData fui, {IconData? icon}) {
    return Container(
      color: fui.resolve(fui.colors.surfaceVariant),
      alignment: Alignment.center,
      child: icon == null
          ? null
          : Icon(
              icon,
              color: fui.resolve(fui.colors.textSecondary),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final c = configuration;

    Widget content = Image(
      image: image,
      fit: c.fit,
      width: c.width,
      height: c.height,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder?.call(context) ?? _fallback(fui);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorBuilder?.call(context) ??
            _fallback(fui, icon: FUIIcons.imageBroken);
      },
    );

    if (c.aspectRatio != null && !(c.width != null && c.height != null)) {
      content = AspectRatio(aspectRatio: c.aspectRatio!, child: content);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius(fui)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: c.width,
        height: c.height,
        child: content,
      ),
    );
  }
}
