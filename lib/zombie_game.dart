import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/sprite.dart';

class Randomiser {
  final _random = new Random();

  int getRand(int min, int max) {
    return min + _random.nextInt(max + 1 - min);
  }
}

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

class Zombie {
  static const int SPAWN_MARGIN_H = 10;
  static const int SPAWN_MARGIN_T = 40;
  static const int SPAWN_HEIGHT_RANGE = 125;
  static const double TEXTURE_SIZE = 32.0;

  Randomiser _r = Randomiser();
  ZombieGame _game;
  PositionComponent _component;
  get component => _component;

  // have a reference to the Game, so I can know bounding

  Zombie(ZombieGame game) {
    _game = game;
    _component = AnimationComponent.sequenced(
      32.0, 32.0, 'zombie-v3-sheet.png', 3, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE);
    setStartPosition();
  }

  setStartPosition() {
    _component.x = _r.getRand(SPAWN_MARGIN_H, _game.size.width.round() - TEXTURE_SIZE.round()).toDouble();
    _component.y = _r.getRand(SPAWN_MARGIN_T, SPAWN_HEIGHT_RANGE).toDouble();
  }

  move() {
    final d = _r.getRand(0, 3);
    final dist = _r.getRand(0, 10);
    if (d == 0) _component.x -= dist;
    if (d == 1) _component.x += dist;
    if (d == 2) _component.y -= dist;
    if (d == 3) _component.y += dist;
  }
}

class ZombieGame extends BaseGame {
  final _zombies = <Zombie>[];
  
  //ZombieGame() {}

  void addZombie() {
    final z = Zombie(this);
    _zombies.add(z); 
    add(z.component);
  }
  
  /*@override
  void render(Canvas canvas) {

  }*/

  @override
  void update(double t) {
    _zombies.forEach((p) { p.move(); });
  }
}
