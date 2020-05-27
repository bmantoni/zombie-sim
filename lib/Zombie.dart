import 'package:flame/components/animation_component.dart';
import 'package:zombie_sim/AnimatedGridSprite.dart';
import 'package:zombie_sim/Attractor.dart';
import 'package:zombie_sim/GridPoint.dart';
import 'package:zombie_sim/GridSprite.dart';
import 'package:zombie_sim/PlayField.dart';
import 'package:zombie_sim/Randomiser.dart';

enum MovementMode { Random, Attracted }

class Zombie extends AnimatedGridSprite {
  // to tune the starting positions
  static const int SPAWN_HEIGHT_RANGE      = 5;
  static const int SPAWN_RIGHT_MARGIN_COLS = 3;

  // how frequently to move (higher:more often)
  static const int MOVE_FREQ               = 5;

  // how frequently to animate sprite (lower:slower)
  static const double ANIMATE_FREQ         = 0.3;

  // fixed based on sprite sheet
  static const double TEXTURE_SIZE         = 32.0;
  static const double ZOMBIE_SIZE          = TEXTURE_SIZE * 2;

  // 1 / X, chance to move 2, and possibly jump an obstacle
  // so, 1%
  static const int JUMP_OBSTACLE_CHANCE    = 100;

  static const double LOCKON_COOLDOWN      = 0.15;
  static const int RETHINK_MOVE_FREQ       = 2;
  static const int MAX_LOCKON_DIST         = 20;

  MovementMode _mode = MovementMode.Random;
  double _rethinkMovementModeEveryTics = 0;
  double _timeSinceRethoughtMovement = 0;
  double _lockonCooldownRemaining = 0;
  double _timeSinceMove = 0;

  Randomiser _r = Randomiser();
  double _moveEveryTics = 0;

  @override
  bool get isMoveable => true;
  @override
  bool get isObstacle => true;
  @override
  int get strength => 1;

  Zombie(PlayField field) : super(field) {
    setRandomMoveDelay();
    setRandomRethinkDelay();

    component = AnimationComponent.sequenced(
        ZOMBIE_SIZE, ZOMBIE_SIZE, 'zombie-v3-sheet.png', 3,
        textureWidth: TEXTURE_SIZE,
        textureHeight: TEXTURE_SIZE,
        stepTime: ANIMATE_FREQ);
    setStartPosition();
  }

  @override
  void destroy() {
    component.destroy();
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

    _lockonCooldownRemaining =
        _lockonCooldownRemaining > 0 ? _lockonCooldownRemaining - timeSince : 0;

    _timeSinceRethoughtMovement += timeSince;
    _rethinkMovementMode();

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

  void _rethinkMovementMode() {
    switch (_mode) {
      case MovementMode.Random:
        lockonIfSomethingIsClose();
        break;
      case MovementMode.Attracted:
        randomlyGoBackToRandom();
        break;
    }
  }

  void setRandomRethinkDelay() {
    _rethinkMovementModeEveryTics = _r.getRand(1, RETHINK_MOVE_FREQ) / 12;
  }

  void randomlyGoBackToRandom() {
    if (_timeSinceRethoughtMovement > _rethinkMovementModeEveryTics) {
      _timeSinceRethoughtMovement = 0;      
      _r.doRandomly(1, 2, () {
        _mode = MovementMode.Random;
        setRandomRethinkDelay();
        _lockonCooldownRemaining = LOCKON_COOLDOWN;
        print("Switched to random");
      });
    }
  }

  void lockonIfSomethingIsClose() {
    if (_lockonCooldownRemaining <= 0 && field.getAttractors().length > 0) {
      final nearest = _getNearestAttractor();
      if (nearest.getWeightedDistance(this) < MAX_LOCKON_DIST) {
        _mode = MovementMode.Attracted;
        print("Locked on");
      }
    }
  }

  void _moveTowardsAttractor() {
    if (field.getAttractors().length > 0) {
      final a = _getNearestAttractor();
      _moveTowards(a);
    }
  }

  Attractor _getNearestAttractor() {
    return field.getAttractors().reduce((value, element) =>
        value.getWeightedDistance(this) < element.getWeightedDistance(this)
            ? value
            : element);
  }

  void _moveTowards(Attractor a) {
    if (a.loc.x < loc.x) _move(Direction.Left, 1);
    if (a.loc.x > loc.x) _move(Direction.Right, 1);
    if (a.loc.y < loc.y) _move(Direction.Up, 1);
    if (a.loc.y > loc.y) _move(Direction.Down, 1);
  }

  void _moveRandomly() {
    var dist = _r.getRand(1, JUMP_OBSTACLE_CHANCE); 
    _move(Direction.values[_r.getRand(0, 3)], dist == 1 ? 2 : 1);
  }

  void _move(Direction direction, int distance) {
    translate(direction, distance: distance);
    updateComponentPosition();
  }

  void updateComponentPosition() {
    component.x = locationPoint.x;
    component.y = locationPoint.y;
  }
}