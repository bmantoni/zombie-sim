import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/alarm.dart';
import 'package:zombie_sim/background.dart';

class Randomiser {
  final _random = new Random();

  int getRand(int min, int max) {
    return min + _random.nextInt(max + 1 - min);
  }
}

class OtherSprite extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  OtherSprite() : super.fromSprite(32.0, 32.0, new Sprite('zombie-32-32.png'));

  @override
  void resize(Size size) {
    // we don't need to set the x and y in the constructor, we can set then here
    this.x = (size.width - this.width) / 2;
    this.y = (size.height - this.height) / 2;
  }
}

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
}

enum MovementMode { Random, Attracted }
enum Direction { Left, Right, Up, Down }

class Zombie extends GridSprite {
  // to tune the starting positions
  static const int SPAWN_HEIGHT_RANGE = 5;
  static const int SPAWN_RIGHT_MARGIN_COLS = 3;

  // how frequently to move (higher:more often)
  static const int MOVE_FREQ = 5;

  // how frequently to animate sprite (lower:slower)
  static const double ANIMATE_FREQ = 0.3;

  // fixed based on sprite sheet
  static const double TEXTURE_SIZE = 32.0;
  static const double ZOMBIE_SIZE = TEXTURE_SIZE * 3;

  MovementMode _mode = MovementMode.Attracted;

  Randomiser _r = Randomiser();
  double _moveEveryTics = 0;
  AnimationComponent _component;
  get component => _component;

  double _timeSinceMove = 0;

  Zombie(PlayField field) : super(field) {
    setRandomMoveDelay();

    _component = AnimationComponent.sequenced(
        ZOMBIE_SIZE, ZOMBIE_SIZE, 'zombie-v3-sheet.png', 3,
        textureWidth: TEXTURE_SIZE,
        textureHeight: TEXTURE_SIZE,
        stepTime: ANIMATE_FREQ);
    setStartPosition();
  }

  void setStartPosition() {
    loc = GridPoint(_r.getRand(1, field.numCols - SPAWN_RIGHT_MARGIN_COLS),
        _r.getRand(1, SPAWN_HEIGHT_RANGE));
    updateComponentPosition();
  }

  void setRandomMoveDelay() {
    _moveEveryTics = _r.getRand(1, MOVE_FREQ) / 2;
    _timeSinceMove = 0;
  }

  void move(double timeSince) {
    _timeSinceMove += timeSince;
    if (_timeSinceMove <= _moveEveryTics) return;

    switch (_mode) {
      case MovementMode.Random:
        _moveRandomly();
        setRandomMoveDelay();
        break;
      case MovementMode.Attracted:
        _moveTowardsAttractor();
        setRandomMoveDelay(); // and speed it up, since we're chasing something
        break;
      default:
    }
  }

  void _moveTowardsAttractor() {
    // find nearest & most attractive attractor
    //field.min
    //   look in an expanding square around self
    // move towards it
    if (field.getAttractors().length > 0) {
      final a = field.getAttractors().reduce((value, element) => 
        value.getWeightedDistance(this) < element.getWeightedDistance(this) ? 
        value : element);
      _moveTowards(a);
    }
  }

  void _moveTowards(Attractor a) {
    if (a.loc.x < loc.x) _move(Direction.Left, 1);
    if (a.loc.x > loc.x) _move(Direction.Right, 1);
    if (a.loc.y < loc.y) _move(Direction.Up, 1);
    if (a.loc.y > loc.y) _move(Direction.Down, 1);
  }

  void _moveRandomly() {
    var dist = _r.getRand(1, 5); // 20% change of moving 2
    _move(Direction.values[_r.getRand(0, 4)], dist == 1 ? 2 : 1);
  }

  void _move(Direction direction, int distance) {
    translate(direction, distance: distance);
    updateComponentPosition();
  }

  void updateComponentPosition() {
    _component.x = locationPoint.x;
    _component.y = locationPoint.y;
  }
}

class ZombieGame extends BaseGame with TapDetector {
  Background _bg;
  PlayField _field;

  ZombieGame() {
    _bg = Background(this);
    _field = PlayField(this);
  }

  @override
  void onTapDown(TapDownDetails details) {
    addAlarm(details);
  }

  void addAlarm(TapDownDetails details) {
    var _alarm = _field.createAlarm(
        details.globalPosition.dx, details.globalPosition.dy);
    if (_alarm != null) {
      add(_alarm.component);
    }
  }

  void addZombie() {
    add(_field.createZombie(this).component);
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
    _field.updateSprites(t);
  }
}
