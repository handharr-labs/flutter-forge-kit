import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

void main() {
  test('FUIIcons exposes IconData glyphs', () {
    expect(FUIIcons.search, isA<IconData>());
    // Semantic names map to their intended Material glyphs.
    expect(FUIIcons.search, Icons.search);
    expect(FUIIcons.delete, Icons.delete_outline);
    expect(FUIIcons.chevronDown, Icons.keyboard_arrow_down);
  });

  testWidgets('FUIIcon renders the FUIIcons glyph it is given', (tester) async {
    await tester.pumpWidget(
      FUITheme(
        tokens: FUITokens.base,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: FUIIcon(FUIIcons.search),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, FUIIcons.search);
  });
}
