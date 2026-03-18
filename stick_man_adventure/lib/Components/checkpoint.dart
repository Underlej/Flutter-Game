import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:stick_man_adventure/Components/player.dart';
import 'package:stick_man_adventure/Game2D.dart';

class Checkpoint extends SpriteAnimationComponent
 with HasGameReference<Game2d>, CollisionCallbacks{
  Checkpoint({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(RectangleHitbox(
      position: Vector2(16, 16),
      size: Vector2(16, 32),
      collisionType: CollisionType.passive
    ));
    priority = -1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/checkpoint/CheckpointNoActive.png'),
      SpriteAnimationData.sequenced(
        amount: 1, 
        stepTime: 1, 
        textureSize: Vector2.all(48)));
    return super.onLoad();
  }

  bool reachedCheckpoints = false;

  // @override
  // void update(double dt) {
  //   if (game.amountCoins == 3) _reachedCheckpoint();
  //   super.update(dt);
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckpoints) _reachedCheckpoint();
    super.onCollision(intersectionPoints, other);
  }
  
  void _reachedCheckpoint() {
    reachedCheckpoints = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/checkpoint/CkeckpointActive.png'),
      SpriteAnimationData.sequenced(
        amount: 1, 
        stepTime: 1, 
        textureSize: Vector2.all(48),
        loop: false
      )
    );
    
    const doorDuration = Duration(milliseconds: 50);
    Future.delayed(doorDuration, () {
      animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/checkpoint/CheckpointNoActive.png'),
      SpriteAnimationData.sequenced(
        amount: 1, 
        stepTime: 1, 
        textureSize: Vector2.all(48)
      )
    );
    });
  }
}