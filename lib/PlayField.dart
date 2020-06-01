import 'dart:math';

import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/BladeSpinner.dart';
import 'package:zombie_sim/BloodyRubble.dart';
import 'package:zombie_sim/Fence.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/Zombie.dart';
import 'package:zombie_sim/Alarm.dart';
import 'package:zombie_sim/zombie_game.dart';

class PlayField {
  static const double COL_SIZE = 32; 
  static const double ROW_SIZE = 32;

  ZombieGame _game;

  final List<GridSprite> _sprites = List<GridSprite>();

  Iterable<Zombie> get _zombies => _sprites.where((e) => e is Zombie).cast<Zombie>();
  Iterable<Alarm> get _alarms => _sprites.where((e) => e is Alarm).cast<Alarm>();
  Iterable<Fence> get _fences => _sprites.where((e) => e is Fence).cast<Fence>();
  Iterable<BladeSpinner> get _spinners => _sprites.where((e) => e is BladeSpinner).cast<BladeSpinner>();

  Iterable<Attractor> get attractors => _sprites.where((e) => e is Attractor).cast<Attractor>();
  Iterable<GridSprite> get blockers => _sprites.where((e) => e.isObstacle);

  double get width => _game.size.width;
  double get height => _game.size.height;
  int get numCols => width ~/ COL_SIZE;
  int get numRows => height ~/ ROW_SIZE;

  PlayField(this._game);

  void createAlarm(double x, double y) {
    if (_game.level.numAlarms < 1) return;
    var a = Alarm(this, Point(x, y));
    if (_alarms.any((e) => e.location == a.location)) {
      return;
    }
    _sprites.add(a);
    _game.add(a.getComponent);
    _game.level.numAlarms -= 1;
  }

  void createFence(double x, double y) {
    if (_game.level.numFences < 1) return;
    var f = Fence(this, Point(x, y));
    if (_fences.any((e) => e.location == f.location)) {
      return;
    }
    _sprites.add(f);
    _game.add(f.getComponent);
    _game.level.numFences -= 1;
  }

  void createBladeSpinner(double x, double y) {
    if (_game.level.numSpinners < 1) return;
    var b = BladeSpinner(this, Point(x, y));
    if (blockers.any((e) => e.location == b.location)) {
      return;
    }
    _sprites.add(b);
    _game.add(b.getComponent);
    _game.level.numSpinners -= 1;
  }

  void removeFence(Fence f) {
    _sprites.remove(f);
    _game.components.remove(f.getComponent);
  }

  void removeZombie(Zombie zombie) {
    _sprites.remove(zombie);
    _game.components.remove(zombie.getComponent);
  }

  Zombie createZombie(ZombieGame zombieGame) {
    final z = Zombie(this);
    _sprites.add(z);
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
    return blockers.firstWhere(
        (e) => e.location.x == at.x && e.location.y == at.y, 
        orElse: () => null);
  }
}