import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

void main() {
  test('FUIColor.resolve returns light/dark by brightness', () {
    const c = FUIColor(light: Color(0xFFAAAAAA), dark: Color(0xFF111111));
    expect(c.resolve(Brightness.light), const Color(0xFFAAAAAA));
    expect(c.resolve(Brightness.dark), const Color(0xFF111111));
  });

  test('FUIColor.solid resolves the same value either way', () {
    const c = FUIColor.solid(Color(0xFF00FF00));
    expect(c.resolve(Brightness.light), c.resolve(Brightness.dark));
  });

  testWidgets('FUITheme.of resolves against the explicit brightness',
      (tester) async {
    late FUIThemeData captured;
    await tester.pumpWidget(
      FUITheme(
        tokens: FUITokens.base,
        brightness: Brightness.dark,
        child: Builder(
          builder: (context) {
            captured = FUITheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured.isDark, isTrue);
    expect(
      captured.resolve(captured.colors.primary),
      FUIColors.base.primary.dark,
    );
  });
}
