import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/gamerunner.dart';
import '/models/player_data.dart';

enum PlayerState { idle, running, jumping, falling }

class HeroPlayer extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameReference<GameRunner> {
  double yMax = 0.0;

  double speedY = 0.0;

  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  final double stepTime = 0.05;

  late final SpriteAnimation runAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation fallAnimation;

  HeroPlayer(Image image, this.playerData);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    return super.onLoad();
  }

  @override
  void onMount() {
    _reset();

    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
      ),
    );
    yMax = y;

    super.onMount();
  }

  @override
  void update(double dt) {
    _updatePlayerState();

    speedY += gravity * dt;
    y += speedY * dt;
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
    }
    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is Enemy) && (!playerData.isHit)) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  bool get isOnGround => (y >= yMax);

  void jump() {
    if (isOnGround) {
      speedY = -300;
    }
  }

  void hit() {
    playerData.isHit = true;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(32, game.virtualSize.y - 55);
    size = Vector2.all(24);
    playerData.isHit = false;
    speedY = 0.0;
  }

  void _loadAllAnimations() {
    // Calls private(_) method to set animations
    runAnimation = _spriteAnimation('Run', 12);
    jumpAnimation = _spriteAnimation('Jump', 1);
    fallAnimation = _spriteAnimation('Fall', 1);

    // List of all animations, assigned to their states
    animations = {
      PlayerState.running: runAnimation,
      PlayerState.jumping: jumpAnimation,
      PlayerState.falling: fallAnimation
    };

    // Set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int frames) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Char_$state.png'),
        SpriteAnimationData.sequenced(
          amount: frames, // Image has a set amount of pictures, no var needed
          stepTime: stepTime, // Could change, should use var
          textureSize: Vector2.all(32),
        ));
  }

  void _updatePlayerState() {
    // Default state = running
    PlayerState playerState = PlayerState.running;

    // Checks if falling, sets to falling
    if (speedY > 0) {
      playerState = PlayerState.falling;
    }

    // Check if jumping, sets to jumping
    if (speedY < 0) {
      playerState = PlayerState.jumping;
    }

    // Sets current animation to state identified
    current = playerState;
  }
}
