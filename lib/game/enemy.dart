import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '/game/gamerunner.dart';
import '/models/enemy_data.dart';

enum EnemyState { idle }

class Enemy extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameReference<GameRunner> {
  final EnemyData enemyData;

  Enemy(this.enemyData);

  int limit = 0;

  late final SpriteAnimation sawAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAnimation();

    return super.onLoad();
  }

  @override
  void onMount() {
    size *= 0.4;

    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= enemyData.speedX * dt;

    position.y = game.virtualSize.y - 43;

    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
      if (!game.playerData.isHit) {
        game.playerData.currentScore += 10;
      } else {
        game.playerData.isHit = false;
      }
    }

    super.update(dt);
  }

  void _loadAnimation() {
    sawAnimation = _spriteAnimation(8);

    // List of all animations, assigned to their states
    animations = {EnemyState.idle: sawAnimation};

    // Set current animation
    current = EnemyState.idle;
  }

  SpriteAnimation _spriteAnimation(int frames) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('sawOn.png'),
        SpriteAnimationData.sequenced(
          amount: frames, // Image has a set amount of pictures, no var needed
          stepTime: 0.05, // Could change, should use var
          textureSize: Vector2.all(38),
        ));
  }
}
