import 'dart:math';

import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/BloodyRubble.dart';
import 'package:zombie_sim/Fence.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/Zombie.dart';
import 'package:zombie_sim/Alarm.dart';
import 'package:zombie_sim/zombie_game.dart';

class PlayField {
  // trying to make the blocking look right by increasing this
  static const double COL_SIZE = 32; 
  static const double ROW_SIZE = 32;

  ZombieGame _game;

  final _zombies = List<Zombie>();
  final _alarms = List<Alarm>();
  final _fences = List<Fence>();

  double get width => _game.size.width;
  double get height => _game.size.height;
  int get numCols => width ~/ COL_SIZE;
  int get numRows => height ~/ ROW_SIZE;

  PlayField(this._game);

  List<GridSprite> getBlockers() {
    return _zombies.cast<GridSprite>() + _fences.cast<GridSprite>();
  }

  List<Attractor> getAttractors() {
    return _alarms.cast<Attractor>();
  }

  Alarm createAlarm(double x, double y) {
    var a = Alarm(this, Point(x, y));
    if (_alarms.any((e) => e.location == a.location)) {
      return null;
    }
    _alarms.add(a);
    return a;
  }

  void createFence(double x, double y) {
    var f = Fence(this, Point(x, y));
    if (_fences.any((e) => e.location == f.location)) {
      return;
    }
    _fences.add(f);
    _game.add(f.getComponent);
  }

  void removeFence(Fence f) {
    _fences.remove(f);
    _game.components.remove(f.getComponent);
  }

  Zombie createZombie(ZombieGame zombieGame) {
    final z = Zombie(this);
    _zombies.add(z);
    return z;
  }

  void addBloodyRubble(GridPoint p) {
    _game.components.add(BloodyRubble(this, p).getComponent);
  }

  void updateSprites(double t) {
    _zombies.forEach((p) {
      p.move(t);
    });
  }

  GridSprite getOccupier(GridPoint at) {
    return getBlockers().firstWhere(
        (e) => e.location.x == at.x && e.location.y == at.y, 
        orElse: () => null);
  }
}