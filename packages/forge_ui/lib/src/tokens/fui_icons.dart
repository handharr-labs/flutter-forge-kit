import 'package:flutter/material.dart';

/// The kit's curated icon vocabulary.
///
/// `FUIIcons` is the single brand-controlled surface for glyphs — call sites
/// reference [FUIIcons.search] rather than reaching into Flutter's [Icons]
/// directly, the same way colors resolve through `FUITheme` instead of raw
/// `Color` literals.
///
/// Today every entry points at a Material glyph (no bundled font yet, no
/// assets required). Because consumers only ever name the semantic constant,
/// the underlying glyph can later be repointed to a custom icon font's
/// [IconData] without touching a single call site.
///
/// Pass any entry to [FUIIcon] / [FUIIconButton], which add token color and
/// consistent sizing.
abstract final class FUIIcons {
  // Actions
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData close = Icons.close;
  static const IconData check = Icons.check;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete_outline;
  static const IconData share = Icons.share;
  static const IconData search = Icons.search;
  static const IconData tune = Icons.tune;
  static const IconData upload = Icons.cloud_upload_outlined;
  static const IconData moreVertical = Icons.more_vert;

  // Navigation / direction
  static const IconData back = Icons.arrow_back;
  static const IconData chevronLeft = Icons.chevron_left;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData chevronDown = Icons.keyboard_arrow_down;

  // Concepts
  static const IconData home = Icons.home;
  static const IconData homeOutline = Icons.home_outlined;
  static const IconData person = Icons.person;
  static const IconData personOutline = Icons.person_outline;
  static const IconData notifications = Icons.notifications;
  static const IconData notificationsOutline = Icons.notifications_outlined;
  static const IconData mail = Icons.mail_outline;
  static const IconData inbox = Icons.inbox_outlined;
  static const IconData bookmark = Icons.bookmark_border;
  static const IconData favorite = Icons.favorite_border;
  static const IconData lock = Icons.lock;
  static const IconData lockOutline = Icons.lock_outline;
  static const IconData wifi = Icons.wifi;
  static const IconData bolt = Icons.bolt;

  // Status
  static const IconData success = Icons.check_circle_outline;
  static const IconData info = Icons.info_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData error = Icons.error_outline;

  // Media
  static const IconData image = Icons.image_outlined;
  static const IconData imageBroken = Icons.broken_image_outlined;
  static const IconData file = Icons.insert_drive_file_outlined;

  // Theme toggle
  static const IconData lightMode = Icons.light_mode;
  static const IconData darkMode = Icons.dark_mode;
}
