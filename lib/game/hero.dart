import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/gamerunner.dart';
import '/models/player_data.dart';
import 'dart:math';

enum PlayerState { running, jumping, falling, hit }

class HeroPlayer extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameReference<GameRunner> {
  double yMax = 0.0;

  double speedY = 0.0;

  final mockInput = List<double>.filled(360, 0);

  int setTime = 360;

  int index = 0;

  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  final double stepTime = 0.05;

  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation fallAnimation;
  late SpriteAnimation hitAnimation;

  HeroPlayer(this.playerData);

  @override
  FutureOr<void> onLoad() {
    loadAllAnimations();

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
    playerData.power += mockInput[index];
    index++;
    index = index % setTime;
    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is Enemy) && (!playerData.isHit)) {
      if (other.limit > playerData.power) {
        hit();
      } else {
        jump();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void onCollisionEnd(PositionComponent other) {
    playerData.power = 0;
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
    current = PlayerState.hit;
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(32, game.virtualSize.y - 43);
    size = Vector2.all(24);
    playerData.isHit = false;
    speedY = 0.0;
    playerData.power = 0.0;
    for (int i = 0; i < setTime; i++) {
      mockInput[i] = Random().nextDouble() * 2.0;
    }
  }

  void loadAllAnimations() {
    // Calls private(_) method to set animations
    runAnimation = _spriteAnimation(
        playerData.body, playerData.color, playerData.hat, 'Run', 12);
    jumpAnimation = _spriteAnimation(
        playerData.body, playerData.color, playerData.hat, 'Jump', 1);
    fallAnimation = _spriteAnimation(
        playerData.body, playerData.color, playerData.hat, 'Fall', 1);
    hitAnimation = _spriteAnimation(
        playerData.body, playerData.color, playerData.hat, 'Hit', 7);

    // List of all animations, assigned to their states
    animations = {
      PlayerState.running: runAnimation,
      PlayerState.jumping: jumpAnimation,
      PlayerState.falling: fallAnimation,
      PlayerState.hit: hitAnimation,
    };

    // Set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(
      String body, String color, String hat, String state, int frames) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('${body}_${color}_${hat}_$state.png'),
        SpriteAnimationData.sequenced(
          amount: frames, // Image has a set amount of pictures, no var needed
          stepTime: stepTime, // Could change, should use var
          textureSize: Vector2.all(32),
        ));
  }

  void _updatePlayerState() {
    // Default state = running
    PlayerState playerState = PlayerState.running;

    if (playerData.isHit && !_hitTimer.finished) {
      playerState = PlayerState.hit;
    } else {
      // Resets if coming back from being hit
      if (playerData.isHit) {
        _resetAfterHit();
      }
      // Checks if falling, sets to falling
      if (speedY > 0) {
        playerState = PlayerState.falling;
      }
      // Check if jumping, sets to jumping
      if (speedY < 0) {
        playerState = PlayerState.jumping;
      }
    }

    // Sets current animation to state identified
    current = playerState;
  }

  void _resetAfterHit() {
    playerData.isHit = false;
  }
}
