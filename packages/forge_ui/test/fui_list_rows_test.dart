import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child: Scaffold(body: child),
      ),
    );

void main() {
  testWidgets('FUIToggleListTile toggles when the row is tapped',
      (tester) async {
    bool? next;
    await tester.pumpWidget(
      _host(
        FUIToggleListTile(
          title: 'Wi-Fi only',
          value: false,
          onChanged: (v) => next = v,
        ),
      ),
    );

    await tester.tap(find.text('Wi-Fi only'));
    expect(next, isTrue);
  });

  testWidgets('FUICheckboxListTile reports the next value', (tester) async {
    bool? next;
    await tester.pumpWidget(
      _host(
        FUICheckboxListTile(
          title: 'Auto-backup',
          value: true,
          onChanged: (v) => next = v,
        ),
      ),
    );

    await tester.tap(find.text('Auto-backup'));
    expect(next, isFalse);
  });

  testWidgets('FUIRadioListTile selects its value', (tester) async {
    String? picked;
    await tester.pumpWidget(
      _host(
        FUIRadioListTile<String>(
          title: 'High',
          value: 'high',
          groupValue: 'low',
          onChanged: (v) => picked = v,
        ),
      ),
    );

    await tester.tap(find.text('High'));
    expect(picked, 'high');
  });

  testWidgets('FUIIconButton fires onPressed and respects disabled',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        Column(
          children: [
            FUIIconButton(icon: Icons.add, onPressed: () => taps++),
            const FUIIconButton(icon: Icons.lock, isEnabled: false),
          ],
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.lock));
    expect(taps, 1);
  });
}
