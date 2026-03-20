import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:stick_man_adventure/Game2D.dart';

class StartGame {
  void start(BuildContext context) async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameWidget(
          game: Game2d(),
        ),
      ),
    );
  }
}

