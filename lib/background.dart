import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:zombie_sim/zombie_game.dart';

class Background extends SpriteComponent with Tapable {
  final ZombieGame game;
  Rect bgRect;

  Background(this.game) {
    sprite = Sprite('background.png');
  }

  void render(Canvas c) {
    //if (bgRect == null) {
      /*bgRect = Rect.fromLTWH(
        0,
        0,
        game.size.width * 2,
        game.size.height * 2,
      );*/

    //}
    //sprite.renderRect(c, bgRect);
    super.render(c);
  }

  @override
  void resize(Size size) {
      this.x = 0;
      this.y = 0;
      this.width = game.size.width * 1.8;
      this.height = game.size.width * 1.7;
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch(game.selected) {
      case PlaceSelection.Alarm:
        addAlarm(details);
        break;
      case PlaceSelection.Fence:
        addFence(details);
        break;
      case PlaceSelection.Spinner:
        addBladeSpinner(details);
        break;
    }
  }

  void addAlarm(TapDownDetails details) {
    game.field.createAlarm(
        details.globalPosition.dx, details.globalPosition.dy);
  }

  void addFence(TapDownDetails details) {
    game.field.createFence(
      details.globalPosition.dx, details.globalPosition.dy);
  }

  void addBladeSpinner(TapDownDetails details) {
    game.field.createBladeSpinner(
      details.globalPosition.dx, details.globalPosition.dy);
  }
}