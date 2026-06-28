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
  testWidgets('showFUIBottomSheet shows content and resolves on pop',
      (tester) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => FUIButton(
            configuration: const FUIButtonConfiguration(label: 'Open'),
            onPressed: () => showFUIBottomSheet<void>(
              context,
              configuration: const FUIBottomSheetConfiguration(
                title: 'Options',
                child: Text('Sheet body'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Sheet body'), findsOneWidget);
  });

  testWidgets('showFUIDialog resolves true on confirm', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => FUIButton(
            configuration: const FUIButtonConfiguration(label: 'Ask'),
            onPressed: () async {
              result = await showFUIDialog(
                context,
                configuration: const FUIDialogConfiguration(
                  title: 'Proceed?',
                  message: 'Confirm to continue.',
                  confirmLabel: 'Yes',
                  cancelLabel: 'No',
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    expect(find.text('Proceed?'), findsOneWidget);

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('showFUIToast inserts and auto-dismisses', (tester) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => FUIButton(
            configuration: const FUIButtonConfiguration(label: 'Toast'),
            onPressed: () => showFUIToast(
              context,
              message: 'Saved',
              duration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Toast'));
    await tester.pump(); // insert
    await tester.pump(const Duration(milliseconds: 250)); // fade in
    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100)); // duration
    await tester.pump(const Duration(milliseconds: 250)); // fade out
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });
}
