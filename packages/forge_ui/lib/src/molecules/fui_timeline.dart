import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_text.dart';

enum FUITimelineStatus { done, active, pending }

/// One event in a [FUITimeline].
@immutable
class FUITimelineNode {
  const FUITimelineNode({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.status = FUITimelineStatus.pending,
  });

  final String title;
  final String? subtitle;
  final String? timestamp;
  final FUITimelineStatus status;
}

/// A vertical sequence of events: a status dot per node joined by a connector
/// line, with title / optional subtitle / optional timestamp alongside.
class FUITimeline extends StatelessWidget {
  const FUITimeline({required this.nodes, super.key});

  final List<FUITimelineNode> nodes;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < nodes.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Rail(
                  status: nodes[i].status,
                  isFirst: i == 0,
                  isLast: i == nodes.length - 1,
                ),
                SizedBox(width: fui.spacing.md),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: fui.spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FUIText(nodes[i].title, variant: FUITextVariant.label),
                        if (nodes[i].subtitle != null)
                          FUIText(nodes[i].subtitle!,
                              variant: FUITextVariant.bodySm,
                              color: FUITextColor.secondary),
                        if (nodes[i].timestamp != null)
                          FUIText(nodes[i].timestamp!,
                              variant: FUITextVariant.caption,
                              color: FUITextColor.subtle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The dot-and-line gutter for a single node.
class _Rail extends StatelessWidget {
  const _Rail({
    required this.status,
    required this.isFirst,
    required this.isLast,
  });

  final FUITimelineStatus status;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final lineColor = fui.resolve(fui.colors.border);

    final FUIColor dotToken;
    switch (status) {
      case FUITimelineStatus.done:
        dotToken = fui.colors.primary;
      case FUITimelineStatus.active:
        dotToken = fui.colors.primary;
      case FUITimelineStatus.pending:
        dotToken = fui.colors.borderStrong;
    }
    final dotColor = fui.resolve(dotToken);
    final isActive = status == FUITimelineStatus.active;

    return SizedBox(
      width: 16,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 2,
              color: isFirst ? const Color(0x00000000) : lineColor,
            ),
          ),
          Container(
            width: isActive ? 14 : 10,
            height: isActive ? 14 : 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status == FUITimelineStatus.pending
                  ? fui.resolve(fui.colors.surface)
                  : dotColor,
              border: Border.all(color: dotColor, width: 2),
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? const Color(0x00000000) : lineColor,
            ),
          ),
        ],
      ),
    );
  }
}
