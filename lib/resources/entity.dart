import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/utils/game_methods.dart';

class Entity extends SpriteAnimationComponent
    with HasCollisionDetection, CollisionCallbacks {
  bool isFacingRight = true;
  double yVelocity = 0;

  bool isCollidingGround = false;
  bool isCollidingCeiling = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;

  double jumpForce = 0;

  static const minHealth = 0.0;
  static const maxHealth = 10.0;
  double health = 10;

  double blocksFallen = 0;

  bool isHurt = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      TimerComponent(period: 0.5, repeat: true, onTick: () => isHurt = false),
    );
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    _blockCollision(intersectionPoints, other);
  }

  void _blockCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    intersectionPoints.forEach((Vector2 point) {
      // Ground
      if (point.y > (position.y - (size.y * 0.4)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.4)) {
        isCollidingGround = true;
      }

      // Ceiling
      if (point.y < (position.y - (size.y * 0.9)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.75) &&
          jumpForce >= 0) {
        isCollidingCeiling = true;
      }

      if (point.y < (position.y - (size.y * 0.4))) {
        if (point.x > position.x) {
          isCollidingRight = true;
        } else {
          isCollidingLeft = true;
        }
      }
    });
  }

  void jumpLogic() {
    if (jumpForce > 0) {
      position.y -= jumpForce;
      jumpForce = jumpForce * 0.7;

      if (isCollidingCeiling) {
        jumpForce = 0;
      }
    }
  }

  void gravity(double dt, [int modifier = 0]) {
    if (!isCollidingGround) {
      final adjustedGravity = GameMethods.instance.getGravity(dt) - modifier;
      if (yVelocity < adjustedGravity * 2) {
        yVelocity += adjustedGravity;
      }
      position.y += yVelocity;
      blocksFallen += yVelocity / GameMethods.instance.blockSize.y;
    } else {
      yVelocity = 0;

      if (blocksFallen > 3.5) {
        adjustHealth(-(blocksFallen * 0.5));
      }
      blocksFallen = 0;
    }
  }

  void resetCollision() {
    isCollidingGround = false;
    isCollidingCeiling = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  bool moveLeft(double speed) {
    if (!isCollidingLeft) {
      position.x -= speed;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
      return true;
    }
    return false;
  }

  bool moveRight(double speed) {
    if (!isCollidingRight) {
      position.x += speed;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
      return true;
    }
    return false;
  }

  void stand() {
    jumpForce -= GameMethods.instance.jumpForce * 0.5;
  }

  void jump() {
    if (!isCollidingGround) {
      return;
    }

    if (yVelocity <= 0) {
      jumpForce = GameMethods.instance.jumpForce * 0.5;
    }
  }

  void adjustHealth(double delta) {
    if (delta.isNegative) {
      isHurt = true;
    }

    health = (health + delta).clamp(minHealth, maxHealth);
  }

  void takeDamage(ComponentMotionState direction, double damage) {
    final speed = GameMethods.instance.getSpeed(0.5) / 3;
    if (direction == ComponentMotionState.walkingRight) {
      moveRight(speed);
    } else {
      moveLeft(speed);
    }

    adjustHealth(-damage);
  }

  void killEntityLogic() {
    if (health == 0) {
      removeFromParent();
    }
  }
}
