import 'dart:math';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/gamerunner.dart';
import '/models/enemy_data.dart';

class EnemyManager extends Component with HasGameReference<GameRunner> {
  final List<EnemyData> _data = [];

  final Random _random = Random();

  final Timer _timer = Timer(5, repeat: true);

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {

    final randomIndex = _random.nextInt(_data.length);

    final enemyData = _data.elementAt(randomIndex);

    final enemy = Enemy(enemyData);

    enemy.anchor = Anchor.bottomLeft;

    enemy.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 24,
    );

    enemy.size = enemyData.textureSize;

    game.world.add(enemy);
  }

  @override
  void onMount() {

    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {

      _data.addAll([

        EnemyData(
          image: game.images.fromCache('enemy.png'),
          textureSize: Vector2(36, 30),
          speedX: 80,
        ),
      ]);
    }
    _timer.start();

    super.onMount();
  }

  @override
  void update(double dt) {

    _timer.update(dt);

    super.update(dt);
  }

  void removeAllEnemies() {

    final enemies = game.world.children.whereType<Enemy>();

    for (var enemy in enemies) {
      
      enemy.removeFromParent();
    }
  }
}
