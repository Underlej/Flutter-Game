import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:stick_man_adventure/Components/Coin.dart';
import 'package:stick_man_adventure/Components/collision_block.dart';
import 'package:stick_man_adventure/Components/custom_hitbox.dart';
import 'package:stick_man_adventure/Components/serych.dart';
import 'package:stick_man_adventure/Components/utils.dart';
import 'package:stick_man_adventure/Game2D.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, running, jumping, falling, hit, appearing }

class Player extends SpriteAnimationGroupComponent 
    with HasGameRef<Game2d>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({position, 
  this.character = 'player'
  }) : super(position: position);
  
  final double stepTime = 0.15;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 200;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 50;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  List<CollisionBlock> collisionBlocks = [];
  final hitbox = CustomHitbox(
    offsetX: 0, 
    offsetY: 0, 
    width: 9, 
    height: 26);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    //debugMode = true;

    startingPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height)
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotHit){
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
    }
    
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
     keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
     keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Coin) other.collidedWithPlayer();
    if (other is Serych) _respawn();
    super.onCollision(intersectionPoints, other);
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteAnimation('None', 1);
    runningAnimation = _spriteAnimation('Move', 6);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 10);
    appearingAnimation = _spriteAnimation('Appearing', 6);

    // список всех анимаций
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
    };

    //установка текущей анимации
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('$character/$state.png'), 
      SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(9, 26)
      )
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }

    // соответствует ли движение бегу
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // проверка если параметр падения равен значению падения
    if (velocity.y > 0) playerState = PlayerState.falling;

    // проверка равен ли значения прыжка и параметр прыжка
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt){

    if (hasJumped && isOnGround) _playerJump(dt);

    //if (velocity.y > _gravity) isOnGround = false; optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = - _jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }
  
  void _checkHorizontalCollisions() {
    for(final block in collisionBlocks){
      if (!block.isPlatform) {
        if (checkCollision(this, block)){
          if (velocity.x > 0){
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.offsetX + width;
            break;
          }
        }
      }
    }
  }
  
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(- _jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }
  
  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
  
  void _respawn() {
    const hitDuration = Duration(milliseconds: 1200);
    const appearingDuration = Duration(milliseconds: 940);
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;
    Future.delayed(hitDuration, () {
      scale.x = 1;
      position = startingPosition;
      current = PlayerState.appearing;
      Future.delayed(appearingDuration, () {
        velocity = Vector2.zero();
        _updatePlayerState();
        Future.delayed(canMoveDuration, () => gotHit = false);
      });
    });
    
  }
}