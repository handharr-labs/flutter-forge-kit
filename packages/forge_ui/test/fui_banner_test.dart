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
  testWidgets('FUIBanner renders title and message', (tester) async {
    await tester.pumpWidget(
      _host(
        const FUIBanner(
          configuration: FUIBannerConfiguration(
            status: FUIStatus.success,
            title: 'Saved',
            message: 'Your changes were saved.',
          ),
        ),
      ),
    );

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Your changes were saved.'), findsOneWidget);
  });

  testWidgets('dismissible FUIBanner fires onDismiss', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      _host(
        FUIBanner(
          configuration: const FUIBannerConfiguration(
            status: FUIStatus.danger,
            message: 'Failed',
            dismissible: true,
          ),
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(dismissed, isTrue);
  });
}
