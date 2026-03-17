import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:stick_man_adventure/Components/custom_hitbox.dart';
import 'package:stick_man_adventure/Game2D.dart';

class Coin extends SpriteAnimationComponent 
with HasGameReference<Game2d>, CollisionCallbacks{
  Coin({
    position,
    size
    }) : super(position: position, size: size);

    bool _collected = false;
    final double stepTime = 0.13;
    final hitbox = CustomHitbox(
      offsetX: 10,
      offsetY: 10, 
      width: 12, 
      height: 12);

    @override
  FutureOr<void> onLoad() {
    //debugMode = true;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('items/Coin.png'), SpriteAnimationData.sequenced(
      amount: 3, 
      stepTime: stepTime,
      textureSize: Vector2.all(32)),
     );
    return super.onLoad();
  }
  
  void collidedWithPlayer() {
    if (!_collected){
      animation = SpriteAnimation.fromFrameData(game.images.fromCache('items/collected.png'), SpriteAnimationData.sequenced(
        amount: 6, 
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: false),
      );
      _collected = true;
    }
    Future.delayed(
      const Duration(milliseconds: 780),
      () => removeFromParent()
    );
  }
}