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
  testWidgets('FUISelect shows hint, opens sheet, and reports a pick',
      (tester) async {
    String? chosen;
    await tester.pumpWidget(
      _host(
        Center(
          child: FUISelect<String>(
            label: 'Country',
            hint: 'Choose a country',
            value: null,
            options: const [
              FUISelectOption(value: 'id', label: 'Indonesia'),
              FUISelectOption(value: 'sg', label: 'Singapore'),
            ],
            onChanged: (v) => chosen = v,
          ),
        ),
      ),
    );

    expect(find.text('Choose a country'), findsOneWidget);

    await tester.tap(find.text('Choose a country'));
    await tester.pumpAndSettle();
    expect(find.text('Singapore'), findsOneWidget);

    await tester.tap(find.text('Singapore'));
    await tester.pumpAndSettle();
    expect(chosen, 'sg');
  });

  testWidgets('FUISlider reports value changes', (tester) async {
    double? value;
    await tester.pumpWidget(
      _host(
        FUISlider(
          value: 0.5,
          onChanged: (v) => value = v,
        ),
      ),
    );

    await tester.drag(find.byType(Slider), const Offset(-100, 0));
    expect(value, isNotNull);
  });

  testWidgets('FUIAccordion expands to reveal its child', (tester) async {
    await tester.pumpWidget(
      _host(
        const FUIAccordion(
          title: 'More info',
          child: Text('Hidden detail'),
        ),
      ),
    );

    expect(find.text('More info'), findsOneWidget);
    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();
    expect(find.text('Hidden detail'), findsOneWidget);
  });

  testWidgets('FUIStepper renders all step labels', (tester) async {
    await tester.pumpWidget(
      _host(
        const FUIStepper(
          steps: ['Cart', 'Address', 'Payment'],
          currentStep: 1,
        ),
      ),
    );

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
  });
}
