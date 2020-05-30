import 'dart:math';

class Randomiser {

  static final Randomiser _singleton = Randomiser._internal();

  Random _random;

  factory Randomiser() {
    return _singleton;
  }

  Randomiser._internal() {
    _random = new Random();
  }

  int getRand(int min, int max) {
    return min + _random.nextInt(max + 1 - min);
  }

  void doRandomly(int chanceIn, int chanceOf, void f()) {
    if (getRand(1, chanceOf) <= chanceIn) f();
  }
}