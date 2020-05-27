import 'dart:math';

import 'package:meta/meta.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/PlayField.dart';

enum Direction { Left, Right, Up, Down }

abstract class GridSprite {
  GridSprite(this.field);
  
  @protected
  PlayField field;

  @protected
  GridPoint loc;
  GridPoint get location => loc;

  Point<double> get locationPoint => getPointForGridPos(loc);

  bool get isMoveable;
  bool get isObstacle;
  int get strength;

  void destroy();

  Point<double> getPointForGridPos(GridPoint p) {
    return Point(p.x * PlayField.COL_SIZE, p.y * PlayField.ROW_SIZE);
  }

  void setGridPosForPoint(Point<double> p) {
    loc = GridPoint(roundTo(p.x, PlayField.COL_SIZE), roundTo(p.y, PlayField.ROW_SIZE));
  }

  int roundTo(double x, double multiple) {
    return x ~/ multiple;
  }

  void translate(Direction direction, {distance = 1}) {
    GridPoint newPos = getNextPosition(direction, distance);
    // how to factor in the blockers?

    var o = field.getOccupier(newPos);
    if (o == null || !o.isObstacle) {
      loc = newPos;
      return;
    } else {
      o.applyForce(direction, strength);
    }
  }

  GridPoint getNextPosition(Direction direction, int distance) {
    GridPoint newPos = GridPoint(loc.x, loc.y);
    if (direction == Direction.Left) newPos.x -= distance;
    if (direction == Direction.Right) newPos.x += distance;
    if (direction == Direction.Up) newPos.y -= distance;
    if (direction == Direction.Down) newPos.y += distance;
    return newPos;
  }

  void applyForce(Direction direction, int force) {
    if (!isMoveable) {
      print("I'm not moveable.");
      if (force > strength) {
        print('BREAK!');
        destroy();
      }
      return;
    }

    GridPoint newPos = getNextPosition(direction, 1);

    var o = field.getOccupier(newPos);
    if (o == null || !o.isObstacle) {
      print("push ended with strength $force");
      // by not just moving to the next spot,
      // it has the effect of the opposite zombie being thrown across
      // with all the accumulated force.
      loc = getNextPosition(direction, force);
      return;
    } else {
      o.applyForce(direction, force + strength);
    }
  }
}