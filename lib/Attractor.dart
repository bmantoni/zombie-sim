import 'package:zombie_sim/AnimatedGridSprite.dart';
import 'package:zombie_sim/GridSprite.dart';

abstract class Attractor extends AnimatedGridSprite {
  Attractor(field): super(field);
  double getWeightedDistance(GridSprite to);
}