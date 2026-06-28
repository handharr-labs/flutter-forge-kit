import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child: Scaffold(body: Center(child: child)),
      ),
    );

bool _hasBoxShadow(Widget w) =>
    w is Container &&
    w.decoration is BoxDecoration &&
    ((w.decoration as BoxDecoration).boxShadow?.isNotEmpty ?? false);

bool _hasBorder(Widget w) =>
    w is Container &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).border != null;

void main() {
  group('FUICard', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(_host(const FUICard(child: Text('Body'))));
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('onTap makes the card tappable with ink', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(FUICard(onTap: () => taps++, child: const Text('Tap me'))),
      );
      expect(find.byType(InkWell), findsOneWidget);
      await tester.tap(find.text('Tap me'));
      expect(taps, 1);
    });

    testWidgets('non-tappable card has no InkWell', (tester) async {
      await tester.pumpWidget(_host(const FUICard(child: Text('x'))));
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('elevated draws a shadow, default draws a border',
        (tester) async {
      await tester.pumpWidget(
        _host(const FUICard(elevated: true, child: Text('e'))),
      );
      expect(find.byWidgetPredicate(_hasBoxShadow), findsOneWidget);

      await tester.pumpWidget(
        _host(const FUICard(child: Text('b'))),
      );
      expect(find.byWidgetPredicate(_hasBorder), findsOneWidget);
    });
  });

  group('FUIListTile', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        _host(const FUIListTile(title: 'Wi-Fi', subtitle: 'Connected')),
      );
      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('omits subtitle when null', (tester) async {
      await tester.pumpWidget(_host(const FUIListTile(title: 'Only title')));
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpWidget(
        _host(const FUIListTile(
          title: 'Row',
          leading: Icon(FUIIcons.person, key: Key('lead')),
          trailing: Icon(FUIIcons.chevronRight, key: Key('trail')),
        )),
      );
      expect(find.byKey(const Key('lead')), findsOneWidget);
      expect(find.byKey(const Key('trail')), findsOneWidget);
    });

    testWidgets('onTap fires', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(FUIListTile(title: 'Tap', onTap: () => taps++)),
      );
      await tester.tap(find.text('Tap'));
      expect(taps, 1);
    });
  });
}
