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
  testWidgets('FUIProgressIndicator.linear renders a LinearProgressIndicator',
      (tester) async {
    await tester
        .pumpWidget(_host(const FUIProgressIndicator.linear(value: 0.5)));
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.5);
  });

  testWidgets('FUIProgressIndicator.circular renders sized', (tester) async {
    await tester.pumpWidget(
      _host(const FUIProgressIndicator.circular(value: 0.25, size: 32)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FUIShimmer.box builds and animates without error',
      (tester) async {
    await tester.pumpWidget(_host(FUIShimmer.box(height: 16, width: 120)));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(FUIShimmer), findsOneWidget);
  });
}
