import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

/// An animated skeleton placeholder. Use [FUIShimmer.box] for a single block, or
/// wrap a custom shape and pass it as [child] (it will be painted with the
/// shimmer gradient via a [ShaderMask]).
class FUIShimmer extends StatefulWidget {
  const FUIShimmer({required this.child, super.key});

  /// A convenience for the common case: a rounded rectangle of [width]×[height].
  factory FUIShimmer.box({
    double? width,
    double height = 16,
    double radius = 8,
    Key? key,
  }) =>
      FUIShimmer(
        key: key,
        child: _ShimmerBox(width: width, height: height, radius: radius),
      );

  final Widget child;

  @override
  State<FUIShimmer> createState() => _FUIShimmerState();
}

class _FUIShimmerState extends State<FUIShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final base = fui.resolve(fui.colors.surfaceVariant);
    final highlight = fui.resolve(fui.colors.disabled);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = bounds.width * (t * 2 - 1);
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Slides a gradient horizontally by [dx] logical pixels.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, required this.height, required this.radius});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surfaceVariant),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
