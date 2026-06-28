import 'package:flutter/material.dart';

import '../components/fui_accordion.dart';
import '../components/fui_app_bar.dart';
import '../components/fui_avatar.dart';
import '../components/fui_badge.dart';
import '../components/fui_banner.dart';
import '../components/fui_blank_slate.dart';
import '../components/fui_bottom_nav_bar.dart';
import '../components/fui_bottom_sheet.dart';
import '../components/fui_button.dart';
import '../components/fui_card.dart';
import '../components/fui_checkbox.dart';
import '../components/fui_checkbox_list_tile.dart';
import '../components/fui_chip.dart';
import '../components/fui_dialog.dart';
import '../components/fui_divider.dart';
import '../components/fui_icon.dart';
import '../components/fui_icon_button.dart';
import '../components/fui_list_tile.dart';
import '../components/fui_page_control.dart';
import '../components/fui_progress_indicator.dart';
import '../components/fui_radio.dart';
import '../components/fui_radio_list_tile.dart';
import '../components/fui_segmented_control.dart';
import '../components/fui_select.dart';
import '../components/fui_shimmer.dart';
import '../components/fui_slider.dart';
import '../components/fui_status.dart';
import '../components/fui_stepper.dart';
import '../components/fui_switch.dart';
import '../components/fui_toggle_list_tile.dart';
import '../components/fui_tabs.dart';
import '../components/fui_tag.dart';
import '../components/fui_text.dart';
import '../components/fui_text_field.dart';
import '../components/fui_toast.dart';
import '../components/fui_tooltip.dart';
import '../tokens/fui_tokens.dart';

/// A self-contained gallery of every `FUI` component and token, owned by the
/// design system. Hosts (the playground, internal demos) just drop this widget
/// into a [MaterialApp] — they never reassemble the catalog themselves.
///
/// ```dart
/// MaterialApp(home: ForgeUICatalog());
/// ```
///
/// The app bar carries a light/dark toggle so reviewers can see every component
/// in both brightnesses without restarting the host.
class ForgeUICatalog extends StatefulWidget {
  const ForgeUICatalog({this.tokens = FUITokens.base, super.key});

  /// The tier/brand tokens to preview. Defaults to the base tier.
  final FUITokens tokens;

  @override
  State<ForgeUICatalog> createState() => _ForgeUICatalogState();
}

class _ForgeUICatalogState extends State<ForgeUICatalog> {
  Brightness _brightness = Brightness.light;

  void _toggleBrightness() => setState(() {
        _brightness = _brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;
      });

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final isDark = _brightness == Brightness.dark;
    final bg = tokens.colors.background.resolve(_brightness);

