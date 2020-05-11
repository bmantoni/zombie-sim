import 'dart:ui';

import 'package:flame/components/animation_component.dart';

class Alarm {
  static const double TEXTURE_SIZE = 32.0;
  static const double ANIMATE_FREQ = 0.1;

  AnimationComponent _component;
  get component => _component;

  Alarm(double x, double y) {
    _component = AnimationComponent.sequenced(
      TEXTURE_SIZE, TEXTURE_SIZE, 'alarm-sheet.png', 2, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE, stepTime: ANIMATE_FREQ);
    _component.x = x;
    _component.y = y;
  }

  void render(Canvas c) {
    _component.render(c);
  }
}