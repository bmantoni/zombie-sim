import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
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
    _menuItems = [ SelectorAlarm(_game), SelectorFence(_game), SelectorBladeSpinner(_game) ];
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

class SelectorFence extends SpriteComponent with Tapable {
  ZombieGame _game;
  SelectorFence(this._game) : super.fromSprite(HUD.HUD_ITEM_HEIGHT, HUD.HUD_ITEM_HEIGHT, new Sprite('fence.png'));
  @override
  bool isHud() {
    return true;
  }

  void onTapDown(TapDownDetails details) {
    _game.setActiveSelection(PlaceSelection.Fence);
  }
}

class SelectorAlarm extends SpriteComponent with Tapable {
  ZombieGame _game;
  SelectorAlarm(this._game) : super.fromSprite(HUD.HUD_ITEM_HEIGHT, HUD.HUD_ITEM_HEIGHT, new Sprite('alarm.png'));
  @override
  bool isHud() {
    return true;
  }

  void onTapDown(TapDownDetails details) {
    _game.setActiveSelection(PlaceSelection.Alarm);
  }
}

class SelectorBladeSpinner extends SpriteComponent with Tapable {
  ZombieGame _game;
  SelectorBladeSpinner(this._game) : super.fromSprite(HUD.HUD_ITEM_HEIGHT, HUD.HUD_ITEM_HEIGHT, new Sprite('blade-spinner-frame.png'));
  @override
  bool isHud() {
    return true;
  }

  void onTapDown(TapDownDetails details) {
    _game.setActiveSelection(PlaceSelection.Spinner);
  }
}