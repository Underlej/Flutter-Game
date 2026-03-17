import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:stick_man_adventure/Components/player.dart';
import 'package:stick_man_adventure/Components/level.dart';
import 'package:flutter/painting.dart';

class Game2d extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks{
  late final CameraComponent cam;
  Player player = Player(character: 'player');
  late JoystickComponent joystick;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 97, 91, 91);

  @override
  FutureOr<void> onLoad() async{
    // загрузка всех изображений в кэш
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'level_0'
    );

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    addJoystick();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png'),
        )
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }
  
  void updateJoystick() {
    switch (joystick.direction){
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      case JoystickDirection.up:
        player.hasJumped = true;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}