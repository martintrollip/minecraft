import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/player_data.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 spriteSize = Vector2.all(60);
  final double stepTime = 0.2;
  var isFacingRight = true;
  var yVelocity = 0.0;

  var isCollidingGround = false;
  var isCollidingCeiling = false;
  var isCollidingLeft = false;
  var isCollidingRight = false;

  var jumpForce = 0.0;
  var localPlayerSpeed = 0.0;
  var refreshSpeed = true;

  late SpriteSheet walkingSheet;
  late SpriteSheet idleSheet;

  late SpriteAnimation walkingAnimation =
      walkingSheet.createAnimation(row: 0, stepTime: stepTime / 2);

  late SpriteAnimation idleAnimation =
      idleSheet.createAnimation(row: 0, stepTime: stepTime);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox());

    priority = 2;
    anchor = Anchor.bottomCenter;

    idleSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_idle_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    walkingSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    animation = idleAnimation;

    size = GameMethods.instance.blockSize * 1.5;
    position = Vector2(0, 100);

    add(TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        refreshSpeed = true;
      },
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    intersectionPoints.forEach((Vector2 point) {
      // Ground
      if (point.y > (position.y - (size.y * 0.4)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.4)) {
        isCollidingGround = true;
      }

      // Ceiling
      if (point.y < (position.y - (size.y * 0.75)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.75) && //TODO not detecting
          jumpForce > 0) {
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

  @override
  void update(double dt) {
    super.update(dt);
    _movement(dt);
    _gravity(dt);
    _jumpLogic();
    _resetCollision();

    if (refreshSpeed) {
      localPlayerSpeed = GameMethods.instance.getSpeed(dt);
      refreshSpeed = false;
    }
  }

  void _jumpLogic() {
    if (jumpForce > 0) {
      position.y -= jumpForce;
      jumpForce = jumpForce * 0.7;

      if (isCollidingCeiling) {
        jumpForce = 0;
      }
    }
  }

  void _movement(double dt) {
    switch (GlobalGameReference
        .instance.game.worldData.playerData.componentMotionState) {
      case ComponentMotionState.walkingLeft:
        _moveLeft(localPlayerSpeed);
        break;
      case ComponentMotionState.walkingRight:
        _moveRight(localPlayerSpeed);
        break;
      case ComponentMotionState.idle:
        _stand();
        break;
      case ComponentMotionState.jumping:
        _jump();
        break;
    }
  }

  void _moveLeft(double speed) {
    if (!isCollidingLeft) {
      animation = walkingAnimation;
      position.x -= speed;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    } else {
      // GlobalGameReference.instance.game.worldData.playerData
      //     .componentMotionState = ComponentMotionState.idle;
    }
  }

  void _moveRight(double speed) {
    if (!isCollidingRight) {
      animation = walkingAnimation;
      position.x += speed;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    } else {
      // GlobalGameReference.instance.game.worldData.playerData
      //     .componentMotionState = ComponentMotionState.idle;
    }
  }

  void _stand() {
    animation = idleAnimation;
    jumpForce -= GameMethods.instance.jumpForce * 0.5;
  }

  void _jump() {
    if (yVelocity <= 0) {
      jumpForce = GameMethods.instance.jumpForce;
    }
  }

  void _gravity(double dt) {
    if (!isCollidingGround) {
      final adjustedGravity = GameMethods.instance.getGravity(dt);

      if (yVelocity < adjustedGravity * 5) {
        yVelocity += adjustedGravity;
      }
      position.y += yVelocity;
    } else {
      yVelocity = 0;
    }
  }

  void _resetCollision() {
    isCollidingGround = false;
    isCollidingCeiling = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize * 1.5;
  }
}
