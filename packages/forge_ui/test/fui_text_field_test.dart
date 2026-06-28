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
  testWidgets('FUITextField shows label and error text', (tester) async {
    await tester.pumpWidget(
      _host(
        const FUITextField(
          configuration: FUITextFieldConfiguration(
            label: 'Email',
            errorText: 'Required',
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('FUITextField forwards onChanged', (tester) async {
    String? value;
    await tester.pumpWidget(
      _host(
        FUITextField(
          configuration: const FUITextFieldConfiguration(label: 'Name'),
          onChanged: (v) => value = v,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Ada');
    expect(value, 'Ada');
  });
}
