import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/PlayField.dart';

class BloodyRubble extends GridSprite {
  SpriteComponent _component;
  get getComponent => _component;

  BloodyRubble(PlayField f, GridPoint p) : super(f) {
    _component = SpriteComponent.fromSprite(32.0, 32.0, new Sprite('bloody_rubble-1.png'));
    this.loc = p;
    _component.x = locationPoint.x;
    _component.y = locationPoint.y;
  }

  @override
  void destroy() {
  }

  @override
  bool get isMoveable => false;

  @override
  bool get isObstacle => false;

  @override
  int get strength => 0;
}