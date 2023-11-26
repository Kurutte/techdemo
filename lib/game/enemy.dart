import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/gamerunner.dart';
import '/models/enemy_data.dart';


class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameReference<GameRunner> {

  final EnemyData enemyData;

  Enemy(this.enemyData) {
    sprite = Sprite(enemyData.image);

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

    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
      game.playerData.currentScore += 10;
    }

    super.update(dt);
  }
}
