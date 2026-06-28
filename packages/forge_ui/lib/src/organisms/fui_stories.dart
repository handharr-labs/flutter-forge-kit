import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// One story segment: arbitrary [content] shown for [duration] before the
/// player auto-advances.
@immutable
class FUIStorySegment {
  const FUIStorySegment({
    required this.content,
    this.duration = const Duration(seconds: 5),
  });

  final Widget content;
  final Duration duration;
}

/// An Instagram-style story player: segmented progress bars across the top, the
/// current segment's content filling the frame, tap-left/right to step, and
/// press-and-hold to pause. Content is consumer-supplied (e.g. an [FUIImage]),
/// so the player bundles no media.
class FUIStories extends StatefulWidget {
  const FUIStories({
    required this.segments,
    this.initialIndex = 0,
    this.onComplete,
    this.onIndexChanged,
    super.key,
  });

  final List<FUIStorySegment> segments;
  final int initialIndex;

  /// Called when the last segment finishes.
  final VoidCallback? onComplete;
  final ValueChanged<int>? onIndexChanged;

  @override
  State<FUIStories> createState() => _FUIStoriesState();
}

class _FUIStoriesState extends State<FUIStories>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.segments.length - 1);
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    _controller
      ..stop()
      ..duration = widget.segments[_index].duration
      ..forward(from: 0);
  }

  void _next() {
    if (_index < widget.segments.length - 1) {
      setState(() => _index++);
      widget.onIndexChanged?.call(_index);
      _start();
    } else {
      _controller.stop();
      widget.onComplete?.call();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() => _index--);
      widget.onIndexChanged?.call(_index);
    }
    _start(); // restart current when already at the first segment
  }

  void _onTapUp(TapUpDetails details, double width) {
    if (details.localPosition.dx < width / 3) {
      _prev();
    } else {
      _next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (d) => _onTapUp(d, constraints.maxWidth),
          onLongPressStart: (_) => _controller.stop(),
          onLongPressEnd: (_) => _controller.forward(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(fui.radii.lg),
            child: ColoredBox(
              color: fui.resolve(fui.colors.background),
              child: Stack(
                children: [
                  Positioned.fill(child: widget.segments[_index].content),
                  Positioned(
                    top: fui.spacing.sm,
                    left: fui.spacing.sm,
                    right: fui.spacing.sm,
                    child: Row(
                      children: [
                        for (var i = 0; i < widget.segments.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: fui.spacing.xs / 2),
                              child: _SegmentBar(
                                controller: _controller,
                                state: i < _index
                                    ? _SegmentState.done
                                    : i == _index
                                        ? _SegmentState.active
                                        : _SegmentState.upcoming,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _SegmentState { done, active, upcoming }

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({required this.controller, required this.state});

  final AnimationController controller;
  final _SegmentState state;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final track = fui.resolve(fui.colors.overlay);
    final fill = fui.resolve(fui.colors.onPrimary);

    return ClipRRect(
      borderRadius: BorderRadius.circular(fui.radii.full),
      child: SizedBox(
        height: 3,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            if (state == _SegmentState.done)
              Positioned.fill(child: ColoredBox(color: fill))
            else if (state == _SegmentState.active)
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: controller.value,
                  child: ColoredBox(color: fill),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
