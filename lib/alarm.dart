import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/zombie_game.dart';

class Alarm extends Attractor {
  static const double TEXTURE_SIZE = 32.0;
  static const double ANIMATE_FREQ = 0.1;

  AnimationComponent _component;
  get component => _component;

  Alarm(PlayField f, Point<double> p): super(f) {
    _component = AnimationComponent.sequenced(
      TEXTURE_SIZE, TEXTURE_SIZE, 'alarm-sheet.png', 2, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE, stepTime: ANIMATE_FREQ);
    setGridPosForPoint(p);
    _component.x = locationPoint.x;
    _component.y = locationPoint.y;
  }

  void render(Canvas c) {
    _component.render(c);
  }

  @override
  double getWeightedDistance(GridSprite to) {
    return sqrt( pow(to.loc.x - loc.x, 2) + pow(to.loc.y - loc.y, 2) );
  }
}