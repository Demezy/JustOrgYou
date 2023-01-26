import 'dart:ui';

import 'package:swipeapp/src/ui_helpers.dart';

import 'decks_manager.dart';

Color cardToColor(DeckEntry card) {
  return stringToColor(
      card.title + (card.description == null ? card.title : ""));
}
