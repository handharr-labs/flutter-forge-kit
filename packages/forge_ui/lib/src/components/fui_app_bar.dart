import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import 'fui_icon_button.dart';

enum _FUIAppBarKind { text, logo, search }

/// A token-driven app bar implementing [PreferredSizeWidget], so it drops
/// straight into `Scaffold(appBar: ...)`. Three named constructors cover the
/// common shapes:
///
/// - [FUIAppBar.text] — title (+ optional subtitle), back button, trailing
///   actions. The everyday bar.
/// - [FUIAppBar.logo] — a leading brand widget instead of a title.
/// - [FUIAppBar.search] — an inline search field in place of the title.
class FUIAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FUIAppBar.text({
    required String title,
    String? subtitle,
    this.actions,
    this.leading,
    this.showBack = true,
    this.onBack,
    this.centerTitle = false,
    super.key,
  })  : _kind = _FUIAppBarKind.text,
        _title = title,
        _subtitle = subtitle,
        _logo = null,
        _searchHint = null,
        _searchController = null,
        _onSearchChanged = null;

  const FUIAppBar.logo({
    required Widget logo,
    this.actions,
    this.leading,
    this.showBack = false,
    this.onBack,
    super.key,
  })  : _kind = _FUIAppBarKind.logo,
        _logo = logo,
        _title = null,
        _subtitle = null,
        _searchHint = null,
        _searchController = null,
        _onSearchChanged = null,
        centerTitle = false;

  const FUIAppBar.search({
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    this.actions,
    this.leading,
    this.showBack = true,
    this.onBack,
    super.key,
  })  : _kind = _FUIAppBarKind.search,
        _searchHint = hint,
        _searchController = controller,
        _onSearchChanged = onChanged,
        _title = null,
        _subtitle = null,
        _logo = null,
        centerTitle = false;

  final _FUIAppBarKind _kind;
  final String? _title;
  final String? _subtitle;
  final Widget? _logo;
  final String? _searchHint;
  final TextEditingController? _searchController;
  final ValueChanged<String>? _onSearchChanged;

  /// Trailing widgets (typically [FUIIconButton]-like taps).
  final List<Widget>? actions;

  /// A custom leading widget; overrides the automatic back button.
  final Widget? leading;

  /// Whether to show an automatic back button when [leading] is null and the
  /// route can pop.
  final bool showBack;
  final VoidCallback? onBack;

  final bool centerTitle;

  static const double _height = 56;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final fg = fui.resolve(fui.colors.onSurface);

    return Material(
      color: fui.resolve(fui.colors.surface),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: fui.spacing.sm),
            child: Row(
              children: [
                _buildLeading(context, fui, fg),
                Expanded(child: _buildCenter(context, fui, fg)),
                ..._buildActions(fui),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context, FUIThemeData fui, Color fg) {
    if (leading != null) {
      return Padding(
        padding: EdgeInsets.only(right: fui.spacing.xs),
        child: leading,
      );
    }
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    if (!showBack || !canPop) {
      return SizedBox(width: fui.spacing.sm);
    }
    return FUIIconButton(
      icon: FUIIcons.back,
      onPressed: onBack ?? () => Navigator.maybePop(context),
    );
  }

  Widget _buildCenter(BuildContext context, FUIThemeData fui, Color fg) {
    switch (_kind) {
      case _FUIAppBarKind.logo:
        return Align(alignment: Alignment.centerLeft, child: _logo);
      case _FUIAppBarKind.search:
        return _SearchField(
          hint: _searchHint ?? 'Search',
          controller: _searchController,
          onChanged: _onSearchChanged,
        );
      case _FUIAppBarKind.text:
        final column = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: centerTitle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              _title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: fui.typography.titleMd.copyWith(color: fg),
            ),
            if (_subtitle != null)
              Text(
                _subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: fui.typography.caption
                    .copyWith(color: fui.resolve(fui.colors.textSecondary)),
              ),
          ],
        );
        return Align(
          alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
          child: column,
        );
    }
  }

  List<Widget> _buildActions(FUIThemeData fui) {
    final items = actions;
    if (items == null || items.isEmpty) return const [];
    return [
      for (final action in items)
        Padding(
          padding: EdgeInsets.only(left: fui.spacing.xs),
          child: action,
        ),
    ];
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.hint,
    this.controller,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: fui.typography.bodySm
            .copyWith(color: fui.resolve(fui.colors.onSurface)),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fui.resolve(fui.colors.surfaceVariant),
          hintText: hint,
          hintStyle: fui.typography.bodySm
              .copyWith(color: fui.resolve(fui.colors.textSubtle)),
          prefixIcon: Icon(FUIIcons.search,
              size: 20, color: fui.resolve(fui.colors.textSecondary)),
          contentPadding: EdgeInsets.symmetric(vertical: fui.spacing.sm),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fui.radii.full),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
