import 'package:flutter/widgets.dart';

/// The type scale. Styles carry size/weight/height but **no color** — widgets
/// apply a resolved color from [FUIColors] so the same style works in light and
/// dark.
@immutable
class FUITypography {
  const FUITypography();

  /// 24/32 · 600 — page titles, hero text.
  final TextStyle titleLg = const TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );

  /// 20/28 · 600 — section headers, card titles.
  final TextStyle titleMd = const TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  /// 16/24 · 400 — default body text.
  final TextStyle body = const TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  /// 14/20 · 400 — secondary body, descriptions.
  final TextStyle bodySm = const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  /// 12/16 · 400 — captions, helper text.
  final TextStyle caption = const TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  /// 10/12 · 600 · +0.8 tracking — overlines, eyebrow labels.
  final TextStyle overline = const TextStyle(
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  /// 16/24 · 600 — button labels.
  final TextStyle button = const TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  /// 14/20 · 600 — form field labels.
  final TextStyle label = const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );
}
