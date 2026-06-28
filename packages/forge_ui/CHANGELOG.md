# Changelog

All notable changes to `forge_ui` are documented here.

## Unreleased

### Added
- `FUIIcons` — the kit's curated icon vocabulary. Semantic, brand-controlled
  glyph constants (`FUIIcons.search`, `FUIIcons.chevronDown`, …) so call sites
  no longer reach into Flutter's `Icons.*` directly — the same token-first
  discipline already applied to colors and spacing. Backed by Material glyphs
  today (no assets), repointable to a custom icon font later without touching a
  single call site. Exported via `fui_tokens.dart`; demoed in a new catalog
  **Iconography** section.

### Changed
- Migrated every `Icons.*` usage inside the package (41 call sites across 10
  files — both internal widget glyphs and catalog examples) to `FUIIcons.*`.

### Tests
- Hardening pass: closed all 14 zero-coverage gaps (`FUIText`, `FUIBadge`,
  `FUITag`, `FUIChip`, `FUIDivider`, `FUIAvatar`, `FUICard`, `FUIListTile`,
  `FUIRadio`, `FUISwitch`, `FUITooltip`, plus the `FUIStatusColors` token) and
  deepened `FUIButton` (variants, sizes, icon positions, fullWidth). Suite grew
  36 → 73 tests, including brightness-aware token resolution.

## 0.1.0

First real cut of the token-first design system — the Flutter counterpart of the
iOS/Web Forge Kits. Grows the package from a one-button skeleton into 35 `FUI*`
widgets across foundation, atoms, and components, all driven by `*Configuration`
APIs and resolved from `FUITheme.of(context)` with light + dark support from day one.

### Tokens / foundations
- `FUIColor` (`{light, dark}` value type + `resolve(Brightness)`)
- `FUIColors` semantic palette (`FUIColors.base`)
- `FUISpacing` (8pt scale), `FUIRadii`, `FUITypography` (8-step, color-free)
- `FUITokens`, `FUITheme` (InheritedWidget, optional `brightness`), `FUIThemeData`

### Atoms
- `FUIButton` (variants primary/secondary/tertiary/ghost/danger; sizes; icon;
  loading; fullWidth), `FUIText`, `FUIIcon`, `FUIIconButton` (plain/tonal/filled)
- `FUITextField`, `FUICheckbox`, `FUIRadio`, `FUISwitch`
- `FUIBadge`, `FUITag`, `FUIDivider`, `FUIAvatar`
- `FUIShimmer`, `FUIProgressIndicator` (linear/circular)

### Components
- `FUICard`, `FUIBanner`, `FUIChip`, `FUIListTile`
- `FUIAppBar` (`.text`/`.logo`/`.search`), `FUIBottomSheet`, `FUIDialog`
- `FUITabs`, `FUISegmentedControl`, `FUIToast`, `FUITooltip`
- `FUICheckboxListTile`, `FUIRadioListTile`, `FUIToggleListTile`
- `FUISelect`, `FUISlider`, `FUIAccordion`, `FUIStepper`
- `FUIBottomNavBar`, `FUIPageControl`, `FUIBlankSlate` (icon-only)

### Catalog
- `ForgeUICatalog` — single self-describing gallery (15 sections, light/dark
  toggle) living in the design system; hosts just mount it.

### Notes
- Overlays (bottom sheet, dialog, toast) re-provide `FUITheme` across the modal
  route boundary so tokens resolve inside their subtree.
- Icons accept any `IconData` (no bundled asset set yet). `FUIBlankSlate` is
  icon-only pending illustration assets.
