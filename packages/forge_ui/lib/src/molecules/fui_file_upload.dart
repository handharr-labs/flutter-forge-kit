import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_icon_button.dart';
import '../atoms/fui_progress_indicator.dart';
import '../atoms/fui_text.dart';

/// One row in a [FUIFileUpload] list.
@immutable
class FUIUploadItem {
  const FUIUploadItem({
    required this.name,
    this.size,
    this.progress,
    this.failed = false,
  });

  final String name;

  /// Human-readable size, e.g. "2.4 MB".
  final String? size;

  /// 0..1 while uploading; null once complete.
  final double? progress;
  final bool failed;
}

/// File-upload *UI* (no native picking): a tappable dashed drop zone plus a
/// list of selected files showing name / size / progress and a remove button.
/// The caller wires [onTap] to its own file picker and feeds back [files].
class FUIFileUpload extends StatelessWidget {
  const FUIFileUpload({
    this.prompt = 'Tap to upload',
    this.hint,
    this.onTap,
    this.files = const [],
    this.onRemove,
    super.key,
  });

  final String prompt;
  final String? hint;
  final VoidCallback? onTap;
  final List<FUIUploadItem> files;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: CustomPaint(
            painter: _DashedRRectPainter(
              color: fui.resolve(fui.colors.borderStrong),
              radius: fui.radii.lg,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: fui.spacing.xl),
              child: Column(
                children: [
                  Icon(FUIIcons.upload,
                      size: 32, color: fui.resolve(fui.colors.textSecondary)),
                  SizedBox(height: fui.spacing.sm),
                  FUIText(prompt, variant: FUITextVariant.label),
                  if (hint != null)
                    FUIText(hint!,
                        variant: FUITextVariant.caption,
                        color: FUITextColor.subtle),
                ],
              ),
            ),
          ),
        ),
        for (var i = 0; i < files.length; i++) ...[
          SizedBox(height: fui.spacing.sm),
          _FileRow(
            item: files[i],
            onRemove: onRemove == null ? null : () => onRemove!(i),
          ),
        ],
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.item, this.onRemove});

  final FUIUploadItem item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final uploading = item.progress != null && item.progress! < 1;
    final leadingColor = item.failed
        ? fui.resolve(fui.colors.danger)
        : fui.resolve(fui.colors.textSecondary);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fui.spacing.md,
        vertical: fui.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surfaceVariant),
        borderRadius: BorderRadius.circular(fui.radii.md),
      ),
      child: Row(
        children: [
          Icon(item.failed ? FUIIcons.error : FUIIcons.file,
              size: 20, color: leadingColor),
          SizedBox(width: fui.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FUIText(item.name,
                    variant: FUITextVariant.bodySm,
                    color: item.failed
                        ? FUITextColor.danger
                        : FUITextColor.primary),
                if (uploading) ...[
                  SizedBox(height: fui.spacing.xs),
                  FUIProgressIndicator.linear(value: item.progress),
                ] else if (item.size != null)
                  FUIText(item.size!,
                      variant: FUITextVariant.caption,
                      color: FUITextColor.subtle),
              ],
            ),
          ),
          if (onRemove != null)
            FUIIconButton(icon: FUIIcons.close, onPressed: onRemove),
        ],
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border (Flutter ships no dashed border).
class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}
