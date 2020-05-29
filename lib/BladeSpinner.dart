import 'dart:math';

import 'package:flame/components/animation_component.dart';
import 'package:zombie_sim/AnimatedGridSprite.dart';
import 'package:zombie_sim/PlayField.dart';

class BladeSpinner extends AnimatedGridSprite {
  static const double TEXTURE_SIZE = 32.0;
  static const double ANIMATE_FREQ = 0.1;

  @override
  bool get isMoveable => false;
  @override
  bool get isObstacle => true;
  @override
  bool get isKiller => true;
  @override
  int get strength => 1;

  BladeSpinner(PlayField f, Point<double> p): super(f) {
    component = AnimationComponent.sequenced(
      TEXTURE_SIZE, TEXTURE_SIZE, 'blade_spinner.png', 3, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE, stepTime: ANIMATE_FREQ);
    setGridPosForPoint(p);
    component.x = locationPoint.x;
    component.y = locationPoint.y;
  }

  @override
  void destroy() {
    component.destroy();
  }
}