import 'package:flame/game.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final game = SpineExampleGame();

  @override
  Widget build(BuildContext context) => GameWidget(game: game);
}

class SpineExampleGame extends FlameGame {
  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onMount() async => add(SpineBoyComponent());
}

class SpineBoyComponent extends SpineComponent {
  SpineBoyComponent()
      : super(
          size: Vector2(470.65, 731.54) / 4,
          position: Vector2(100, 300),
          render: AssetSpineRender(
            name: 'spineboy',
            startAnimation: 'walk',
            loop: true,
            pathPrefix: 'assets/',
            fit: BoxFit.scaleDown,
          ),
        );
}
