import 'package:dino_run/game/navigation_arrow.dart';
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
  int limit = 0;
  static const _imageAssets = [
    'AutumnBackground.png',
    'WinterBackground.png',
    'SummerBackground.png',
    'LeftArrow.png',
    'RightArrow.png',
    'DisplayBoxBodies.png',
    'DisplayBoxColors.png',
    'DisplayBoxHats.png',
    'sawOn.png',
    'Astro_Blue_CowboyHat_Fall.png',
    'Astro_Blue_CowboyHat_Jump.png',
    'Astro_Blue_CowboyHat_Run.png',
    'Astro_Blue_CowboyHat_Hit.png',
    'Astro_Blue_NoHat_Fall.png',
    'Astro_Blue_NoHat_Jump.png',
    'Astro_Blue_NoHat_Run.png',
    'Astro_Blue_NoHat_Hit.png',
    'Astro_Red_CowboyHat_Fall.png',
    'Astro_Red_CowboyHat_Jump.png',
    'Astro_Red_CowboyHat_Run.png',
    'Astro_Red_CowboyHat_Hit.png',
    'Astro_Red_NoHat_Fall.png',
    'Astro_Red_NoHat_Jump.png',
    'Astro_Red_NoHat_Run.png',
    'Astro_Red_NoHat_Hit.png',
    'Astro_Green_CowboyHat_Fall.png',
    'Astro_Green_CowboyHat_Jump.png',
    'Astro_Green_CowboyHat_Run.png',
    'Astro_Green_CowboyHat_Hit.png',
    'Astro_Green_NoHat_Fall.png',
    'Astro_Green_NoHat_Jump.png',
    'Astro_Green_NoHat_Run.png',
    'Astro_Green_NoHat_Hit.png',
    'Astro_Yellow_CowboyHat_Fall.png',
    'Astro_Yellow_CowboyHat_Jump.png',
    'Astro_Yellow_CowboyHat_Run.png',
    'Astro_Yellow_CowboyHat_Hit.png',
    'Astro_Yellow_NoHat_Fall.png',
    'Astro_Yellow_NoHat_Jump.png',
    'Astro_Yellow_NoHat_Run.png',
    'Astro_Yellow_NoHat_Hit.png',
    'Astro_Orange_CowboyHat_Fall.png',
    'Astro_Orange_CowboyHat_Jump.png',
    'Astro_Orange_CowboyHat_Run.png',
    'Astro_Orange_CowboyHat_Hit.png',
    'Astro_Orange_NoHat_Fall.png',
    'Astro_Orange_NoHat_Jump.png',
    'Astro_Orange_NoHat_Run.png',
    'Astro_Orange_NoHat_Hit.png',
    'John_Blue_CowboyHat_Fall.png',
    'John_Blue_CowboyHat_Jump.png',
    'John_Blue_CowboyHat_Run.png',
    'John_Blue_CowboyHat_Hit.png',
    'John_Blue_NoHat_Fall.png',
    'John_Blue_NoHat_Jump.png',
    'John_Blue_NoHat_Run.png',
    'John_Blue_NoHat_Hit.png',
    'John_Red_CowboyHat_Fall.png',
    'John_Red_CowboyHat_Jump.png',
    'John_Red_CowboyHat_Run.png',
    'John_Red_CowboyHat_Hit.png',
    'John_Red_NoHat_Fall.png',
    'John_Red_NoHat_Jump.png',
    'John_Red_NoHat_Run.png',
    'John_Red_NoHat_Hit.png',
    'John_Green_CowboyHat_Fall.png',
    'John_Green_CowboyHat_Jump.png',
    'John_Green_CowboyHat_Run.png',
    'John_Green_CowboyHat_Hit.png',
    'John_Green_NoHat_Fall.png',
    'John_Green_NoHat_Jump.png',
    'John_Green_NoHat_Run.png',
    'John_Green_NoHat_Hit.png',
    'John_Yellow_CowboyHat_Fall.png',
    'John_Yellow_CowboyHat_Jump.png',
    'John_Yellow_CowboyHat_Run.png',
    'John_Yellow_CowboyHat_Hit.png',
    'John_Yellow_NoHat_Fall.png',
    'John_Yellow_NoHat_Jump.png',
    'John_Yellow_NoHat_Run.png',
    'John_Yellow_NoHat_Hit.png',
    'John_Orange_CowboyHat_Fall.png',
    'John_Orange_CowboyHat_Jump.png',
    'John_Orange_CowboyHat_Run.png',
    'John_Orange_CowboyHat_Hit.png',
    'John_Orange_NoHat_Fall.png',
    'John_Orange_NoHat_Jump.png',
    'John_Orange_NoHat_Run.png',
    'John_Orange_NoHat_Hit.png',
    'Jane_Blue_CowboyHat_Fall.png',
    'Jane_Blue_CowboyHat_Jump.png',
    'Jane_Blue_CowboyHat_Run.png',
    'Jane_Blue_CowboyHat_Hit.png',
    'Jane_Blue_NoHat_Fall.png',
    'Jane_Blue_NoHat_Jump.png',
    'Jane_Blue_NoHat_Run.png',
    'Jane_Blue_NoHat_Hit.png',
    'Jane_Red_CowboyHat_Fall.png',
    'Jane_Red_CowboyHat_Jump.png',
    'Jane_Red_CowboyHat_Run.png',
    'Jane_Red_CowboyHat_Hit.png',
    'Jane_Red_NoHat_Fall.png',
    'Jane_Red_NoHat_Jump.png',
    'Jane_Red_NoHat_Run.png',
    'Jane_Red_NoHat_Hit.png',
    'Jane_Green_CowboyHat_Fall.png',
    'Jane_Green_CowboyHat_Jump.png',
    'Jane_Green_CowboyHat_Run.png',
    'Jane_Green_CowboyHat_Hit.png',
    'Jane_Green_NoHat_Fall.png',
    'Jane_Green_NoHat_Jump.png',
    'Jane_Green_NoHat_Run.png',
    'Jane_Green_NoHat_Hit.png',
    'Jane_Yellow_CowboyHat_Fall.png',
    'Jane_Yellow_CowboyHat_Jump.png',
    'Jane_Yellow_CowboyHat_Run.png',
    'Jane_Yellow_CowboyHat_Hit.png',
    'Jane_Yellow_NoHat_Fall.png',
    'Jane_Yellow_NoHat_Jump.png',
    'Jane_Yellow_NoHat_Run.png',
    'Jane_Yellow_NoHat_Hit.png',
    'Jane_Orange_CowboyHat_Fall.png',
    'Jane_Orange_CowboyHat_Jump.png',
    'Jane_Orange_CowboyHat_Run.png',
    'Jane_Orange_CowboyHat_Hit.png',
    'Jane_Orange_NoHat_Fall.png',
    'Jane_Orange_NoHat_Jump.png',
    'Jane_Orange_NoHat_Run.png',
    'Jane_Orange_NoHat_Hit.png',
  ];

  late HeroPlayer hero;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  List bodyArray = ["Astro", "John", "Jane"];
  List colorArray = ["Blue", "Red", "Yellow", "Orange", "Green"];
  List hatArray = ["NoHat", "CowboyHat"];
  int bodyIndex = 0, colorIndex = 0, hatIndex = 0;
  late NavigationArrow leftBodyArrow, rightBodyArrow;
  late NavigationArrow leftColorArrow, rightColorArrow;
  late NavigationArrow leftHatArrow, rightHatArrow;
  late SpriteComponent displayBoxBody, displayBoxColor, displayBoxHat;
  bool fingerOnScreen = false;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    playerData = await _readPlayerData();

    await images.loadAll(_imageAssets);

    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;

    _loadBackground();
  }

  void startGamePlay() {
    hero = HeroPlayer(playerData);
    _enemyManager = EnemyManager();
    _enemyManager.limit = limit;
    world.add(hero);
    world.add(_enemyManager);
    _loadBackground();
  }

  void _disconnectActors() {
    hero.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();

    playerData.currentScore = 0;
    playerData.lives = 3;
    playerData.power = 0.0;
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

  void _loadBackground() async {
    String backgroundName = 'SummerBackground.png';

    if (limit == 300) {
      backgroundName = 'AutumnBackground.png';
    } else if (limit == 500) {
      backgroundName = 'WinterBackground.png';
    }

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData(backgroundName),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    camera.backdrop.add(parallaxBackground);
  }

  void loadCustomizeMenu() {
    // To initialize and not crash if customizing first
    _enemyManager = EnemyManager();

    hero = HeroPlayer(playerData);
    world.add(hero);
    _loadBackground();

    leftBodyArrow = NavigationArrow(playerData, "Left", "Body");
    rightBodyArrow = NavigationArrow(playerData, "Right", "Body");
    leftColorArrow = NavigationArrow(playerData, "Left", "Color");
    rightColorArrow = NavigationArrow(playerData, "Right", "Color");
    leftHatArrow = NavigationArrow(playerData, "Left", "Hat");
    rightHatArrow = NavigationArrow(playerData, "Right", "Hat");

    world.add(leftBodyArrow);
    world.add(rightBodyArrow);
    world.add(leftColorArrow);
    world.add(rightColorArrow);
    world.add(leftHatArrow);
    world.add(rightHatArrow);

    displayBoxBody = SpriteComponent(
        sprite: Sprite(images.fromCache("DisplayBoxBodies.png")));
    displayBoxBody.position.x = size.x - 196;
    displayBoxBody.position.y = size.y - 124;
    displayBoxColor = SpriteComponent(
        sprite: Sprite(images.fromCache("DisplayBoxColors.png")));
    displayBoxColor.position.x = size.x - 196;
    displayBoxColor.position.y = size.y - 104;
    displayBoxHat = SpriteComponent(
        sprite: Sprite(images.fromCache("DisplayBoxBodies.png")));
    displayBoxHat.position.x = size.x - 196;
    displayBoxHat.position.y = size.y - 84;

    world.add(displayBoxBody);
    world.add(displayBoxColor);
    world.add(displayBoxHat);
  }

  void closeMenu() {
    hero.removeFromParent();
    leftBodyArrow.removeFromParent();
    rightBodyArrow.removeFromParent();
    leftColorArrow.removeFromParent();
    rightColorArrow.removeFromParent();
    leftHatArrow.removeFromParent();
    rightHatArrow.removeFromParent();
    displayBoxBody.removeFromParent();
    displayBoxColor.removeFromParent();
    displayBoxHat.removeFromParent();
  }
}
