import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_text.dart';

enum FUIChatSender { inbound, outbound }

enum FUIChatStatus { sent, delivered, read }

/// A single chat message bubble. [FUIChatSender.outbound] bubbles use the brand
/// fill and align right (with a delivery tick when [status] is set); inbound
/// bubbles use a neutral surface and align left, optionally labelled with a
/// [senderName].
class FUIChatBubble extends StatelessWidget {
  const FUIChatBubble({
    required this.message,
    this.sender = FUIChatSender.inbound,
    this.senderName,
    this.timestamp,
    this.status,
    super.key,
  });

  final String message;
  final FUIChatSender sender;
  final String? senderName;
  final String? timestamp;

  /// Delivery state — only meaningful (and only shown) for outbound bubbles.
  final FUIChatStatus? status;

  bool get _outbound => sender == FUIChatSender.outbound;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final radius = Radius.circular(fui.radii.lg);
    const tail = Radius.circular(2);

    final bg = _outbound ? fui.colors.primary : fui.colors.surfaceVariant;
    final textColor = _outbound ? FUITextColor.onPrimary : FUITextColor.primary;
    final metaColor = _outbound ? FUITextColor.onPrimary : FUITextColor.subtle;

    return Align(
      alignment: _outbound ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: fui.spacing.xs),
          padding: EdgeInsets.symmetric(
            horizontal: fui.spacing.md,
            vertical: fui.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: fui.resolve(bg),
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomLeft: _outbound ? radius : tail,
              bottomRight: _outbound ? tail : radius,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (senderName != null && !_outbound)
                FUIText(senderName!,
                    variant: FUITextVariant.caption,
                    color: FUITextColor.secondary),
              FUIText(message, variant: FUITextVariant.body, color: textColor),
              if (timestamp != null || (_outbound && status != null))
                Padding(
                  padding: EdgeInsets.only(top: fui.spacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (timestamp != null)
                        FUIText(timestamp!,
                            variant: FUITextVariant.caption, color: metaColor),
                      if (_outbound && status != null) ...[
                        SizedBox(width: fui.spacing.xs),
                        Icon(
                          status == FUIChatStatus.sent
                              ? FUIIcons.check
                              : FUIIcons.success,
                          size: 14,
                          color: fui.resolve(fui.colors.onPrimary),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
