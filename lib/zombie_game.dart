import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:zombie_sim/PlayField.dart';
import 'package:zombie_sim/background.dart';

class OtherSprite extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  OtherSprite() : super.fromSprite(32.0, 32.0, new Sprite('zombie-32-32.png'));

  @override
  void resize(Size size) {
    // we don't need to set the x and y in the constructor, we can set then here
    this.x = (size.width - this.width) / 2;
    this.y = (size.height - this.height) / 2;
  }
}

class ZombieGame extends BaseGame with TapDetector {
  Background _bg;
  PlayField _field;

  ZombieGame() {
    _bg = Background(this);
    _field = PlayField(this);
  }

  @override
  void onTapDown(TapDownDetails details) {
    addAlarm(details);
  }

  void addAlarm(TapDownDetails details) {
    var _alarm = _field.createAlarm(
        details.globalPosition.dx, details.globalPosition.dy);
    if (_alarm != null) {
      add(_alarm.getComponent);
    }
  }

  void addZombie() {
    add(_field.createZombie(this).getComponent);
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
    _field.updateSprites(t);
  }
}
