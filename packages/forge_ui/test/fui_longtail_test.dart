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
  group('FUISearchField', () {
    testWidgets('shows the hint and search glyph', (tester) async {
      await tester.pumpWidget(_host(const FUISearchField(hint: 'Find')));
      expect(find.text('Find'), findsOneWidget);
      expect(find.byIcon(FUIIcons.search), findsOneWidget);
    });

    testWidgets('clear button appears with text, clears it, fires onClear',
        (tester) async {
      var cleared = false;
      final controller = TextEditingController();
      await tester.pumpWidget(_host(FUISearchField(
        controller: controller,
        onClear: () => cleared = true,
      )));

      expect(find.byTooltip('Clear'), findsNothing);
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();
      expect(find.byTooltip('Clear'), findsOneWidget);

      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(cleared, isTrue);
      expect(find.byTooltip('Clear'), findsNothing);
    });
  });

  group('FUIOtpField', () {
    testWidgets('renders one cell per length', (tester) async {
      await tester.pumpWidget(_host(const FUIOtpField(length: 5)));
      // 5 cell containers, each an outlined box.
      expect(find.byType(FUIOtpField), findsOneWidget);
      final boxes = tester.widgetList<Container>(find.descendant(
        of: find.byType(FUIOtpField),
        matching: find.byType(Container),
      ));
      expect(boxes.length, 5);
    });

    testWidgets('fills cells and fires onCompleted when full', (tester) async {
      String? completed;
      await tester.pumpWidget(_host(FUIOtpField(
        length: 4,
        onCompleted: (v) => completed = v,
      )));
      await tester.enterText(find.byType(TextField), '1234');
      await tester.pump();
      expect(completed, '1234');
      for (final d in ['1', '2', '3', '4']) {
        expect(find.text(d), findsOneWidget);
      }
    });

    testWidgets('digitsOnly strips non-numeric input', (tester) async {
      String? value;
      await tester.pumpWidget(_host(FUIOtpField(
        length: 4,
        onChanged: (v) => value = v,
      )));
      await tester.enterText(find.byType(TextField), '12ab');
      await tester.pump();
      expect(value, '12');
    });
  });

  group('FUIFab', () {
    testWidgets('renders the icon and fires onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_host(
        FUIFab(icon: FUIIcons.add, onPressed: () => taps++),
      ));
      expect(find.byIcon(FUIIcons.add), findsOneWidget);
      await tester.tap(find.byType(FUIFab));
      expect(taps, 1);
    });

    testWidgets('extended form renders the label', (tester) async {
      await tester.pumpWidget(_host(
        FUIFab(icon: FUIIcons.add, label: 'Compose', onPressed: () {}),
      ));
      expect(find.text('Compose'), findsOneWidget);
    });

    testWidgets('null onPressed disables tap', (tester) async {
      await tester.pumpWidget(_host(const FUIFab(icon: FUIIcons.add)));
      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNull);
    });
  });

  group('showFUIContextMenu', () {
    testWidgets('opens actions and returns the chosen value', (tester) async {
      String? picked;
      await tester.pumpWidget(_host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              picked = await showFUIContextMenu<String>(
                context,
                actions: const [
                  FUIContextMenuAction(value: 'share', label: 'Share'),
                  FUIContextMenuAction(
                      value: 'delete', label: 'Delete', isDestructive: true),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(picked, 'delete');
    });
  });
}
