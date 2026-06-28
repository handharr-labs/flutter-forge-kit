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

  testWidgets('every variant renders its label and stays tappable',
      (tester) async {
    for (final variant in FUIButtonVariant.values) {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          FUIButton(
            configuration: FUIButtonConfiguration(
              label: variant.name,
              variant: variant,
            ),
            onPressed: () => taps++,
          ),
        ),
      );
      expect(find.text(variant.name), findsOneWidget);
      await tester.tap(find.text(variant.name));
      expect(taps, 1, reason: '$variant should fire onPressed');
    }
  });

  testWidgets('small button is shorter than medium', (tester) async {
    await tester.pumpWidget(
      _host(const FUIButton(
        configuration:
            FUIButtonConfiguration(label: 'S', size: FUIButtonSize.small),
      )),
    );
    final small = tester.getSize(find.byType(FUIButton)).height;

    await tester.pumpWidget(
      _host(const FUIButton(
        configuration: FUIButtonConfiguration(label: 'M'),
      )),
    );
    final medium = tester.getSize(find.byType(FUIButton)).height;

    expect(small, 32);
    expect(medium, 48);
  });

  testWidgets('renders an icon in either position', (tester) async {
    await tester.pumpWidget(
      _host(const FUIButton(
        configuration: FUIButtonConfiguration(label: 'Add', icon: FUIIcons.add),
      )),
    );
    expect(find.byIcon(FUIIcons.add), findsOneWidget);

    await tester.pumpWidget(
      _host(const FUIButton(
        configuration: FUIButtonConfiguration(
          label: 'Add',
          icon: FUIIcons.add,
          iconPosition: FUIButtonIconPosition.trailing,
        ),
      )),
    );
    expect(find.byIcon(FUIIcons.add), findsOneWidget);
  });

  testWidgets('fullWidth fills its horizontal constraints', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FUITheme(
          tokens: FUITokens.base,
          child: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: FUIButton(
                  configuration:
                      FUIButtonConfiguration(label: 'Wide', fullWidth: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(FUIButton)).width, 300);
  });
}
