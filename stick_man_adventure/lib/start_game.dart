import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:stick_man_adventure/Game2D.dart';

class StartGame{
  void start() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    Game2d game = Game2d();
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameWidget(
          game: kDebugMode ? Game2d() : game,
        ),
      ),
    );
  }
}

