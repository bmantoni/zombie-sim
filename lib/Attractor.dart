import 'package:zombie_sim/GridSprite.dart';

abstract class Attractor extends GridSprite {
  Attractor(field): super(field);
  double getWeightedDistance(GridSprite to);
}