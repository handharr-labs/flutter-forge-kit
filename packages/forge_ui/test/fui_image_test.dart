import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child: Scaffold(body: Center(child: child)),
      ),
    );

const _provider = AssetImage('assets/sample.png');

void main() {
  group('FUIImage', () {
    testWidgets('renders an Image with the supplied provider', (tester) async {
      await tester.pumpWidget(_host(const FUIImage(image: _provider)));
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, _provider);
      expect(image.fit, BoxFit.cover);
    });

    testWidgets('clips to the configured token radius', (tester) async {
      final radii = FUITokens.base.radii;
      final cases = <FUIImageRadius, double>{
        FUIImageRadius.none: 0,
        FUIImageRadius.sm: radii.sm,
        FUIImageRadius.lg: radii.lg,
        FUIImageRadius.full: radii.full,
      };
      for (final entry in cases.entries) {
        await tester.pumpWidget(_host(FUIImage(
          image: _provider,
          configuration: FUIImageConfiguration(radius: entry.key),
        )));
        final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clip.borderRadius, BorderRadius.circular(entry.value),
            reason: 'radius ${entry.key.name}');
      }
    });

    testWidgets('aspectRatio wraps the image in an AspectRatio',
        (tester) async {
      await tester.pumpWidget(_host(const FUIImage(
        image: _provider,
        configuration: FUIImageConfiguration(aspectRatio: 16 / 9),
      )));
      expect(find.byType(AspectRatio), findsOneWidget);
      expect(tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio,
          16 / 9);
    });

    testWidgets('explicit width + height suppress AspectRatio', (tester) async {
      await tester.pumpWidget(_host(const FUIImage(
        image: _provider,
        configuration: FUIImageConfiguration(
          aspectRatio: 16 / 9,
          width: 100,
          height: 100,
        ),
      )));
      expect(find.byType(AspectRatio), findsNothing);
    });

    testWidgets('forwards the semantic label', (tester) async {
      await tester.pumpWidget(_host(const FUIImage(
        image: _provider,
        semanticLabel: 'a sample',
      )));
      expect(
          tester.widget<Image>(find.byType(Image)).semanticLabel, 'a sample');
    });

    testWidgets('shows the broken-image fallback when loading fails',
        (tester) async {
      await tester.pumpWidget(_host(const FUIImage(image: _provider)));
      await tester.pump(); // let the provider resolve + fail
      expect(find.byIcon(FUIIcons.imageBroken), findsOneWidget);
    });

    testWidgets('uses a custom errorBuilder when provided', (tester) async {
      await tester.pumpWidget(_host(FUIImage(
        image: _provider,
        errorBuilder: (_) => const Text('broke'),
      )));
      await tester.pump();
      expect(find.text('broke'), findsOneWidget);
      expect(find.byIcon(FUIIcons.imageBroken), findsNothing);
    });
  });
}
