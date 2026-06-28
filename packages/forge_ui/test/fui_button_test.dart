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
  testWidgets('FUIButton renders its label and fires onPressed',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        FUIButton(
          configuration: const FUIButtonConfiguration(label: 'Forge'),
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.text('Forge'), findsOneWidget);
    await tester.tap(find.text('Forge'));
    expect(taps, 1);
  });

  testWidgets('disabled FUIButton ignores taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        FUIButton(
          configuration: const FUIButtonConfiguration(
            label: 'Off',
            isEnabled: false,
          ),
          onPressed: () => taps++,
        ),
      ),
    );

    await tester.tap(find.text('Off'));
    expect(taps, 0);
  });

  testWidgets('loading FUIButton shows a spinner and blocks taps',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        FUIButton(
          configuration:
              const FUIButtonConfiguration(label: 'Save', isLoading: true),
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tester.tap(find.byType(FUIButton));
    expect(taps, 0);
  });
}
