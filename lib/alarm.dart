import 'dart:math';

import 'package:flame/components/animation_component.dart';
import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/PlayField.dart';

class Alarm extends Attractor {
  static const double TEXTURE_SIZE = 32.0;
  static const double ANIMATE_FREQ = 0.1;

  @override
  bool get isMoveable => false;
  @override
  bool get isObstacle => false;
  @override
  int get strength => 1;

  Alarm(PlayField f, Point<double> p): super(f) {
    component = AnimationComponent.sequenced(
      TEXTURE_SIZE, TEXTURE_SIZE, 'alarm-sheet.png', 2, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE, stepTime: ANIMATE_FREQ);
    setGridPosForPoint(p);
    component.x = locationPoint.x;
    component.y = locationPoint.y;
  }

  @override
  double getWeightedDistance(GridSprite to) {
    return sqrt( pow(to.loc.x - loc.x, 2) + pow(to.loc.y - loc.y, 2) );
  }

  @override
  void destroy() {
    component.destroy();
  }
}