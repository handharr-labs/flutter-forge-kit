# Changelog

All notable changes to `forge_ui` are documented here.

## Unreleased

## 0.2.0 — 2026-06-29

Grows the kit from 35 to **46 widgets** and reorganizes the source tree along
atomic-design lines. Public API stays a single flat barrel
(`package:forge_ui/forge_ui.dart`), so the move is non-breaking for consumers.

### Added
- `FUIIcons` — the kit's curated icon vocabulary. Semantic, brand-controlled
  glyph constants (`FUIIcons.search`, `FUIIcons.chevronDown`, …) so call sites
  no longer reach into Flutter's `Icons.*` directly — the same token-first
  discipline already applied to colors and spacing. Backed by Material glyphs
  today (no assets), repointable to a custom icon font later without touching a
  single call site. Exported via `fui_tokens.dart`; demoed in a new catalog
  **Iconography** section. (Added `image`, `imageBroken`, `file`, `chevronLeft`.)
- `FUIImage` (atom) — code-only imagery: token corner radius / fit / aspect
  ratio with built-in loading and error states, rendering any consumer-supplied
  `ImageProvider`. No bundled assets, no new dependency.
- Long-tail batch 1 — `FUISearchField`, `FUIOtpField`, `FUIFab` (atoms) and
  `FUIContextMenu` / `showFUIContextMenu` (organism).
- Long-tail batch 2 — `FUITimeline`, `FUIChatBubble`, `FUIFileUpload` (UI only)
  (molecules) and `FUICalendar` (organism, pure `DateTime`).
- Long-tail batch 3 — `FUICountryPicker` / `showFUICountryPicker` (organism;
  flags derived from the ISO code as emoji, bundled `kFUICountries` list) and
  `FUIStories` (organism; segmented progress, tap-nav, hold-to-pause).

### Changed
- Migrated every `Icons.*` usage inside the package (41 call sites across 10
  files — both internal widget glyphs and catalog examples) to `FUIIcons.*`.
- **Adopted an atomic-design source layout.** Every widget moved from the flat
  `lib/src/components/` into `lib/src/atoms/`, `molecules/`, or `organisms/`;
  the `FUIStatus`/`FUIStatusColors` primitive moved to `lib/src/tokens/`.
  Internal reorganization only — the flat public barrel is unchanged.

### Tests
- Hardening pass: closed all 14 zero-coverage gaps (`FUIText`, `FUIBadge`,
  `FUITag`, `FUIChip`, `FUIDivider`, `FUIAvatar`, `FUICard`, `FUIListTile`,
  `FUIRadio`, `FUISwitch`, `FUITooltip`, plus the `FUIStatusColors` token) and
  deepened `FUIButton` (variants, sizes, icon positions, fullWidth). Suite grew
  36 → 73 tests, including brightness-aware token resolution.
- New components add coverage across imagery, search/OTP/FAB/context-menu,
  timeline/chat/calendar/upload, and country-picker/stories. Suite now at
  **105 tests**; analyze + format clean across `forge_ui` and the playground.

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
