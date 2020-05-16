import 'dart:math';

import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/Zombie.dart';
import 'package:zombie_sim/Alarm.dart';
import 'package:zombie_sim/zombie_game.dart';

class PlayField {
  static const double COL_SIZE = 20;
  static const double ROW_SIZE = 20;

  ZombieGame _game;

  final _zombies = List<Zombie>();
  final _alarms = List<Alarm>();

  double get width => _game.size.width;
  double get height => _game.size.height;
  int get numCols => width ~/ COL_SIZE;
  int get numRows => height ~/ ROW_SIZE;

  PlayField(this._game);

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

  Zombie createZombie(ZombieGame zombieGame) {
    final z = Zombie(this);
    _zombies.add(z);
    return z;
  }

  void updateSprites(double t) {
    _zombies.forEach((p) {
      p.move(t);
    });
  }

  GridSprite getOccupier(GridPoint at) {
    return _zombies.firstWhere(
        (e) => e.location.x == at.x && e.location.y == at.y, 
        orElse: () => null);
  }
}