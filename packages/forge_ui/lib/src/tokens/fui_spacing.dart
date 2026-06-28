import 'package:flutter/widgets.dart';

/// The spacing scale — an 8-point grid with a 4px base step. Use these for
/// padding, margins, and gaps so rhythm stays consistent across components.
@immutable
class FUISpacing {
  const FUISpacing();

  final double none = 0;
  final double xs = 4;
  final double sm = 8;
  final double md = 12;
  final double lg = 16;
  final double xl = 24;
  final double xxl = 32;
  final double xxxl = 40;
}
