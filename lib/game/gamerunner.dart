import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '/game/hero.dart';
import '/widgets/hud.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

class GameRunner extends FlameGame with TapDetector, HasCollisionDetection {
  GameRunner({super.camera});

  static const _imageAssets = [
    'main.png',
    'enemy.png',
    'ground.png',
    'pixelBackground.png',
    'Char_Run.png',
    'Char_Jump.png',
    'Char_Fall.png',
    'saw.png',
    'sawOn.png'
  ];

  late HeroPlayer _hero;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    playerData = await _readPlayerData();

    await images.loadAll(_imageAssets);

    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('pixelBackground.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    camera.backdrop.add(parallaxBackground);
  }

  void startGamePlay() {
    _hero = HeroPlayer(images.fromCache('main.png'), playerData);
    _enemyManager = EnemyManager();

    world.add(_hero);
    world.add(_enemyManager);
  }

  void _disconnectActors() {
    _hero.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();

    playerData.currentScore = 0;
    playerData.lives = 3;
  }

  @override
  void update(double dt) {
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _hero.jump();
    }
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox =
        await Hive.openBox<PlayerData>('GameRunner.PlayerDataBox');
    final playerData = playerDataBox.get('GameRunner.PlayerData');

    if (playerData == null) {
      await playerDataBox.put('GameRunner.PlayerData', PlayerData());
    }

    return playerDataBox.get('GameRunner.PlayerData')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
