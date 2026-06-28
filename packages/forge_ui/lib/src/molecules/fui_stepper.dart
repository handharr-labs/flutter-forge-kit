import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';

/// A horizontal step-progress header: numbered nodes joined by connectors, with
/// labels beneath. Steps before [currentStep] read as complete, the current one
/// is active, and later steps are pending.
class FUIStepper extends StatelessWidget {
  const FUIStepper({
    required this.steps,
    required this.currentStep,
    super.key,
  });

  final List<String> steps;

  /// Zero-based index of the active step.
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: _Step(
              index: i,
              label: steps[i],
              state: i < currentStep
                  ? _StepState.complete
                  : i == currentStep
                      ? _StepState.active
                      : _StepState.pending,
              isFirst: i == 0,
              isLast: i == steps.length - 1,
              fui: fui,
            ),
          ),
      ],
    );
  }
}

enum _StepState { complete, active, pending }

class _Step extends StatelessWidget {
  const _Step({
    required this.index,
    required this.label,
    required this.state,
    required this.isFirst,
    required this.isLast,
    required this.fui,
  });

  final int index;
  final String label;
  final _StepState state;
  final bool isFirst;
  final bool isLast;
  final FUIThemeData fui;

  @override
  Widget build(BuildContext context) {
    final active = fui.resolve(fui.colors.primary);
    final pending = fui.resolve(fui.colors.border);
    final done = state == _StepState.complete;
    final isActive = state == _StepState.active;
    final nodeColor = done || isActive ? active : pending;

    Widget connector(bool filled) => Expanded(
          child: Container(
            height: 2,
            color: filled ? active : pending,
          ),
        );

    return Column(
      children: [
        Row(
          children: [
            connector(!isFirst && (done || isActive)),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? active : fui.resolve(fui.colors.surface),
                border: Border.all(color: nodeColor, width: 2),
              ),
              child: done
                  ? Icon(FUIIcons.check,
                      size: 14, color: fui.resolve(fui.colors.onPrimary))
                  : Text(
                      '${index + 1}',
                      style: fui.typography.caption.copyWith(
                        color: isActive
                            ? active
                            : fui.resolve(fui.colors.textSubtle),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            connector(!isLast && done),
          ],
        ),
        SizedBox(height: fui.spacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: fui.typography.caption.copyWith(
            color: done || isActive
                ? fui.resolve(fui.colors.onSurface)
                : fui.resolve(fui.colors.textSubtle),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
