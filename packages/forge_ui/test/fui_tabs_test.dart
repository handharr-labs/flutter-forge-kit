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
  testWidgets('FUITabs reports the tapped index', (tester) async {
    int? picked;
    await tester.pumpWidget(
      _host(
        FUITabs(
          items: const ['All', 'Unread', 'Archived'],
          selectedIndex: 0,
          onChanged: (i) => picked = i,
        ),
      ),
    );

    await tester.tap(find.text('Unread'));
    expect(picked, 1);
  });

  testWidgets('FUISegmentedControl reports the tapped index', (tester) async {
    int? picked;
    await tester.pumpWidget(
      _host(
        FUISegmentedControl(
          items: const ['Day', 'Week', 'Month'],
          selectedIndex: 0,
          onChanged: (i) => picked = i,
        ),
      ),
    );

    await tester.tap(find.text('Month'));
    expect(picked, 2);
  });
}
