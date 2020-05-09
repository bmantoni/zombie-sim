import 'package:flutter/material.dart';
import 'package:zombie_sim/zombie_game.dart';

class ZombieField extends StatefulWidget {
  ZombieField({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ZombieFieldState createState() => _ZombieFieldState();
}

class _ZombieFieldState extends State<ZombieField> {
  ZombieGame _game = ZombieGame();

  void _addZombie() {
    _game.addZombie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _game.widget,
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addZombie,
        tooltip: 'More Zombies',
        child: Icon(Icons.add),
      ),
    );
  }
}
