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
  group('FUIRadio', () {
    testWidgets('tapping an unselected radio fires onChanged with its value',
        (tester) async {
      String? picked;
      await tester.pumpWidget(
        _host(FUIRadio<String>(
          value: 'b',
          groupValue: 'a',
          label: 'Option B',
          onChanged: (v) => picked = v,
        )),
      );
      await tester.tap(find.text('Option B'));
      expect(picked, 'b');
    });

    testWidgets('disabled radio ignores taps', (tester) async {
      var fired = false;
      await tester.pumpWidget(
        _host(FUIRadio<String>(
          value: 'b',
          groupValue: 'a',
          label: 'B',
          isEnabled: false,
          onChanged: (_) => fired = true,
        )),
      );
      await tester.tap(find.text('B'));
      expect(fired, isFalse);
    });

    testWidgets('selected radio renders the inner dot', (tester) async {
      // Selected = an extra (filled inner) container beyond the unselected ring.
      await tester.pumpWidget(
        _host(const FUIRadio<String>(value: 'a', groupValue: 'b')),
      );
      final unselected = tester.widgetList(find.byType(Container)).length;
      await tester.pumpWidget(
        _host(const FUIRadio<String>(value: 'a', groupValue: 'a')),
      );
      final selected = tester.widgetList(find.byType(Container)).length;
      expect(selected, greaterThan(unselected));
    });
  });

  group('FUISwitch', () {
    testWidgets('off switch reports true when tapped', (tester) async {
      bool? next;
      await tester.pumpWidget(
        _host(FUISwitch(value: false, onChanged: (v) => next = v)),
      );
      await tester.tap(find.byType(FUISwitch));
      expect(next, isTrue);
    });

    testWidgets('on switch reports false when tapped', (tester) async {
      bool? next;
      await tester.pumpWidget(
        _host(FUISwitch(value: true, onChanged: (v) => next = v)),
      );
      await tester.tap(find.byType(FUISwitch));
      expect(next, isFalse);
    });

    testWidgets('thumb aligns by value', (tester) async {
      await tester.pumpWidget(_host(const FUISwitch(value: true)));
      final on = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(on.alignment, Alignment.centerRight);

      await tester.pumpWidget(_host(const FUISwitch(value: false)));
      final off = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(off.alignment, Alignment.centerLeft);
    });

    testWidgets('disabled switch ignores taps', (tester) async {
      var fired = false;
      await tester.pumpWidget(
        _host(FUISwitch(
          value: false,
          isEnabled: false,
          onChanged: (_) => fired = true,
        )),
      );
      await tester.tap(find.byType(FUISwitch));
      expect(fired, isFalse);
    });
  });
}
