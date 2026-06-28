import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

void main() {
  testWidgets('FUIButton renders its label and fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FUITheme(
          tokens: FUITokens.base,
          child: FUIButton(
            configuration: const FUIButtonConfiguration(label: 'Forge'),
            onPressed: () => taps++,
          ),
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
      Directionality(
        textDirection: TextDirection.ltr,
        child: FUITheme(
          tokens: FUITokens.base,
          child: FUIButton(
            configuration: const FUIButtonConfiguration(
              label: 'Off',
              isEnabled: false,
            ),
            onPressed: () => taps++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Off'));
    expect(taps, 0);
  });
}
