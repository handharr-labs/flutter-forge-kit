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
  testWidgets('tapping an unchecked FUICheckbox reports true', (tester) async {
    bool? next;
    await tester.pumpWidget(
      _host(
        FUICheckbox(
          state: FUICheckboxState.unchecked,
          label: 'Accept',
          onChanged: (v) => next = v,
        ),
      ),
    );

    await tester.tap(find.text('Accept'));
    expect(next, isTrue);
  });

  testWidgets('tapping a checked FUICheckbox reports false', (tester) async {
    bool? next;
    await tester.pumpWidget(
      _host(
        FUICheckbox(
          state: FUICheckboxState.checked,
          onChanged: (v) => next = v,
        ),
      ),
    );

    await tester.tap(find.byType(FUICheckbox));
    expect(next, isFalse);
  });

  testWidgets('disabled FUICheckbox ignores taps', (tester) async {
    var fired = false;
    await tester.pumpWidget(
      _host(
        FUICheckbox(
          state: FUICheckboxState.unchecked,
          isEnabled: false,
          onChanged: (_) => fired = true,
        ),
      ),
    );

    await tester.tap(find.byType(FUICheckbox));
    expect(fired, isFalse);
  });
}
