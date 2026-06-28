import 'package:flutter/widgets.dart';

import '../tokens/fui_tokens.dart';

enum FUIAvatarSize { sm, md, lg }

/// A circular avatar showing an image when [imageProvider] is given, otherwise
/// initials derived from [name] on a tinted surface.
class FUIAvatar extends StatelessWidget {
  const FUIAvatar({
    required this.name,
    this.imageProvider,
    this.size = FUIAvatarSize.md,
    super.key,
  });

  final String name;
  final ImageProvider? imageProvider;
  final FUIAvatarSize size;

  double get _diameter {
    switch (size) {
      case FUIAvatarSize.sm:
        return 32;
      case FUIAvatarSize.md:
        return 40;
      case FUIAvatarSize.lg:
        return 56;
    }
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final diameter = _diameter;

    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fui.resolve(fui.colors.primarySubtle),
        image: imageProvider == null
            ? null
            : DecorationImage(image: imageProvider!, fit: BoxFit.cover),
      ),
      child: imageProvider != null
          ? null
          : Text(
              _initials,
              style: fui.typography.label.copyWith(
                color: fui.resolve(fui.colors.primary),
                fontSize: diameter * 0.36,
              ),
            ),
    );
  }
}
