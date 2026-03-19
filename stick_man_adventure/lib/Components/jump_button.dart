import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:stick_man_adventure/Game2D.dart';

class JumpButton extends SpriteComponent with HasGameReference<Game2d>, TapCallbacks{
  JumpButton();

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(570, 270);
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}