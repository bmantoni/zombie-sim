import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/PlayField.dart';

class Fence extends GridSprite {
  SpriteComponent _component;
  get getComponent => _component;

  Fence(PlayField f, Point<double> p) : super(f) {
    _component = SpriteComponent.fromSprite(32.0, 32.0, new Sprite('fence.png'));
    setGridPosForPoint(p);
    _component.x = locationPoint.x;
    _component.y = locationPoint.y;
  }

  @override
  bool get isMoveable => false;

  @override
  bool get isObstacle => true;

  @override
  bool get isKiller => false;

  @override
  int get strength => 4;

  @override
  void destroy() {
    _component.destroy();
    field.removeFence(this);
    field.addBloodyRubble(this.loc);
  }
}