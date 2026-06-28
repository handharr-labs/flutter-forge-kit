import 'package:flutter/material.dart';
import 'package:forge_ui/forge_ui.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const ForgeUICatalog();
  }
}
