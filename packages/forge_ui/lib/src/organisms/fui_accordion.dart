import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A collapsible disclosure section: a tappable header that expands to reveal
/// [child]. Manages its own expanded state, seeded by [initiallyExpanded].
class FUIAccordion extends StatefulWidget {
  const FUIAccordion({
    required this.title,
    required this.child,
    this.subtitle,
    this.initiallyExpanded = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<FUIAccordion> createState() => _FUIAccordionState();
}

class _FUIAccordionState extends State<FUIAccordion>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.circular(fui.radii.md),
        border: Border.all(color: fui.resolve(fui.colors.border)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(fui.spacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: fui.typography.label.copyWith(
                              color: fui.resolve(fui.colors.onSurface)),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: fui.spacing.xs),
                          Text(
                            widget.subtitle!,
                            style: fui.typography.caption.copyWith(
                                color: fui.resolve(fui.colors.textSecondary)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(FUIIcons.chevronDown,
                        color: fui.resolve(fui.colors.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                fui.spacing.lg,
                0,
                fui.spacing.lg,
                fui.spacing.lg,
              ),
              child: DefaultTextStyle(
                style: fui.typography.bodySm
                    .copyWith(color: fui.resolve(fui.colors.textSecondary)),
                child: widget.child,
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
