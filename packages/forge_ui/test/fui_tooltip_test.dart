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
  testWidgets('FUITooltip renders its child', (tester) async {
    await tester.pumpWidget(
      _host(const FUITooltip(message: 'Help', child: Text('target'))),
    );
    expect(find.text('target'), findsOneWidget);
    // Message is not shown until triggered.
    expect(find.text('Help'), findsNothing);
  });

  testWidgets('FUITooltip surfaces its message on long press', (tester) async {
    await tester.pumpWidget(
      _host(const FUITooltip(message: 'Help', child: Text('target'))),
    );
    await tester.longPress(find.text('target'));
    await tester.pumpAndSettle();
    expect(find.text('Help'), findsOneWidget);
  });
}
