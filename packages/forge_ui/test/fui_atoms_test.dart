import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

/// A 1×1 transparent PNG — a real, decodable image so avatar tests exercise the
/// imageProvider path without reaching for an asset bundle.
final _transparentPng = MemoryImage(base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYPhfDwAChwGA'
  '60e6kgAAAABJRU5ErkJggg==',
));

Widget _host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        brightness: brightness,
        child: Scaffold(body: Center(child: child)),
      ),
    );

void main() {
  group('FUIText', () {
    testWidgets('renders its data and honors maxLines', (tester) async {
      await tester.pumpWidget(
        _host(const FUIText('Hello', maxLines: 2)),
      );
      final text = tester.widget<Text>(find.text('Hello'));
      expect(text.maxLines, 2);
      // maxLines implies ellipsis overflow by default.
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('resolves color against brightness (light != dark)',
        (tester) async {
      await tester.pumpWidget(_host(const FUIText('X')));
      final light = tester.widget<Text>(find.text('X')).style!.color;

      await tester.pumpWidget(
        _host(const FUIText('X'), brightness: Brightness.dark),
      );
      final dark = tester.widget<Text>(find.text('X')).style!.color;

      expect(light, isNotNull);
      expect(dark, isNotNull);
      expect(light, isNot(dark));
    });

    testWidgets('variant changes the text style', (tester) async {
      await tester.pumpWidget(
          _host(const FUIText('A', variant: FUITextVariant.titleLg)));
      final titleSize = tester.widget<Text>(find.text('A')).style!.fontSize;
      await tester.pumpWidget(
          _host(const FUIText('A', variant: FUITextVariant.caption)));
      final captionSize = tester.widget<Text>(find.text('A')).style!.fontSize;
      expect(titleSize, greaterThan(captionSize!));
    });
  });

  group('FUIBadge', () {
    testWidgets('dot renders no label', (tester) async {
      await tester.pumpWidget(_host(const FUIBadge.dot()));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('label badge renders its text', (tester) async {
      await tester.pumpWidget(_host(const FUIBadge(label: '9')));
      expect(find.text('9'), findsOneWidget);
    });
  });

  group('FUITag', () {
    testWidgets('renders label; no remove icon without onRemove',
        (tester) async {
      await tester.pumpWidget(_host(const FUITag(label: 'Draft')));
      expect(find.text('Draft'), findsOneWidget);
      expect(find.byIcon(FUIIcons.close), findsNothing);
    });

    testWidgets('removable tag shows ✕ and fires onRemove', (tester) async {
      var removed = false;
      await tester.pumpWidget(
        _host(FUITag(label: 'Draft', onRemove: () => removed = true)),
      );
      expect(find.byIcon(FUIIcons.close), findsOneWidget);
      await tester.tap(find.byIcon(FUIIcons.close));
      expect(removed, isTrue);
    });

    testWidgets('leading icon renders when provided', (tester) async {
      await tester.pumpWidget(
        _host(const FUITag(label: 'Bolt', icon: FUIIcons.bolt)),
      );
      expect(find.byIcon(FUIIcons.bolt), findsOneWidget);
    });
  });

  group('FUIChip', () {
    testWidgets('tap fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(FUIChip(label: 'Filter', onTap: () => taps++)),
      );
      await tester.tap(find.text('Filter'));
      expect(taps, 1);
    });

    testWidgets('selected flips the foreground color', (tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester
          .pumpWidget(_host(const FUIChip(label: 'F', selected: false)));
      final unselected = tester.widget<Text>(find.text('F')).style!.color;
      await tester.pumpWidget(_host(const FUIChip(label: 'F', selected: true)));
      final selected = tester.widget<Text>(find.text('F')).style!.color;
      expect(selected, isNot(unselected));
    });
  });

  group('FUIDivider', () {
    testWidgets('labeled horizontal divider renders the label', (tester) async {
      await tester.pumpWidget(_host(const FUIDivider(label: 'OR')));
      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('plain divider has no text', (tester) async {
      await tester.pumpWidget(_host(const FUIDivider()));
      expect(find.byType(Text), findsNothing);
    });
  });

  group('FUIAvatar', () {
    testWidgets('derives two-letter initials from a full name', (tester) async {
      await tester.pumpWidget(_host(const FUIAvatar(name: 'John Doe')));
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('single name uses one initial', (tester) async {
      await tester.pumpWidget(_host(const FUIAvatar(name: 'Cher')));
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('image avatar shows no initials', (tester) async {
      await tester.pumpWidget(
        _host(FUIAvatar(
          name: 'John Doe',
          imageProvider: _transparentPng,
        )),
      );
      expect(find.text('JD'), findsNothing);
    });
  });
}
