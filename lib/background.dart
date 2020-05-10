import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:zombie_sim/zombie_game.dart';

class Background {
  final ZombieGame game;
  Sprite bgSprite;
  Rect bgRect;

  Background(this.game) {
    bgSprite = Sprite('background.png');
  }

  void render(Canvas c) {
    if (bgRect == null) {
      bgRect = Rect.fromLTWH(
        0,
        0,
        game.size.width * 2,
        game.size.height * 2,
      );
    }
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {}
}