import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_search_field.dart';
import '../atoms/fui_text.dart';

/// A country entry. The [flag] is derived from [isoCode] as a Unicode
/// regional-indicator emoji — no bundled flag images.
@immutable
class FUICountry {
  const FUICountry({
    required this.name,
    required this.isoCode,
    required this.dialCode,
  });

  final String name;

  /// ISO 3166-1 alpha-2 code, e.g. `ID`, `US`.
  final String isoCode;

  /// E.164 calling code, e.g. `+62`.
  final String dialCode;

  /// The flag emoji for [isoCode] (two regional-indicator symbols).
  String get flag => isoCode
      .toUpperCase()
      .codeUnits
      .map((c) => String.fromCharCode(0x1F1E6 + c - 0x41))
      .join();
}

/// Opens a searchable country list as a modal sheet, returning the chosen
/// [FUICountry] (or null if dismissed). Re-provides [FUITheme] across the route
/// boundary, like the kit's other overlays. Pass [countries] to override the
/// bundled list (e.g. a localized or trimmed set).
Future<FUICountry?> showFUICountryPicker(
  BuildContext context, {
  List<FUICountry> countries = kFUICountries,
}) {
  final data = FUITheme.of(context);
  return showModalBottomSheet<FUICountry>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: data.resolve(data.colors.overlay),
    isScrollControlled: true,
    builder: (_) => FUITheme(
      tokens: data.tokens,
      brightness: data.brightness,
      child: _CountryPickerSheet(countries: countries),
    ),
  );
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.countries});

  final List<FUICountry> countries;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  List<FUICountry> get _filtered {
    if (_query.isEmpty) return widget.countries;
    final q = _query.toLowerCase();
    return widget.countries
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.dialCode.contains(q) ||
            c.isoCode.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final results = _filtered;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      decoration: BoxDecoration(
        color: fui.resolve(fui.colors.surface),
        borderRadius: BorderRadius.vertical(top: Radius.circular(fui.radii.xl)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(fui.spacing.lg),
          child: Column(
            children: [
              FUISearchField(
                hint: 'Search country or code',
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              SizedBox(height: fui.spacing.md),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child:
                            FUIText('No matches', color: FUITextColor.subtle),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, i) => _CountryRow(
                          country: results[i],
                          onTap: () => Navigator.of(context).pop(results[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({required this.country, required this.onTap});

  final FUICountry country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: fui.spacing.md),
        child: Row(
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 22)),
            SizedBox(width: fui.spacing.md),
            Expanded(
              child: FUIText(country.name, variant: FUITextVariant.body),
            ),
            FUIText(country.dialCode, color: FUITextColor.subtle),
          ],
        ),
      ),
    );
  }
}

/// A curated default set of common countries. Override via the `countries`
/// argument of [showFUICountryPicker] when a fuller or localized list is needed.
const List<FUICountry> kFUICountries = [
  FUICountry(name: 'Argentina', isoCode: 'AR', dialCode: '+54'),
  FUICountry(name: 'Australia', isoCode: 'AU', dialCode: '+61'),
  FUICountry(name: 'Austria', isoCode: 'AT', dialCode: '+43'),
  FUICountry(name: 'Bangladesh', isoCode: 'BD', dialCode: '+880'),
  FUICountry(name: 'Belgium', isoCode: 'BE', dialCode: '+32'),
  FUICountry(name: 'Brazil', isoCode: 'BR', dialCode: '+55'),
  FUICountry(name: 'Canada', isoCode: 'CA', dialCode: '+1'),
  FUICountry(name: 'Chile', isoCode: 'CL', dialCode: '+56'),
  FUICountry(name: 'China', isoCode: 'CN', dialCode: '+86'),
  FUICountry(name: 'Colombia', isoCode: 'CO', dialCode: '+57'),
  FUICountry(name: 'Denmark', isoCode: 'DK', dialCode: '+45'),
  FUICountry(name: 'Egypt', isoCode: 'EG', dialCode: '+20'),
  FUICountry(name: 'Finland', isoCode: 'FI', dialCode: '+358'),
  FUICountry(name: 'France', isoCode: 'FR', dialCode: '+33'),
  FUICountry(name: 'Germany', isoCode: 'DE', dialCode: '+49'),
  FUICountry(name: 'Greece', isoCode: 'GR', dialCode: '+30'),
  FUICountry(name: 'Hong Kong', isoCode: 'HK', dialCode: '+852'),
  FUICountry(name: 'India', isoCode: 'IN', dialCode: '+91'),
  FUICountry(name: 'Indonesia', isoCode: 'ID', dialCode: '+62'),
  FUICountry(name: 'Ireland', isoCode: 'IE', dialCode: '+353'),
  FUICountry(name: 'Israel', isoCode: 'IL', dialCode: '+972'),
  FUICountry(name: 'Italy', isoCode: 'IT', dialCode: '+39'),
  FUICountry(name: 'Japan', isoCode: 'JP', dialCode: '+81'),
  FUICountry(name: 'Malaysia', isoCode: 'MY', dialCode: '+60'),
  FUICountry(name: 'Mexico', isoCode: 'MX', dialCode: '+52'),
  FUICountry(name: 'Netherlands', isoCode: 'NL', dialCode: '+31'),
  FUICountry(name: 'New Zealand', isoCode: 'NZ', dialCode: '+64'),
  FUICountry(name: 'Nigeria', isoCode: 'NG', dialCode: '+234'),
  FUICountry(name: 'Norway', isoCode: 'NO', dialCode: '+47'),
  FUICountry(name: 'Pakistan', isoCode: 'PK', dialCode: '+92'),
  FUICountry(name: 'Philippines', isoCode: 'PH', dialCode: '+63'),
  FUICountry(name: 'Poland', isoCode: 'PL', dialCode: '+48'),
  FUICountry(name: 'Portugal', isoCode: 'PT', dialCode: '+351'),
  FUICountry(name: 'Russia', isoCode: 'RU', dialCode: '+7'),
  FUICountry(name: 'Saudi Arabia', isoCode: 'SA', dialCode: '+966'),
  FUICountry(name: 'Singapore', isoCode: 'SG', dialCode: '+65'),
  FUICountry(name: 'South Africa', isoCode: 'ZA', dialCode: '+27'),
  FUICountry(name: 'South Korea', isoCode: 'KR', dialCode: '+82'),
  FUICountry(name: 'Spain', isoCode: 'ES', dialCode: '+34'),
  FUICountry(name: 'Sweden', isoCode: 'SE', dialCode: '+46'),
  FUICountry(name: 'Switzerland', isoCode: 'CH', dialCode: '+41'),
  FUICountry(name: 'Taiwan', isoCode: 'TW', dialCode: '+886'),
  FUICountry(name: 'Thailand', isoCode: 'TH', dialCode: '+66'),
  FUICountry(name: 'Turkey', isoCode: 'TR', dialCode: '+90'),
  FUICountry(name: 'Ukraine', isoCode: 'UA', dialCode: '+380'),
  FUICountry(name: 'United Arab Emirates', isoCode: 'AE', dialCode: '+971'),
  FUICountry(name: 'United Kingdom', isoCode: 'GB', dialCode: '+44'),
  FUICountry(name: 'United States', isoCode: 'US', dialCode: '+1'),
  FUICountry(name: 'Vietnam', isoCode: 'VN', dialCode: '+84'),
];
