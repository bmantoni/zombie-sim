import 'dart:math';

class Randomiser {
  final _random = new Random();

  int getRand(int min, int max) {
    return min + _random.nextInt(max + 1 - min);
  }

  void doRandomly(int chanceIn, int changeOf, void f()) {
    if (getRand(1, changeOf) <= chanceIn) f();
  }
}