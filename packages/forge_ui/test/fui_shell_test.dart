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
  testWidgets('FUIBottomNavBar renders labels and reports taps',
      (tester) async {
    int? tapped;
    await tester.pumpWidget(
      _host(
        FUIBottomNavBar(
          currentIndex: 0,
          onTap: (i) => tapped = i,
          items: const [
            FUIBottomNavItem(icon: Icons.home, label: 'Home'),
            FUIBottomNavItem(icon: Icons.search, label: 'Search'),
            FUIBottomNavItem(icon: Icons.person, label: 'Profile'),
          ],
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    expect(tapped, 2);
  });

  testWidgets('FUIPageControl renders one dot per page', (tester) async {
    await tester.pumpWidget(
      _host(const FUIPageControl(count: 4, currentIndex: 1)),
    );
    expect(find.byType(AnimatedContainer), findsNWidgets(4));
  });

  testWidgets('FUIBlankSlate shows title, message, and fires action',
      (tester) async {
    var acted = false;
    await tester.pumpWidget(
      _host(
        FUIBlankSlate(
          icon: Icons.inbox_outlined,
          title: 'Nothing here',
          message: 'Come back later.',
          actionLabel: 'Refresh',
          onAction: () => acted = true,
        ),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Come back later.'), findsOneWidget);

    await tester.tap(find.text('Refresh'));
    expect(acted, isTrue);
  });
}
