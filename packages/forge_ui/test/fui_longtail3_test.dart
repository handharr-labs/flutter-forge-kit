import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child: Scaffold(body: Center(child: child)),
      ),
    );

void main() {
  group('FUICountry', () {
    test('derives the flag emoji from the ISO code', () {
      expect(
          const FUICountry(name: 'Indonesia', isoCode: 'ID', dialCode: '+62')
              .flag,
          '\u{1F1EE}\u{1F1E9}');
      expect(
          const FUICountry(name: 'United States', isoCode: 'US', dialCode: '+1')
              .flag,
          '\u{1F1FA}\u{1F1F8}');
    });
  });

  group('showFUICountryPicker', () {
    testWidgets('lists, filters, and returns the chosen country',
        (tester) async {
      FUICountry? picked;
      await tester.pumpWidget(_host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              picked = await showFUICountryPicker(context);
            },
            child: const Text('open'),
          ),
        ),
      ));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Argentina'), findsOneWidget); // top of the list

      await tester.enterText(find.byType(FUISearchField), 'japan');
      await tester.pumpAndSettle();
      expect(find.text('Argentina'), findsNothing);
      expect(find.text('Japan'), findsOneWidget);

      await tester.tap(find.text('Japan'));
      await tester.pumpAndSettle();
      expect(picked?.isoCode, 'JP');
    });
  });

  group('FUIStories', () {
    Widget storiesHost(ValueChanged<int>? onIndex, {VoidCallback? onDone}) =>
        _host(SizedBox(
          width: 300,
          height: 400,
          child: FUIStories(
            onIndexChanged: onIndex,
            onComplete: onDone,
            segments: const [
              FUIStorySegment(content: Text('one')),
              FUIStorySegment(content: Text('two')),
              FUIStorySegment(content: Text('three')),
            ],
          ),
        ));

    testWidgets('shows the first segment initially', (tester) async {
      await tester.pumpWidget(storiesHost(null));
      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsNothing);
    });

    testWidgets('tap right advances, tap left goes back', (tester) async {
      final indices = <int>[];
      await tester.pumpWidget(storiesHost(indices.add));

      final rect = tester.getRect(find.byType(FUIStories));
      await tester.tapAt(rect.center); // right two-thirds -> next
      await tester.pump();
      expect(indices.last, 1);
      expect(find.text('two'), findsOneWidget);

      await tester.tapAt(rect.centerLeft + const Offset(5, 0)); // left -> prev
      await tester.pump();
      expect(indices.last, 0);
      expect(find.text('one'), findsOneWidget);
    });

    testWidgets('fires onComplete after the last segment', (tester) async {
      var done = false;
      await tester.pumpWidget(storiesHost(null, onDone: () => done = true));
      final rect = tester.getRect(find.byType(FUIStories));
      await tester.tapAt(rect.center); // -> 1
      await tester.pump();
      await tester.tapAt(rect.center); // -> 2 (last)
      await tester.pump();
      await tester.tapAt(rect.center); // past last -> onComplete
      await tester.pump();
      expect(done, isTrue);
    });
  });
}
