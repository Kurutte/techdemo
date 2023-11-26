import 'package:flame/extensions.dart';

class EnemyData {
  final Image image;
  final Vector2 textureSize;
  final double speedX;

  const EnemyData({
    required this.image,
    required this.textureSize,
    required this.speedX,
  });
}
