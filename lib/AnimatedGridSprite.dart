import 'package:flame/components/animation_component.dart';
import 'package:meta/meta.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/PlayField.dart';

abstract class AnimatedGridSprite extends GridSprite {
  @protected
  AnimationComponent component;
  get getComponent => component;

  AnimatedGridSprite(PlayField field): super(field);
}