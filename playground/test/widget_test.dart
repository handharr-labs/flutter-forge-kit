import 'package:flutter_test/flutter_test.dart';
import 'package:forge_kit_playground/main.dart';

void main() {
  testWidgets('Playground boots into the Forge UI catalog', (tester) async {
    await tester.pumpWidget(const PlaygroundApp());

    // The catalog title and a sample component are on screen.
    expect(find.text('Forge UI Catalog'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
  });
}
