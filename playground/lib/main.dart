import 'package:flutter/material.dart';
import 'package:forge_ui/forge_ui.dart';

void main() => runApp(const PlaygroundApp());

/// The playground owns no UI of its own. It boots a [MaterialApp] and hands the
/// whole screen to the design system's [ForgeUICatalog].
class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Forge Kit Playground',
      debugShowCheckedModeBanner: false,
      home: ForgeUICatalog(),
    );
  }
}
