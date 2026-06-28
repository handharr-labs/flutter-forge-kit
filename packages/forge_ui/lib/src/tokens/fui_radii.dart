import 'package:flutter/widgets.dart';

/// The corner-radius scale, from subtle rounding to fully-pilled.
@immutable
class FUIRadii {
  const FUIRadii();

  final double sm = 4;
  final double md = 8;
  final double lg = 12;
  final double xl = 16;

  /// Large enough to fully round any realistic element (pills, chips, avatars).
  final double full = 999;
}
