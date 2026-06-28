import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(PreferredSizeWidget appBar) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child: Scaffold(appBar: appBar, body: const SizedBox()),
      ),
    );

void main() {
  testWidgets('FUIAppBar.text renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      _host(FUIAppBar.text(title: 'Inbox', subtitle: '3 unread')),
    );

    expect(find.text('Inbox'), findsOneWidget);
    expect(find.text('3 unread'), findsOneWidget);
  });

  testWidgets('FUIAppBar.text fires action taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(
        FUIAppBar.text(
          title: 'Inbox',
          showBack: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    expect(tapped, isTrue);
  });
}
