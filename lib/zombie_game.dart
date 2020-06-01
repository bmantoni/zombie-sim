import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/sprite.dart';
import 'package:zombie_sim/HUD.dart';
import 'package:zombie_sim/Level.dart';
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

enum PlaceSelection { Alarm, Fence, Spinner }

class ZombieGame extends BaseGame {
  Background _bg;
  HUD _hud;
  PlayField field;
  PlaceSelection selected;

  Level _level;
  Level get level => _level;

  ZombieGame() {
    _level = Level(2, 5, 3);
    
    _bg = Background(this);
    add(_bg);
    field = PlayField(this);
    _hud = HUD(this);
    _hud.menuItems.forEach((e) { add(e); });
  }

  void addZombie() {
    add(field.createZombie(this).getComponent);
  }

  void setActiveSelection(PlaceSelection s) {
    this.selected = s;
  }

  @override
  void render(Canvas canvas) {
    //_bg.render(canvas);
    super.render(canvas);
    _hud.setItemPositions();
  }

  @override
  void update(double t) {
    super.update(t);
    field.updateSprites(t);
  }
}
