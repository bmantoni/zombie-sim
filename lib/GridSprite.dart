import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/zombie_game.dart';

abstract class GridSprite {
  GridSprite(this.field);
  
  @protected
  PlayField field;

  @protected
  GridPoint loc;
  GridPoint get location => loc;

  Point<double> get locationPoint => getPointForGridPos(loc);

  Point<double> getPointForGridPos(GridPoint p) {
    return Point(p.x * PlayField.COL_SIZE, p.y * PlayField.ROW_SIZE);
  }

  void setGridPosForPoint(Point<double> p) {
    loc = GridPoint(roundTo(p.x, PlayField.COL_SIZE).round(), roundTo(p.y, PlayField.ROW_SIZE).round());
  }

  int roundTo(double x, double multiple) {
    return x ~/ multiple - 1 + (x % multiple > multiple ~/ 2 ? 1 : 0);
  }

  void translate(Direction direction, {distance = 1}) {
    if (direction == Direction.Left) loc.x -= distance;
    if (direction == Direction.Right) loc.x += distance;
    if (direction == Direction.Up) loc.y -= distance;
    if (direction == Direction.Down) loc.y += distance;
  }
}