import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/sprite.dart';
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

class GridPoint {
  GridPoint(this.x, this.y);
  int x;
  int y;
}

class PlayField {
  static const double COL_SIZE = 20;
  static const double ROW_SIZE = 20;

  ZombieGame _game;

  double get width => _game.size.width;
  double get height => _game.size.height;
  int get numCols => width ~/ COL_SIZE;
  int get numRows => height ~/ ROW_SIZE;

  PlayField(this._game);

  Point<double> getPointForGridPos(GridPoint p) {
    return Point(p.x * COL_SIZE, p.y * ROW_SIZE);
  }

  static GridPoint translate(int direction, GridPoint p, {distance = 1}) {
    var r = GridPoint(p.x, p.y);
    if (direction == 0) r.x -= distance;
    if (direction == 1) r.x += distance;
    if (direction == 2) r.y -= distance;
    if (direction >= 3) r.y += distance;
    return r;
  }
}

enum MovementMode {
  Random,
  Attracted
}

class Zombie {
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

  Randomiser _r = Randomiser();
  double _moveEveryTics = 0;
  PlayField _field;
  AnimationComponent _component;
  get component => _component;

  double _timeSinceMove = 0;
  GridPoint _loc;
  Point<double> get _locationPoint => _field.getPointForGridPos(_loc);

  Zombie(PlayField field) {
    _field = field;
    setRandomMoveDelay();

    _component = AnimationComponent.sequenced(
      ZOMBIE_SIZE, ZOMBIE_SIZE, 'zombie-v3-sheet.png', 3, textureWidth: TEXTURE_SIZE, textureHeight: TEXTURE_SIZE, stepTime: ANIMATE_FREQ);
    setStartPosition();
  }

  setStartPosition() {
    _loc = GridPoint(_r.getRand(1, _field.numCols - SPAWN_RIGHT_MARGIN_COLS), _r.getRand(1, SPAWN_HEIGHT_RANGE));
    updateComponentPosition();
  }

  setRandomMoveDelay() {
    _moveEveryTics = _r.getRand(1, MOVE_FREQ) / 2;
    _timeSinceMove = 0;
  }

  move(double timeSince) {
    _timeSinceMove += timeSince;
    if (_timeSinceMove > _moveEveryTics) {
      _move();
      setRandomMoveDelay();
    }
  }

  _move() {
    var dist = _r.getRand(1, 5); // 20% change of moving 2
    _loc = PlayField.translate(_r.getRand(0, 4), _loc, 
      distance: dist == 1 ? 2 : 1);
    updateComponentPosition();
  }
    
  void updateComponentPosition() {
    _component.x = _locationPoint.x;
    _component.y = _locationPoint.y;
  }
}

class ZombieGame extends BaseGame {
  var _bg;
  final _zombies = <Zombie>[];
  var _field;
  
  ZombieGame() {
    _bg = Background(this);
    _field = PlayField(this);
  }

  void addZombie() {
    final z = Zombie(_field);
    _zombies.add(z); 
    add(z.component);
  }
  
  @override
  void render(Canvas canvas) {
    //_zombies.forEach((p) { p.component.render(canvas); });
    _bg.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
    _zombies.forEach((p) { p.move(t); });
  }
}
