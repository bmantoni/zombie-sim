import 'package:flame/components/component.dart';
import 'package:zombie_sim/HudSelector.dart';
import 'package:zombie_sim/zombie_game.dart';

class HUD {
  static const double HUD_ITEM_HEIGHT = 48;
  static const double HUD_V_MARGIN = 32;
  static const double HUD_H_MARGIN = 30;

  List<SpriteComponent> _menuItems;
  List<SpriteComponent> get menuItems => _menuItems;

  ZombieGame _game;

  HUD(ZombieGame g) {
    this._game = g;
    _menuItems = [ 
      HudSelector(_game, 'alarm.png', PlaceSelection.Alarm, (p) => p.level.numAlarms), 
      HudSelector(_game, 'fence.png', PlaceSelection.Fence, (p) => p.level.numFences), 
      HudSelector(_game, 'blade-spinner-frame.png', PlaceSelection.Spinner, (p) => p.level.numSpinners) ];
  }

  void setItemPositions() {
    double x = HUD_H_MARGIN;
    _menuItems.forEach((e) { 
      e.y = _game.size.height - HUD_ITEM_HEIGHT - HUD_V_MARGIN;
      e.x = x;
      x += HUD_ITEM_HEIGHT + HUD_H_MARGIN;
    });
  }
}
