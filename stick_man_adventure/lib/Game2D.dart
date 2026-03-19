import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:stick_man_adventure/Components/jump_button.dart';
import 'package:stick_man_adventure/Components/player.dart';
import 'package:stick_man_adventure/Components/level.dart';
import 'package:flutter/painting.dart';

class Game2d extends FlameGame
 with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection{
  late CameraComponent cam;
  Player player = Player(character: 'player');
  late JoystickComponent joystick;
  // final int amountCoins = 0;
  List<String> levelNames = ['level_0', 'level_0'];
  int currentLevelIndex = 0;
  JumpButton jumpButton = JumpButton();

  @override
  Color backgroundColor() => const Color.fromRGBO(34, 32, 52, 100);

  @override
  FutureOr<void> onLoad() async{
    // загрузка всех изображений в кэш
    await images.loadAllImages();
    addJoystick();
    add(jumpButton);
    _loadLevel();
    

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
      margin: const EdgeInsets.only(left: 1, bottom: 16),
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
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel(){
    if (currentLevelIndex < levelNames.length - 1){
      currentLevelIndex++;
      _loadLevel();
    } else {
      // уровней не будет
    }
  }
  
  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex]
      );

      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360);
      cam.viewfinder.anchor = Anchor.topLeft;

      cam.viewport.addAll([joystick, jumpButton]);

      addAll([cam, world]);
    });
  }
}