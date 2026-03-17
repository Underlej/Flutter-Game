import 'dart:async';

import 'package:flame/components.dart';
import 'package:stick_man_adventure/Game2D.dart';

class BackgroundTile extends SpriteComponent with HasGameReference<Game2d>{
  final String color;
  BackgroundTile({
    this.color = 'Blue', 
    position
  }) : super(position: position);

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(32);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 32;
    int scrollheight = (game.size.y / tileSize).floor();
    if (position.y > scrollheight * tileSize) position.y = -tileSize;
    super.update(dt);
  }
}