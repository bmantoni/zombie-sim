import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zombie_sim/HUD.dart';
import 'package:zombie_sim/zombie_game.dart';

class HudSelector extends SpriteComponent with Tapable {
  ZombieGame _game;
  PlaceSelection _s;
  TextConfig _text;
  int Function(ZombieGame) val;

  HudSelector(this._game, String spriteFile, this._s, this.val) : super.fromSprite(HUD.HUD_ITEM_HEIGHT, HUD.HUD_ITEM_HEIGHT, new Sprite(spriteFile)) {
    _text = TextConfig(fontSize: 20.0, color: Colors.white);
  }

  void onTapDown(TapDownDetails details) {
    _game.setActiveSelection(_s);
  }

  @override
  bool isHud() {
    return true;
  }

  @override
  void render(Canvas canvas) {
    _text.render(canvas, val(_game).toString(), Position(this.x + 40, this.y + 40));
    super.render(canvas);
  }
}