    return FUITheme(
      tokens: tokens,
      brightness: _brightness,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: const Text('Forge UI Catalog'),
          backgroundColor: tokens.colors.primary.resolve(_brightness),
          foregroundColor: tokens.colors.onPrimary.resolve(_brightness),
          actions: [
            IconButton(
              tooltip: isDark ? 'Switch to light' : 'Switch to dark',
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleBrightness,
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(tokens.spacing.lg),
          children: const [
            _Section(title: 'Foundations', child: _FoundationsDemo()),
            _Section(title: 'Buttons', child: _ButtonsDemo()),
            _Section(title: 'Typography', child: _TypographyDemo()),
            _Section(title: 'Inputs', child: _InputsDemo()),
            _Section(title: 'Selection controls', child: _SelectionDemo()),
            _Section(title: 'Status · tags · badges', child: _StatusDemo()),
            _Section(title: 'Banners', child: _BannersDemo()),
            _Section(title: 'Navigation', child: _NavigationDemo()),
            _Section(title: 'Overlays', child: _OverlaysDemo()),
            _Section(title: 'Settings rows', child: _ListRowsDemo()),
            _Section(title: 'Progress · skeletons', child: _ProgressDemo()),
            _Section(title: 'Pickers · disclosure', child: _PickersDemo()),
            _Section(title: 'App shell', child: _AppShellDemo()),
            _Section(title: 'Empty state', child: _BlankSlateDemo()),
            _Section(title: 'Containers', child: _ContainersDemo()),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: fui.spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FUIText(title.toUpperCase(),
              variant: FUITextVariant.overline, color: FUITextColor.subtle),
          SizedBox(height: fui.spacing.md),
          child,
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── Foundations ──

class _FoundationsDemo extends StatelessWidget {
  const _FoundationsDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final swatches = <(String, FUIColor)>[
      ('primary', fui.colors.primary),
      ('surface', fui.colors.surface),
      ('onSurface', fui.colors.onSurface),
      ('border', fui.colors.border),
      ('success', fui.colors.success),
      ('warning', fui.colors.warning),
      ('danger', fui.colors.danger),
      ('info', fui.colors.info),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: fui.spacing.md,
          runSpacing: fui.spacing.md,
          children: [
            for (final (name, color) in swatches)
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: fui.resolve(color),
                      borderRadius: BorderRadius.circular(fui.radii.sm),
                      border: Border.all(color: fui.resolve(fui.colors.border)),
                    ),
                  ),
                  SizedBox(height: fui.spacing.xs),
                  FUIText(name,
                      variant: FUITextVariant.caption,
                      color: FUITextColor.secondary),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────── Buttons ──

class _ButtonsDemo extends StatelessWidget {
  const _ButtonsDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Wrap(
      spacing: fui.spacing.md,
      runSpacing: fui.spacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FUIButton(
          configuration: const FUIButtonConfiguration(label: 'Primary'),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Secondary', variant: FUIButtonVariant.secondary),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Tertiary', variant: FUIButtonVariant.tertiary),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Ghost', variant: FUIButtonVariant.ghost),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Danger', variant: FUIButtonVariant.danger),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'With icon', icon: Icons.bolt),
          onPressed: () {},
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Small', size: FUIButtonSize.small),
          onPressed: () {},
        ),
        const FUIButton(
          configuration:
              FUIButtonConfiguration(label: 'Loading', isLoading: true),
        ),
        const FUIButton(
          configuration:
              FUIButtonConfiguration(label: 'Disabled', isEnabled: false),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────── Typography ──

class _TypographyDemo extends StatelessWidget {
  const _TypographyDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    const samples = <(String, FUITextVariant)>[
      ('Title large', FUITextVariant.titleLg),
      ('Title medium', FUITextVariant.titleMd),
      ('Body text', FUITextVariant.body),
      ('Body small', FUITextVariant.bodySm),
      ('Caption', FUITextVariant.caption),
      ('OVERLINE', FUITextVariant.overline),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, variant) in samples)
          Padding(
            padding: EdgeInsets.only(bottom: fui.spacing.sm),
            child: FUIText(label, variant: variant),
          ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────── Inputs ──

class _InputsDemo extends StatelessWidget {
  const _InputsDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      children: [
        const FUITextField(
          configuration: FUITextFieldConfiguration(
            label: 'Email',
            hint: 'you@example.com',
            helperText: 'We never share your address.',
            prefixIcon: Icons.mail_outline,
          ),
        ),
        SizedBox(height: fui.spacing.lg),
        const FUITextField(
          configuration: FUITextFieldConfiguration(
            label: 'Password',
            hint: '••••••••',
            obscureText: true,
            errorText: 'Password is too short.',
            prefixIcon: Icons.lock_outline,
          ),
        ),
        SizedBox(height: fui.spacing.lg),
        const FUITextField(
          configuration: FUITextFieldConfiguration(
            label: 'Disabled',
            hint: 'Unavailable',
            isEnabled: false,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────── Selection controls ──

class _SelectionDemo extends StatefulWidget {
  const _SelectionDemo();

  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  bool _checked = true;
  bool _switched = true;
  String _radio = 'a';

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FUICheckbox(
          state:
              _checked ? FUICheckboxState.checked : FUICheckboxState.unchecked,
          label: 'Subscribe to updates',
          onChanged: (v) => setState(() => _checked = v),
        ),
        SizedBox(height: fui.spacing.md),
        FUIRadio<String>(
          value: 'a',
          groupValue: _radio,
          label: 'Option A',
          onChanged: (v) => setState(() => _radio = v),
        ),
        SizedBox(height: fui.spacing.sm),
        FUIRadio<String>(
          value: 'b',
          groupValue: _radio,
          label: 'Option B',
          onChanged: (v) => setState(() => _radio = v),
        ),
        SizedBox(height: fui.spacing.md),
        Row(
          children: [
            FUISwitch(
              value: _switched,
              onChanged: (v) => setState(() => _switched = v),
            ),
            SizedBox(width: fui.spacing.sm),
            FUIText(_switched ? 'On' : 'Off',
                variant: FUITextVariant.bodySm, color: FUITextColor.secondary),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────── Status · tags · badges ──

class _StatusDemo extends StatelessWidget {
  const _StatusDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: fui.spacing.sm,
          runSpacing: fui.spacing.sm,
          children: const [
            FUITag(label: 'Neutral'),
            FUITag(label: 'Info', status: FUIStatus.info),
            FUITag(label: 'Success', status: FUIStatus.success),
            FUITag(label: 'Warning', status: FUIStatus.warning),
            FUITag(
                label: 'Removable', status: FUIStatus.danger, onRemove: _noop),
          ],
        ),
        SizedBox(height: fui.spacing.md),
        Row(
          children: [
            const FUIBadge(label: '3'),
            SizedBox(width: fui.spacing.md),
            const FUIBadge(label: '99+', status: FUIStatus.info),
            SizedBox(width: fui.spacing.md),
            const FUIBadge.dot(status: FUIStatus.success),
            SizedBox(width: fui.spacing.md),
            FUIChip(label: 'Filter', icon: Icons.tune, onTap: () {}),
            SizedBox(width: fui.spacing.sm),
            FUIChip(label: 'Selected', selected: true, onTap: () {}),
          ],
        ),
      ],
    );
  }

  static void _noop() {}
}

// ───────────────────────────────────────────────────────────── Banners ──

class _BannersDemo extends StatelessWidget {
  const _BannersDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      children: [
        const FUIBanner(
          configuration: FUIBannerConfiguration(
            status: FUIStatus.info,
            title: 'Heads up',
            message: 'A new version of the kit is available.',
          ),
        ),
        SizedBox(height: fui.spacing.md),
        const FUIBanner(
          configuration: FUIBannerConfiguration(
            status: FUIStatus.success,
            message: 'Your changes were saved.',
          ),
        ),
        SizedBox(height: fui.spacing.md),
        const FUIBanner(
          configuration: FUIBannerConfiguration(
            status: FUIStatus.danger,
            title: 'Something went wrong',
            message: 'We could not reach the server. Try again.',
            dismissible: true,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────── Containers ──

class _ContainersDemo extends StatelessWidget {
  const _ContainersDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      children: [
        FUICard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FUIText('Card title', variant: FUITextVariant.titleMd),
              SizedBox(height: fui.spacing.xs),
              const FUIText(
                'A surface container with token-driven padding and border.',
                variant: FUITextVariant.bodySm,
                color: FUITextColor.secondary,
              ),
            ],
          ),
        ),
        SizedBox(height: fui.spacing.md),
        const FUIDivider(label: 'or'),
        SizedBox(height: fui.spacing.md),
        FUICard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              FUIListTile(
                leading: const FUIAvatar(name: 'Ada Lovelace'),
                title: 'Ada Lovelace',
                subtitle: 'ada@forge.dev',
                trailing: const FUIBadge.dot(status: FUIStatus.success),
                onTap: () {},
              ),
              const FUIDivider(),
              FUIListTile(
                leading: const FUIAvatar(
                    name: 'Grace Hopper', size: FUIAvatarSize.sm),
                title: 'Grace Hopper',
                subtitle: 'grace@forge.dev',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────── Navigation ──

class _NavigationDemo extends StatefulWidget {
  const _NavigationDemo();

  @override
  State<_NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<_NavigationDemo> {
  int _tab = 0;
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(fui.radii.md),
          child: SizedBox(
            height: 56,
            child: FUIAppBar.text(
              title: 'Inbox',
              subtitle: '3 unread',
              showBack: false,
              actions: [
                FUIIconButton(icon: Icons.search, onPressed: () {}),
                FUIIconButton(icon: Icons.more_vert, onPressed: () {}),
              ],
            ),
          ),
        ),
        SizedBox(height: fui.spacing.lg),
        Row(
          children: [
            FUIIconButton(icon: Icons.favorite_border, onPressed: () {}),
            SizedBox(width: fui.spacing.sm),
            FUIIconButton(
              icon: Icons.bookmark_border,
              variant: FUIIconButtonVariant.tonal,
              onPressed: () {},
            ),
            SizedBox(width: fui.spacing.sm),
            FUIIconButton(
              icon: Icons.add,
              variant: FUIIconButtonVariant.filled,
              onPressed: () {},
            ),
            SizedBox(width: fui.spacing.sm),
            const FUIIconButton(icon: Icons.lock, isEnabled: false),
          ],
        ),
        SizedBox(height: fui.spacing.lg),
        FUITabs(
          items: const ['All', 'Unread', 'Archived'],
          selectedIndex: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        SizedBox(height: fui.spacing.lg),
        FUISegmentedControl(
          items: const ['Day', 'Week', 'Month'],
          selectedIndex: _segment,
          onChanged: (i) => setState(() => _segment = i),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────── Overlays ──

class _OverlaysDemo extends StatelessWidget {
  const _OverlaysDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Wrap(
      spacing: fui.spacing.md,
      runSpacing: fui.spacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Bottom sheet', variant: FUIButtonVariant.secondary),
          onPressed: () => showFUIBottomSheet(
            context,
            configuration: FUIBottomSheetConfiguration(
              title: 'Choose an option',
              showClose: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FUIListTile(
                    leading: const FUIIcon(Icons.share),
                    title: 'Share',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  FUIListTile(
                    leading: const FUIIcon(Icons.edit),
                    title: 'Edit',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  FUIListTile(
                    leading: const FUIIcon(Icons.delete_outline),
                    title: 'Delete',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Dialog', variant: FUIButtonVariant.secondary),
          onPressed: () => showFUIDialog(
            context,
            configuration: const FUIDialogConfiguration(
              title: 'Delete item?',
              message: 'This action cannot be undone.',
              confirmLabel: 'Delete',
              cancelLabel: 'Cancel',
              destructive: true,
            ),
          ),
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
              label: 'Toast', variant: FUIButtonVariant.secondary),
          onPressed: () => showFUIToast(
            context,
            message: 'Changes saved',
            status: FUIStatus.success,
          ),
        ),
        FUITooltip(
          message: 'Helpful hint',
          child: FUIButton(
            configuration: const FUIButtonConfiguration(
                label: 'Tooltip', variant: FUIButtonVariant.ghost),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────── Settings rows ──

class _ListRowsDemo extends StatefulWidget {
  const _ListRowsDemo();

  @override
  State<_ListRowsDemo> createState() => _ListRowsDemoState();
}

class _ListRowsDemoState extends State<_ListRowsDemo> {
  bool _wifi = true;
  bool _backup = false;
  String _quality = 'high';

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return FUICard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          FUIToggleListTile(
            title: 'Wi-Fi only',
            subtitle: 'Sync over Wi-Fi to save data',
            leading: const FUIIcon(Icons.wifi),
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
          ),
          const FUIDivider(),
          FUICheckboxListTile(
            title: 'Auto-backup',
            leading: const FUIIcon(Icons.cloud_upload_outlined),
            value: _backup,
            onChanged: (v) => setState(() => _backup = v),
          ),
          const FUIDivider(),
          FUIRadioListTile<String>(
            title: 'High quality',
            value: 'high',
            groupValue: _quality,
            onChanged: (v) => setState(() => _quality = v),
          ),
          FUIRadioListTile<String>(
            title: 'Data saver',
            value: 'low',
            groupValue: _quality,
            onChanged: (v) => setState(() => _quality = v),
          ),
          SizedBox(height: fui.spacing.sm),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────── Progress · skeletons ──

class _ProgressDemo extends StatelessWidget {
  const _ProgressDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FUIProgressIndicator.linear(value: 0.6),
        SizedBox(height: fui.spacing.md),
        Row(
          children: const [
            FUIProgressIndicator.circular(value: 0.7),
            SizedBox(width: 16),
            FUIProgressIndicator.circular(),
          ],
        ),
        SizedBox(height: fui.spacing.lg),
        Row(
          children: [
            const FUIShimmer(
              child:
                  CircleAvatar(radius: 20, backgroundColor: Color(0xFFFFFFFF)),
            ),
            SizedBox(width: fui.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FUIShimmer.box(height: 12, width: 140),
                  SizedBox(height: fui.spacing.sm),
                  FUIShimmer.box(height: 12, width: double.infinity),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────── Pickers · disclosure ──

class _PickersDemo extends StatefulWidget {
  const _PickersDemo();

  @override
  State<_PickersDemo> createState() => _PickersDemoState();
}

class _PickersDemoState extends State<_PickersDemo> {
  String? _country;
  double _volume = 0.4;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FUIStepper(
          steps: const ['Cart', 'Address', 'Payment'],
          currentStep: 1,
        ),
        SizedBox(height: fui.spacing.xl),
        FUISelect<String>(
          label: 'Country',
          hint: 'Choose a country',
          value: _country,
          options: const [
            FUISelectOption(value: 'id', label: 'Indonesia'),
            FUISelectOption(value: 'sg', label: 'Singapore'),
            FUISelectOption(value: 'my', label: 'Malaysia'),
          ],
          onChanged: (v) => setState(() => _country = v),
        ),
        SizedBox(height: fui.spacing.lg),
        FUIText('Volume', variant: FUITextVariant.label),
        FUISlider(
          value: _volume,
          divisions: 10,
          max: 1,
          onChanged: (v) => setState(() => _volume = v),
        ),
        SizedBox(height: fui.spacing.md),
        const FUIAccordion(
          title: 'Shipping details',
          subtitle: 'Tap to expand',
          initiallyExpanded: true,
          child: Text(
            'Standard shipping arrives in 3–5 business days. Express options '
            'are available at checkout.',
          ),
        ),
        SizedBox(height: fui.spacing.sm),
        const FUIAccordion(
          title: 'Returns policy',
          child: Text('Returns accepted within 30 days of delivery.'),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────── App shell ──

class _AppShellDemo extends StatefulWidget {
  const _AppShellDemo();

  @override
  State<_AppShellDemo> createState() => _AppShellDemoState();
}

class _AppShellDemoState extends State<_AppShellDemo> {
  int _tab = 0;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FUIPageControl(count: 4, currentIndex: _page),
        SizedBox(height: fui.spacing.sm),
        FUISegmentedControl(
          items: const ['1', '2', '3', '4'],
          selectedIndex: _page,
          onChanged: (i) => setState(() => _page = i),
        ),
        SizedBox(height: fui.spacing.lg),
        ClipRRect(
          borderRadius: BorderRadius.circular(fui.radii.md),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: fui.resolve(fui.colors.border)),
              borderRadius: BorderRadius.circular(fui.radii.md),
            ),
            child: FUIBottomNavBar(
              currentIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
              items: const [
                FUIBottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                ),
                FUIBottomNavItem(
                  icon: Icons.search,
                  label: 'Search',
                ),
                FUIBottomNavItem(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Alerts',
                ),
                FUIBottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────── Empty state ──

class _BlankSlateDemo extends StatelessWidget {
  const _BlankSlateDemo();

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.circular(fui.radii.lg),
        border: Border.all(color: fui.resolve(fui.colors.border)),
      ),
      child: SizedBox(
        height: 320,
        child: FUIBlankSlate(
          icon: Icons.inbox_outlined,
          title: 'No messages yet',
          message: 'When you receive messages, they will show up here.',
          actionLabel: 'Refresh',
          onAction: () {},
        ),
      ),
    );
  }
}
