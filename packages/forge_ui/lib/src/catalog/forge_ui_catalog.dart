import 'package:flutter/material.dart';

import '../components/fui_button.dart';
import '../tokens/fui_tokens.dart';

/// A self-contained gallery of every `FUI` component and token, owned by the
/// design system. Hosts (the playground, internal demos) just drop this widget
/// into a [MaterialApp] — they never reassemble the catalog themselves.
///
/// ```dart
/// MaterialApp(home: ForgeUICatalog());
/// ```
class ForgeUICatalog extends StatelessWidget {
  const ForgeUICatalog({this.tokens = FUITokens.base, super.key});

  /// The tier/brand tokens to preview. Defaults to the base tier.
  final FUITokens tokens;

  @override
  Widget build(BuildContext context) {
    return FUITheme(
      tokens: tokens,
      child: Scaffold(
        backgroundColor: tokens.colors.surface,
        appBar: AppBar(
          title: const Text('Forge UI Catalog'),
          backgroundColor: tokens.colors.primary,
          foregroundColor: tokens.colors.onPrimary,
        ),
        body: ListView(
          padding: EdgeInsets.all(tokens.spacing.md),
          children: const [
            _Section(
              title: 'Buttons',
              child: _ButtonsDemo(),
            ),
            _Section(
              title: 'Colors',
              child: _ColorsDemo(),
            ),
            _Section(
              title: 'Spacing',
              child: _SpacingDemo(),
            ),
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
    final t = FUITheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: t.colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: t.spacing.md),
          child,
        ],
      ),
    );
  }
}

class _ButtonsDemo extends StatelessWidget {
  const _ButtonsDemo();

  @override
  Widget build(BuildContext context) {
    final t = FUITheme.of(context);
    void toast(String label) =>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped "$label"')),
        );

    return Wrap(
      spacing: t.spacing.md,
      runSpacing: t.spacing.md,
      children: [
        FUIButton(
          configuration: const FUIButtonConfiguration(label: 'Primary'),
          onPressed: () => toast('Primary'),
        ),
        FUIButton(
          configuration: const FUIButtonConfiguration(
            label: 'Danger',
            variant: FUIButtonVariant.danger,
          ),
          onPressed: () => toast('Danger'),
        ),
        const FUIButton(
          configuration: FUIButtonConfiguration(
            label: 'Disabled',
            isEnabled: false,
          ),
        ),
      ],
    );
  }
}

class _ColorsDemo extends StatelessWidget {
  const _ColorsDemo();

  @override
  Widget build(BuildContext context) {
    final c = FUITheme.of(context).colors;
    final swatches = <(String, Color)>[
      ('primary', c.primary),
      ('onPrimary', c.onPrimary),
      ('surface', c.surface),
      ('onSurface', c.onSurface),
      ('danger', c.danger),
    ];
    final t = FUITheme.of(context);
    return Wrap(
      spacing: t.spacing.md,
      runSpacing: t.spacing.md,
      children: [
        for (final (name, color) in swatches)
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(t.radii.sm),
                  border: Border.all(
                    color: c.onSurface.withValues(alpha: 0.15),
                  ),
                ),
              ),
              SizedBox(height: t.spacing.xs),
              Text(name, style: const TextStyle(fontSize: 11)),
            ],
          ),
      ],
    );
  }
}

class _SpacingDemo extends StatelessWidget {
  const _SpacingDemo();

  @override
  Widget build(BuildContext context) {
    final t = FUITheme.of(context);
    final steps = <(String, double)>[
      ('xs', t.spacing.xs),
      ('sm', t.spacing.sm),
      ('md', t.spacing.md),
      ('lg', t.spacing.lg),
      ('xl', t.spacing.xl),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, value) in steps)
          Padding(
            padding: EdgeInsets.only(bottom: t.spacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(name, style: const TextStyle(fontSize: 12)),
                ),
                Container(
                  width: value,
                  height: 16,
                  color: t.colors.primary,
                ),
                SizedBox(width: t.spacing.sm),
                Text('${value.toInt()}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }
}
