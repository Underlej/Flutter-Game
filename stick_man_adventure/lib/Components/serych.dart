import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:stick_man_adventure/Game2D.dart';

class Serych extends SpriteAnimationComponent with HasGameReference<Game2d>{
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Serych({
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
    position, 
    size,
    }) : super(
          position: position,
          size: size
        );

  static const double serSpeed = 0.18;
  static const moveSpeed = 30;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox());

    if (isVertical){
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/Serych.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: serSpeed,
        textureSize: Vector2.all(16))
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical){
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    position.x += moveDirection * moveSpeed * dt;
    super.update(dt);
  }
  
  void _moveVertically(double dt) {
    if (position.y >= rangePos){
      moveDirection = -1;
    } else if (position.y <= rangeNeg){
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }
  
  void _moveHorizontally(double dt) {
    if (position.x >= rangePos){
      flipHorizontallyAroundCenter();
      moveDirection = -1;
    } else if (position.x <= rangeNeg){
      flipHorizontallyAroundCenter();
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}